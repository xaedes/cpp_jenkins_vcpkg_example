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
            parallel {
                stage('Windows') {
                    agent {
                        label 'win'
                    }
                    when {
                        anyOf {
                            expression { params.PLATFORM_FILTER == 'all' }
                            expression { params.PLATFORM_FILTER == 'win' }
                        }
                    }
                    stages {
                        stage('scm-win') {
                            steps {
                                unstash 'source'
                                // checkout scm
                            }
                        }
                        stage('clean-win') {
                            steps {
                                bat '.\\ci.bat clean'
                            }
                        }
                        stage('tools-win') {
                            steps {
                                bat '.\\ci.bat tools'
                            }
                        }
                        stage('build-win') {
                            steps {
                                bat '.\\ci.bat build'
                            }
                        }
                        stage('test-win') {
                            steps {
                                bat '.\\ci.bat test'
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
                        anyOf {
                            expression { params.PLATFORM_FILTER == 'all' }
                            expression { params.PLATFORM_FILTER == 'linux' }
                        }
                    }
                    stages {
                        stage('scm-linux') {
                            steps {
                                unstash 'source'
                                sh 'git clean -x -f -d'
                                sh 'git status'
                                sh 'cmake --version'
                                sh 'cmake --help'
                                // checkout scm
                            }
                        }
                        stage('clean-linux') {
                            steps {
                                sh 'sh ./ci.sh clean'
                            }
                        }
                        stage('tools-linux') {
                            steps {
                                sh 'sh ./ci.sh tools'
                            }
                        }
                        stage('build-linux') {
                            steps {
                                sh 'sh ./ci.sh build'
                            }
                        }
                        stage('test-linux') {
                            steps {
                                sh 'sh ./ci.sh test'
                            }
                        }
                    }
                }
            }
        }
    }
}