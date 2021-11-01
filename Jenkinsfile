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

}
