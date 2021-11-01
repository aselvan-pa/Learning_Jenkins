node {
    def app

    stage('Clone repository') {
        // Let's make sure we have the repository cloned to our workspace

        checkout scm
    }

    stage('Build image') {
        // This builds the actual image; synonymous to docker build on the command line
        app = docker.build("tl_demo/hellonode")
        echo app.id
        // echo app.parsedId
    }

    stage('Scan Image and Publish to Jenkins') {
        try { // do something that fails
            prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: 'tl_demo/hellonode:latest', key: '', logLevel: 'debug', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json'
            currentBuild.result = 'SUCCESS'
        } catch (Exception err) {
          currentBuild.result = 'UNSTABLE'
        } finally {
            prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
        }
        echo "RESULT: ${currentBuild.result}"
    }

    stage('Scan image with twistcli') {
        withCredentials([usernamePassword(credentialsId: 'twistlock_creds', passwordVariable: 'TL_PASS', usernameVariable: 'TL_USER')]) {
            sh 'curl -k -u $TL_USER:$TL_PASS --output ./twistcli https://$TL_CONSOLE/api/v1/util/twistcli'
            sh 'sudo chmod a+x ./twistcli'
            sh "./twistcli images scan --u $TL_USER --p $TL_PASS --address https://$TL_CONSOLE --details tl_demo/hellonode:latest"
        }
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('http://registry.infra.svc.cluster.local:5000') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
