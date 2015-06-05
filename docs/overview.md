## Overview

The Openstack Job Builder python project use YAML as input for job creation. It is huge step from creating job using XML or even worse UI.
However YAML has limitation lacking of both composition and abstraction causing repetitive work and maintenance issue . It may well suit for
creating of dozen of jobs but not hundreds similar jobs. This is driving factor for creation of Ruby Job Builder DSL.

Ruby Jobs Builder DSL is ruby internal DSL, so it offers full fledged programming experience at the same time concise, focused vocabulary
for job creation.

Ruby Jobs Builder DSL can

* generate Jenkins XML job configuration files
* deploy jobs directly into Jenkins Server

## Example

Step 1 - Create a ruby  file e.g. hello-world.rb with the following content

    # hello-world.rb
    require 'rubyjobbuilderdsl'
    builder = JenkinsJob::Builder.new
    builder.freestyle 'hello-world' do
      shell 'echo hello world'
    end
    JenkinsJob::Deployer.new(builder).run


Step 2 - Run it

    $bundle exec ruby hello-world.rb
    Usage:
    hello-world.rb [--yaml|--xml --output-dir=.|--deploy --config-file=localhost.ini]

Step 3 - Create XML


    sh-3.1$ bundle exec ruby hello_world.rb --xml --output-dir=.
    creating hello-world
    sh-3.1$ cat hello-world.xml
    <project>
      <actions/>
      <description>&lt;!-- Managed by Jenkins Job Builder --&gt;</description>
      <keepDependencies>false</keepDependencies>
      <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
      <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
      <concurrentBuild>false</concurrentBuild>
      <canRoam>true</canRoam>
      <properties/>
      <scm class="hudson.scm.NullSCM"/>
      <publishers/>
      <buildWrappers/>
      <builders>
        <hudson.tasks.Shell>
          <command>echo hello world</command>
        </hudson.tasks.Shell>
      </builders>
    </project>

Step 4 - Upload the created job to your Jenkins server

    sh-3.1$ cat localhost.ini
    [jenkins]
    url=http://localhost:8080/
    user=jenkins-jobs
    password=7bb352e4f3da683c17247f3abf88f47c

    sh-3.1$ bundle exec ruby hello_world.rb --deploy ----config-file=localhost.ini
    deploying hello-world

## References

* http://ci.openstack.org/jenkins-job-builder/
* https://github.com/jenkinsci/jenkins.rb
* https://github.com/jenkinsci/job-dsl-plugin/wiki/Job-DSL-Commands