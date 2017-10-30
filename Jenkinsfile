properties([
	pipelineTriggers([
		cron('H H(3-7) * * *')
	])
])
node("master")
{
	ws
	{
		stage('Checkout')
		{
			checkout(
				[$class: 'GitSCM', branches: [[name: '*/master']],
				userRemoteConfigs: [[credentialsId: 'Sinautzki',
				url: 'https://github.com/Sinautzki/centos_cmake.git']]]
			)
		}

		registry_url="https://hub.docker.com/r/"
		docker_creds_id="sinautzki"
		origin="sinautzki"
		image_name="centos_cmake"
		build_tag="3.9.0"
		docker.withRegistry("${registry_url}", "${docker_creds_id}") {

			stage('Create Image')
			{
				sh '''
					docker build -t sinautzki/cmake:3.9.0 .
				'''
			}

			stage('Push to registry')
			{
				def image = docker.image("${origin}/${image_name}:${build_tag}")
				image.push()
				currentBuild.result = 'SUCCESS'
			}
			stage('Clean')
			{
				sh '''
				   docker rmi -f hub.docker.com/r/sinautzki/cmake:3.9.0
				   docker rmi -f sinautzki/cmake:3.9.0
					 docker system prune -a -f
				'''
				deleteDir()
			}
			stage('Notify')
			{
				step([$class: 'StashNotifier'])
				emailext (
					subject: "'${currentBuild.result}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
					body: """'${currentBuild.result}' : Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
					Check console output at '${env.BUILD_URL}'
					""",
					recipientProviders: [[$class: 'DevelopersRecipientProvider']]
				)
			}
		}
	}
}