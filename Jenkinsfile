
def deploy_badge_file_linux_agent(path, url) {
    sh '''#!/bin/bash
        echo git clone git@github.com:xaedes/ci-status.git
        echo cd ci-status
        echo git pull
        echo git clean -x -f -f -d
        echo wget -O \"${path}\" \"${url}\"
    '''
}

def deploy_badge_file_win_agent(path, url) {
    bat '''
        echo git clone git@github.com:xaedes/ci-status.git
        echo cd ci-status
        echo git pull
        echo git clean -x -f -f -d
        echo wget -O \"${path}\" \"${url}\"
    '''
}

def generate_badge_path(arch, distribution, build_type) {
    return "ci-status/xaedes/cpp_jenkins_vcpkg_example/${arch}_${distribution}_${build_type}_status.svg"
}
def generate_badge_url(arch, distribution, build_type, color) {
    return "https://shields.io/badge/${arch}_${distribution}-${build_type}-${color}"
}
def deploy_badge(status, platform, build_type, target_triplet, docker_file)
{
    def dockerfile_distributions = [
        'Dockerfile.ubuntu-bionic' : 'ubuntu:bionic' , 
        'Dockerfile.ubuntu-focal'  : 'ubuntu:focal'  , 
        'Dockerfile.ubuntu-jammy'  : 'ubuntu:jammy'  , 
        'Dockerfile.ubuntu-xenial' : 'ubuntu:xenial'     
    ]
    def triplet_archs = [
        'x64-linux'   : 'x64' , 
        'x86-linux'   : 'x86' , 
        'x64-windows' : 'x64' , 
        'x86-windows' : 'x86' 
    ]
    def status_colors = [
        'success'  : 'brightgreen' , 
        'failure'  : 'red'         , 
        'building' : 'blue' 
    ]

    distribution = (platform == "win") ? "windows" : dockerfile_distributions[docker_file]
    arch = triplet_archs[target_triplet]
    color = status_colors[status]
    
    path = generate_badge_path(arch, distribution, build_type)
    url = generate_badge_url(arch, distribution, build_type, color)

    echo "deploy_badge"
    echo "status: ${status}"
    echo "path: ${path}"
    echo "url: ${url}"
    if (platform == "win") {
        deploy_badge_file_win_agent(path, url)
    } else if (platform == "linux") {
        deploy_badge_file_linux_agent(path, url)
    }
}
def status_success()  { return "success" }
def status_failure()  { return "failure" }
def status_building() { return "building" }

pipeline {
    parameters {
        choice(name: 'PLATFORM_FILTER', choices: ['all', 'linux', 'win'], description: 'Run on specific platform')
        choice(name: 'DOCKER_FILE_FILTER', choices: ['all', 'Dockerfile.ubuntu-bionic', 'Dockerfile.ubuntu-focal', 'Dockerfile.ubuntu-jammy', 'Dockerfile.ubuntu-xenial'], description: 'Run on specific docker file')
    }
    agent none
    stages {
        stage('scm') {
            agent any
            steps {
                checkout scm
                stash 'source'
            }
        }
        stage('MultiPlatform') {
            matrix {
                axes {
                    axis {
                        name 'PLATFORM'
                        values 'linux', 'win'
                    }
                    axis {
                        name 'BUILD_TYPE'
                        values 'Release', 'Debug'
                    }
                    axis {
                        name 'TARGET_TRIPLET'
                        values 'x64-linux', 'x86-linux', 'x64-windows', 'x86-windows'
                    }
                    axis {
                        name 'DOCKER_FILE'
                        values 'Dockerfile.ubuntu-bionic', 'Dockerfile.ubuntu-focal', 'Dockerfile.ubuntu-jammy', 'Dockerfile.ubuntu-xenial'
                    }
                }
                excludes {
                    exclude {
                        axis {
                            name 'PLATFORM'
                            values 'linux'
                        }
                        axis {
                            name 'TARGET_TRIPLET'
                            values 'x64-windows', 'x86-windows'
                        }
                    }
                    exclude {
                        axis {
                            name 'PLATFORM'
                            values 'win'
                        }
                        axis {
                            name 'TARGET_TRIPLET'
                            values 'x64-linux', 'x86-linux'
                        }
                    }
                    exclude {
                        axis {
                            name 'PLATFORM'
                            values 'win'
                        }
                        axis {
                            name 'DOCKER_FILE'
                            values 'Dockerfile.ubuntu-focal', 'Dockerfile.ubuntu-jammy', 'Dockerfile.ubuntu-xenial'
                        }
                    }
                }
                stages {

                    stage('Windows') {
                        agent {
                            label 'win'
                        }
                        when {
                            allOf {
                                anyOf {
                                    expression { params.PLATFORM_FILTER == 'all' }
                                    expression { params.PLATFORM_FILTER == 'win' }
                                }
                                expression { env.PLATFORM == 'win' }
                            }
                        }
                        stages {
                            stage("scm-win") {
                                steps {
                                    unstash 'source'
                                    bat 'git clean -x -f -f -d'
                                    deploy_badge(status_building(), env.PLATFORM, env.BUILD_TYPE, env.TARGET_TRIPLET, env.DOCKER_FILE)
                                }
                            }
                            // stage("clean-win") {
                            //     steps {
                            //         bat ".\\ci.bat clean ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                            // stage("tools-win") {
                            //     steps {
                            //         bat ".\\ci.bat tools ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                            // stage("build-win") {
                            //     steps {
                            //         bat ".\\ci.bat build ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                            // stage("test-win") {
                            //     steps {
                            //         bat ".\\ci.bat test ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                        }
                        post {
                            success {
                                echo "Success! ${PLATFORM} ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                deploy_badge(status_success(), env.PLATFORM, env.BUILD_TYPE, env.TARGET_TRIPLET, env.DOCKER_FILE)
                                
                                // sh "git clone git@github.com:xaedes/ci-status.git"
                                // sh "sh cd ci-status && wget -O ci-status/xaedes/cpp_jenkins_vcpkg_example/${PLATFORM}_${BUILD_TYPE}_${TARGET_TRIPLET}_status.svg https://shields.io/badge/docker-ubuntu_bionic_x64-brightgreen "
                            }
                            failure {
                                echo "Failure! ${PLATFORM} ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                deploy_badge(status_failure(), env.PLATFORM, env.BUILD_TYPE, env.TARGET_TRIPLET, env.DOCKER_FILE)
                            }
                        }
                    }
                    stage('Linux') {
                        agent {
                            dockerfile { 
                                label 'linux'
                                filename "${DOCKER_FILE}" 
                                dir '.ci'
                            }
                        }
                        when {
                            allOf {
                                anyOf {
                                    expression { params.PLATFORM_FILTER == 'all' }
                                    expression { params.PLATFORM_FILTER == 'linux' }
                                }
                                anyOf {
                                    expression { params.DOCKER_FILE_FILTER == 'all' }
                                    expression { params.DOCKER_FILE_FILTER == env.DOCKER_FILE }
                                }
                                expression { env.PLATFORM == 'linux' }
                            }
                        }
                        stages {
                            stage("scm-linux") {
                                steps {
                                    unstash 'source'
                                    sh 'git clean -x -f -f -d'
                                    deploy_badge(status_building(), env.PLATFORM, env.BUILD_TYPE, env.TARGET_TRIPLET, env.DOCKER_FILE)
                                }
                            }
                            // stage("clean-linux") {
                            //     steps {
                            //         sh "sh ./ci.sh clean ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                            // stage("tools-linux") {
                            //     steps {
                            //         sh "sh ./ci.sh tools ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                            // stage("build-linux") {
                            //     steps {
                            //         sh "sh ./ci.sh build ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                            // stage("test-linux") {
                            //     steps {
                            //         sh "sh ./ci.sh test ${BUILD_TYPE} ${TARGET_TRIPLET}"
                            //     }
                            // }
                        }
                        post {
                            success {
                                echo "Success! ${PLATFORM} ${DOCKER_FILE} ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                deploy_badge(status_success(), env.PLATFORM, env.BUILD_TYPE, env.TARGET_TRIPLET, env.DOCKER_FILE)
                            }
                            failure {
                                echo "Failure! ${PLATFORM} ${DOCKER_FILE} ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                deploy_badge(status_failure(), env.PLATFORM, env.BUILD_TYPE, env.TARGET_TRIPLET, env.DOCKER_FILE)
                            }
                        }
                    }
                }
            }
        }
    }
}