pipeline {
    parameters {
        choice(name: 'PLATFORM_FILTER', choices: ['all', 'linux', 'win'], description: 'Run on specific platform')
    }
    agent none
    stages {
        stage('scm') {
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
                                bat "jenkins.bat clean"
                            }
                        }
                        stage("tools") {
                            steps {
                                bat "jenkins.bat tools"
                            }
                        }
                        stage("build") {
                            steps {
                                bat "jenkins.bat build"
                            }
                        }
                        stage("test") {
                            steps {
                                bat "jenkins.bat test"
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
                                unstash "source"
                            }
                        }
                        stage("clean") {
                            steps {
                                sh "jenkins.sh clean"
                            }
                        }
                        stage("tools") {
                            steps {
                                sh "jenkins.sh tools"
                            }
                        }
                        stage("build") {
                            steps {
                                sh "jenkins.sh build"
                            }
                        }
                        stage("test") {
                            steps {
                                sh "jenkins.sh test"
                            }
                        }
                    }
                }
            }
        }
    }
}