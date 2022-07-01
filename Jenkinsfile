pipeline {
    parameters {
        choice(name: 'PLATFORM_FILTER', choices: ['all', 'linux', 'win'], description: 'Run on specific platform')
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
                                }
                            }
                            stage("clean-win") {
                                steps {
                                    bat ".\\ci.bat clean ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                            stage("tools-win") {
                                steps {
                                    bat ".\\ci.bat tools ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                            stage("build-win") {
                                steps {
                                    bat ".\\ci.bat build ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                            stage("test-win") {
                                steps {
                                    bat ".\\ci.bat test ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
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
                                expression { env.PLATFORM == 'linux' }
                            }
                        }
                        stages {
                            stage("scm-linux") {
                                steps {
                                    unstash 'source'
                                    sh 'git clean -x -f -f -d'
                                }
                            }
                            stage("clean-linux") {
                                steps {
                                    sh "sh ./ci.sh clean ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                            stage("tools-linux") {
                                steps {
                                    sh "sh ./ci.sh tools ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                            stage("build-linux") {
                                steps {
                                    sh "sh ./ci.sh build ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                            stage("test-linux") {
                                steps {
                                    sh "sh ./ci.sh test ${BUILD_TYPE} ${TARGET_TRIPLET}"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}