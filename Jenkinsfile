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
                        value 'linux', 'win'
                    }
                    axis {
                        name 'BUILD_TYPE'
                        value 'Release', 'Debug'
                    }
                }
                excludes {

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
                            stage('scm-win') {
                                steps {
                                    unstash 'source'
                                    bat 'git clean -x -f -f -d'
                                }
                            }
                            stage('clean-win') {
                                steps {
                                    bat '.\\ci.bat clean ${BUILD_TYPE}'
                                }
                            }
                            stage('tools-win') {
                                steps {
                                    bat '.\\ci.bat tools ${BUILD_TYPE}'
                                }
                            }
                            stage('build-win') {
                                steps {
                                    bat '.\\ci.bat build ${BUILD_TYPE}'
                                }
                            }
                            stage('test-win') {
                                steps {
                                    bat '.\\ci.bat test ${BUILD_TYPE}'
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
                            stage('scm-linux') {
                                steps {
                                    unstash 'source'
                                    sh 'git clean -x -f -f -d'
                                }
                            }
                            stage('clean-linux') {
                                steps {
                                    sh 'sh ./ci.sh clean ${BUILD_TYPE}'
                                }
                            }
                            stage('tools-linux') {
                                steps {
                                    sh 'sh ./ci.sh tools ${BUILD_TYPE}'
                                }
                            }
                            stage('build-linux') {
                                steps {
                                    sh 'sh ./ci.sh build ${BUILD_TYPE}'
                                }
                            }
                            stage('test-linux') {
                                steps {
                                    sh 'sh ./ci.sh test ${BUILD_TYPE}'
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}