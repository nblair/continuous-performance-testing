# continuous-peformance-testing

This project contains example code demonstrating the capabilities described during my All Day Devops 2017 talk
titled 'Continuous Performance Testing'.

## Developer Requirements

The requirements get progressively steeper the more of the example you wish to run:

If you just want to run the application and gatling simulation locally:

* [Maven](https://maven.apache.org/)

If you wish to deploy the application to Amazon Web Services, you'll need the following on your path:

* [Amazon Web Services credentials](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
* [Terraform](https://www.terraform.io/)
* [git](https://git-scm.com/)
* [jq](https://stedolan.github.io/jq/)

If you want to run everything via Jenkins:

* A [Jenkins](https://jenkins.io/) instance with all of the above on the path
* [Pipeline Maven Plugin](https://wiki.jenkins.io/display/JENKINS/Pipeline+Maven+Plugin)
* [HTML Publisher Plugin](https://wiki.jenkins.io/display/JENKINS/HTML+Publisher+Plugin)
* Optional - [Build User Vars Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Build+User+Vars+Plugin)

## Level 1: Run Application + Simulation locally

In one terminal:

> mvn clean install && java -jar app/target/app-0.0.1-SNAPSHOT.jar server app/src/main/resources/application-defaults.yml

In another terminal:

> mvn verify -pl :performance-testsuite

## Level 2: Deploy application with Terraform

Any property defined in [variables.tf](variables.tf) can be overridden at runtime by adding an environment variable 
prefixed with `TF_VAR_`.

Here are a few examples of variables often locally modified:

```bash
# choose your desired region
export TF_VAR_aws_region=us-east-2
# build_key is included in tags on AWS resources, so we can see "who" (self identified) created them
export TF_VAR_build_key=`whoami`
# identify yourself as the runner; in CI, this can be filled by Jenkins or the developer's email address
export TF_VAR_runner=`someone@somewhere.com`
```

### Run Application in AWS

1. `mvn clean install`
2. `cd performance-testsuite`
3. `mvn dependency:copy-dependencies`
4. `terraform init && terraform apply`
5. `./configure-gatling.sh`
7. `mvn verify -P gatling`

## Level 3: Run in Jenkins

The [Pipeline Multibranch Plugin](https://wiki.jenkins.io/display/JENKINS/Pipeline+Multibranch+Plugin) is included with
recent versions. 

## Create Jenkins build

1. Log into your Jenkins instance
2. Create a new job using the Pipeline Multibranch type
3. Point it at the git repository
4. Use `performance-testsuite/Jenkinsfile`.

## License

Licensed under the [MIT license](https://opensource.org/licenses/MIT).

Happy stress testing!


