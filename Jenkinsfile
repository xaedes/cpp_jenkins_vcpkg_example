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
                    // axis {
                    //     name 'TARGET_TRIPLET'
                    //     values 'x64-linux', 'x86-linux', 'x64-windows', 'x86-windows'
                    // }
                }
                // excludes {
                //     exclude {
                //         axis {
                //             name 'PLATFORM'
                //             values 'linux'
                //         }
                //         axis {
                //             name 'TARGET_TRIPLET'
                //             values 'x64-windows', 'x86-windows'
                //         }
                //     }
                //     exclude {
                //         axis {
                //             name 'PLATFORM'
                //             values 'win'
                //         }
                //         axis {
                //             name 'TARGET_TRIPLET'
                //             values 'x64-linux', 'x86-linux'
                //         }
                //     }
                // }
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
                            stage("scm-win ${BUILD_TYPE}") {
                                steps {
                                    unstash 'source'
                                    bat 'git clean -x -f -f -d'
                                }
                            }
                            stage("clean-win ${BUILD_TYPE}") {
                                steps {
                                    bat ".\\ci.bat clean ${BUILD_TYPE}"
                                }
                            }
                            stage("tools-win ${BUILD_TYPE}") {
                                steps {
                                    bat ".\\ci.bat tools ${BUILD_TYPE}"
                                }
                            }
                            stage("build-win ${BUILD_TYPE}") {
                                steps {
                                    bat ".\\ci.bat build ${BUILD_TYPE}"
                                }
                            }
                            stage("test-win ${BUILD_TYPE}") {
                                steps {
                                    bat ".\\ci.bat test ${BUILD_TYPE}"
                                }
                            }
                        }
                    }
                    stage('Linux') {
                        agent {
                            dockerfile { 
                                label 'linux'
                                filename 'Dockerfile.ubuntu-bionic' 
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
                            stage("scm-linux ${BUILD_TYPE}") {
                                steps {
                                    unstash 'source'
                                    sh 'git clean -x -f -f -d'
                                }
                            }
                            stage("clean-linux ${BUILD_TYPE}") {
                                steps {
                                    sh "sh ./ci.sh clean ${BUILD_TYPE}"
                                }
                            }
                            stage("tools-linux ${BUILD_TYPE}") {
                                steps {
                                    sh "sh ./ci.sh tools ${BUILD_TYPE}"
                                }
                            }
                            stage("build-linux ${BUILD_TYPE}") {
                                steps {
                                    sh "sh ./ci.sh build ${BUILD_TYPE}"
                                }
                            }
                            stage("test-linux ${BUILD_TYPE}") {
                                steps {
                                    sh "sh ./ci.sh test ${BUILD_TYPE}"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}