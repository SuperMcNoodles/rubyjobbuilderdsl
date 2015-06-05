## Create free style project

**ant**

Description: Run ant task

Multiple: Add

Example

    builder.freestyle 'hello_world-build' do
      ant do
        target 'clean', 'lint'
        buildfile 'nightly.xml'
        java_opts '-Xmx512m', '-Xms512m'
        property 'skipTest' => 'false'
      end
    end

**batch**

Description: Run batch command

Multiple: Add

Example

    builder.freestyle 'hello_world-master' do
      batch 'sc.exe query'
    end

**copyartifact**

Description: Copy artifact from other build

Multiple: Add

Example

    builder.freestyle 'hello_world-servicetest' do
      copyartifact '$ARTIFACT_JOB' do
        build_number '$ARTIFACT_BUILD_NUMBER'
        file 'package/**',
             'output/**'
        to '$BUILD_NUMBER'
      end
    end

**inject_env**

Description: Create environment variable that persists in the build

Multiple: Add

Example

    builder.freestyle 'hello_world-build' do
      inject_env do
        properties_content 'EXAMPLE=foo'
        properties_file 'env.prop'
      end
    end

**powershell**

Description: Run Powershell command

Multiple: Add

Example

    builder.freestyle 'hello_world-master' do
      powershell 'Get-Service MSQL* | foreach { sc.exe stop $_.Name }'
    end

**shell**

Description: Run shell command

Multiple: Add

Example

    builder.freestyle 'ops-master' do
      shell 'rm -rf * || true'
    end

**workspace**

Description: Set custom workspace for job

Multiple:  Override

Example

    builder.freestyle 'ops-master' do
      workspace 'ops-m'
    end


