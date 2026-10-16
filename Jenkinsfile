pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Contexte') {
            steps {
                echo "Branche            : ${env.BRANCH_NAME}"
                echo "Merge request      : ${env.CHANGE_ID ?: 'non'}"
                echo "Source -> cible    : ${env.CHANGE_BRANCH ?: '-'} -> ${env.CHANGE_TARGET ?: '-'}"
                echo "Tag                : ${env.TAG_NAME ?: '-'}"
                sh 'git log -1 --pretty=format:"Dernier commit : %h - %an - %s"'
            }
        }

        stage('Règle de flux') {
            when {
                changeRequest target: 'main'
            }
            steps {
                script {
                    if (!(env.CHANGE_BRANCH ==~ /(release|hotfix)\/.+/)) {
                        error "Une merge request vers main doit provenir d'une branche release/* ou hotfix/* (source : ${env.CHANGE_BRANCH})"
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh 'sh scripts/build.sh'
            }
        }

        stage('Tests') {
            steps {
                sh 'sh scripts/test.sh'
            }
        }

        stage('Déploiement recette') {
            when {
                branch 'develop'
            }
            steps {
                sh 'echo "Déploiement simulé de la version $(cat VERSION) en RECETTE"'
            }
        }

        stage('Release candidate') {
            when {
                branch pattern: 'release/.*', comparator: 'REGEXP'
            }
            steps {
                sh 'echo "Release candidate $(cat VERSION) prête pour validation"'
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
            }
        }

        stage('Déploiement production') {
            when {
                branch 'main'
            }
            steps {
                sh 'echo "Déploiement simulé de la version $(cat VERSION) en PRODUCTION"'
            }
        }

        stage('Publication de la release') {
            when {
                buildingTag()
            }
            steps {
                sh 'echo "Publication de la release ${TAG_NAME}"'
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Pipeline réussi.'
        }
        failure {
            echo 'Pipeline en échec.'
        }
    }
}