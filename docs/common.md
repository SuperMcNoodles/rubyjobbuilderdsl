## Common vocabulary

Common keywords are applicable for both freestyle job and flow job.

**artifactory**

Description: Deploy artifacts to jfrog artifactory server

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      artifactory do
        server 'artifactory.acme.com'
        repository 'dev'
        deploy 'hello_world-1.0.$BUILD_NUMBER.zip'
      end
    end

**blocked_by**

Description: Block build if certain specified jobs are running

Multiple: Add

Example

    builder.freestyle 'hello_world-deploy' do
      blocked_by 'hello_world-sevicetest'
    end

**Builder**

Description: We create builder instance that will be used later to build jobs

Multiple: N/A

Example

    require 'rubyjobbuilderdsl'
    builder = JenkinsJob::Builder.new

**concurrent**

Description: Specify condition for multiple builds of the same job to run concurrently across all nodes of the same category

Multiple: Override

Example

    builder.freestyle 'hello_world-servicetest' do
      concurrent do
        max_per_node 1
        max_total 0
        category 'servicetest'
      end
    end

**concurrent**

Description: Specify condition for multiple builds of the same job to run concurrently across all nodes of the same project

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      concurrent do
        max_per_node 2
        max_total 0
      end
    end

**Deployer**

Description: We create deployer instance that will be used to generate/deploy jobs config

Multiple: N/A

Example

    require 'rubyjobbuilderdsl'
    check_builder = JenkinsJob::Builder.new
    worker_builder = JenkinsJob::Builder.new
    JenkinsJob::Deployer.new(check_builder, worker_builder).run


**Desc**

Description: Specify project's description

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      desc 'this is a hello world project'
    end

**flow**

Description: Add Create a flow job

Multiple: Add

Example

    builder.flow 'hello_world-check' do
    end

**freestyle**

Description: Add Create a freestyle job

Multiple: Add

Example

    builder.freestyle 'hello_world-build' do
    end

**gerrit**

Description: trigger the job on Gerrit event

Multiple: Override

Example

    builder.flow 'hello_world-post' do
      gerrit do
      end
    end


**git**

Description: Configure Git version as SCM

Multiple: Override

Example:

    builder.freestyle 'hello_world-master' do
      git do
      end
    end

**logrotate**

Description: Rotate/discard old builds

Multiple: Override

Example:

    builder.freestyle 'hello_world-master' do
      logrotate do
        days_to_keep 14
        num_to_keep -1
        artifact_days_to_keep 2
        artifact_num_to_keep -1
      end
    end

**node**

Description: Run a job on specific node or kind of nodes

Multiple: Override

Example:

    builder.freestyle 'hello_world-build' do
      node 'windows'
    end

**parameter**

Description: Create parameter for a job

Multiple: Add

Example:

    builder.freestyle 'hello_world-check' do
      parameter 'GERRIT_BRANCH' do
        default 'master'
      end
      parameter 'GERRIT_REFSPEC' do
        default 'refs/heads/${GERRIT_BRANCH}'
      end
    end

**password**

Description: Specify password encrypted by jenkins, that is decrypted when being retrieved via environment variable

Multiple: Override

Example:

    builder.freestyle 'hello_world-deploy' do
      password 'ADMIN', 'PhxHFCjgSiXR2umXhALLq+RzqJBxODDJT4t9Tw5JXbI='
    end

**password_parameter**

Description: Create a parameter for password for a job

Multiple: Add

Example:

    builder.freestyle 'hello_world-check' do
      password_parameter 'PASS' do
        default 'xyz#'
      end
    end

**pollscm**

Description: Specify SCM polling frequency in crontab format

Multiple: Override

Example:

    builder.freestyle 'hello_world-master' do
      pollscm '*/5 * * * *'
    end

**postbuild**

Description: Create post build actions freestyle/flow

Multiple: Merged

Example:

    builder.freestyle 'hello_world-master' do
      postbuild do
      end
    end

**quiet_period**

Description: Wait a specified period in seconds before running freestyle/flow

Multiple: Override

Example:

    builder.freestyle 'hello_world-build' do
      quiet_period 5
    end

**scms**

Description: Configure multiple SCM's

Multiple: Override

Example:

    builder.freestyle 'hello_world-master' do
      scms do
        git do
        end
        git do
        end
      end
    end

**timed**

Description: Specify frequency to run a build in crontab format  freestyle/flow

Multiple: Override

Example:

    builder.freestyle 'hello_world-master' do
      timed '*/5 * * * *'
    end

**timeout**

Description: Specify elastic timeout as percentage of last 3 successful builds or absolute value in minutes if they are not available

Multiple: Override

Example:

    builder.freestyle 'hello_world-build' do
      timeout 'elastic' do
        elastic_percentage 200
        elastic_default_timeout 30
      end
    end

**timestamps**

Description: Show time stamp for build's console log

Multiple: Override

Example:

    builder.freestyle 'hello_world-build' do
      timestamps
    end
