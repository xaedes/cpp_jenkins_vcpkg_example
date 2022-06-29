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
                stash "source"
            }
        }
        stage('MultiPlatform') {
            parallel {
                stage('Windows') {
                    agent {
                        label "win"
                    }
                    when {
                        anyOf {
                            expression { params.PLATFORM_FILTER == 'all' }
                            expression { params.PLATFORM_FILTER == 'win' }
                        }
                    }
                    stages {
                        stage("scm") {
                            steps {
                            checkout scm
                                unstash "source"
                            }
                        }
                        stage("clean") {
                            steps {
                                bat ".\\ci.bat clean"
                            }
                        }
                        stage("tools") {
                            steps {
                                bat ".\\ci.bat tools"
                            }
                        }
                        stage("build") {
                            steps {
                                bat ".\\ci.bat build"
                            }
                        }
                        stage("test") {
                            steps {
                                bat ".\\ci.bat test"
                            }
                        }
                    }
                }
                stage('Linux') {
                    agent {
                        label "linux"
                    }
                    when {
                        anyOf {
                            expression { params.PLATFORM_FILTER == 'all' }
                            expression { params.PLATFORM_FILTER == 'linux' }
                        }
                    }
                    stages {
                        stage("scm") {
                            steps {
                                sh "pwd"
                                unstash "source"
                            }
                        }
                        stage("clean") {
                            steps {
                                sh "pwd"
                                sh "./ci.sh clean"
                            }
                        }
                        stage("tools") {
                            steps {
                                sh "pwd"
                                sh "./ci.sh tools"
                            }
                        }
                        stage("build") {
                            steps {
                                sh "pwd"
                                sh "./ci.sh build"
                            }
                        }
                        stage("test") {
                            steps {
                                sh "pwd"
                                sh "./ci.sh test"
                            }
                        }
                    }
                }
            }
        }
    }
}