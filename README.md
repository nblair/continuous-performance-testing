# continuous-peformance-testing

This project contains example code demonstrating the capabilities described during my All Day Devops 2017 talk
titile 'Continuous Performance Testing'.

## Developer Requirements

The requirements get progressively steeper the more of the example you wish to run:

1. Maven - if you just want to run the application and the Gatling simulation
2. git and jq on your path
3. Terraform + Amazon Web Service credentials (if you want to run the system under test in AWS)
4. A Jenkins instance (if you want to run this all in a Continuous Integration pipeline)

## Run Application + Simulation locally

In one terminal:

> mvn clean install && java -jar app/target/app-0.0.1-SNAPSHOT.jar server app/src/main/resources/application-defaults.yml

In another terminal:

> mvn verify -pl :performance-testsuite

## Next Level: Deploy application with Terraform

Any property defined in [variables.tf](variables.tf) can be overridden at runtime by adding an environment variable 
prefixed with `TF_VAR_`.

Here are a few examples of variables often locally modified:

```bash
# choose your desired region
export TF_VAR_aws_region=us-east-2
# build_key is included in tags on AWS resources, so we can see "who" (self identified) created them
export TF_VAR_build_key=`whoami`
# identify yourself as the runner; in CI, this can be filled by 'jenkins' or the developer's email address
export TF_VAR_runner=`someone@somewhere.com`
```

## Run Application in AWS

1. `mvn clean install`
2. `cd performance-testsuite`
3. `mvn dependency:copy-dependencies`
3. `terraform init && terraform apply`
4. `cd ..`
5. `mvn verify -pl :performance-testsuite`

## Next Level: Run in Jenkins

This assumes you have a Jenkins instance available to run.

The [Pipeline Multibranch Plugin](https://wiki.jenkins.io/display/JENKINS/Pipeline+Multibranch+Plugin) is included with
recent versions. 
Install [Pipeline Maven Plugin](https://wiki.jenkins.io/display/JENKINS/Pipeline+Maven+Plugin).
Install [HTML Publisher Plugin](https://wiki.jenkins.io/display/JENKINS/HTML+Publisher+Plugin).

You'll need the following to be on the path for the user running Jenkins:

1. `terraform`
2. `jq`

## Create Jenkins build

1. Log into your Jenkins instance
2. Create a new job using the Pipeline Multibranch type
3. Point it at the git repository
4. Use `performance-testsuite/Jenkinsfile`.

## License

Licensed under ...

Happy stress testing!


