# continuous-peformance-testing

This project contains example code demonstrating the capabilities described during my All Day Devops 2017 talk
titile 'Continuous Performance Testing'.

## Developer Requirements

The requirements get progressively steeper the more of the example you wish to run:

1. Maven - if you just want to run the application and the Gatling simulation
2. Terraform + Amazon Web Service credentials (if you want to run the system under test in AWS)
3. A Jenkins instance (if you want to run this all in a Continuous Integration pipeline)

## Run Application + Simulation locally

In one terminal:

> mvn clean install && java -jar app/target/app-0.0.1-SNAPSHOT.jar server application-defaults.yml

In another terminal:

> mvn verify -pl :performance-testsuite

## Run Application in AWS

1. `mvn clean install`
2. `cd performance-testsuite`
3. `terraform init && terraform apply`
4. `cd ..`
5. `mvn verify -pl :performance-testsuite`

## Run in Jenkins

1. Log into your Jenkins instance
2. Install the [Pipeline Multibranch Plugin](https://wiki.jenkins.io/display/JENKINS/Pipeline+Multibranch+Plugin)
3. Create a new job using the Pipeline Multibranch type
4. Point it at the git repository
5. Use `performance-testsuite/Jenkinsfile`.

Happy stress testing!


