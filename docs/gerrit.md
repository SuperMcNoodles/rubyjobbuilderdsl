## Configure job to act on gerrit event

**change_merged**

Description: trigger the job on Gerrit change_merged event

Multiple: Override

Example

    builder.flow 'hello_world-post' do
      gerrit do
        change_merged
        project 'hello_world' do
          branch 'master','release'
        end
      end
    end

**comment_added**

Description: trigger the job on Gerrit comment_added event

Multiple: Override

Example

    builder.flow 'hello_world-gate' do
      gerrit do
        comment_added 'Code-Review' => '2'
        project 'hello_world' do
          branch 'master','release'
        end
      end
    end

**patchset_uploaded**

Description: trigger the job on Gerrit patchset_uploaded event

Multiple: Override

Example

    builder.flow 'hello_world-build' do
      gerrit do
        patchset_uploaded
        project 'hello_world' do
          branch 'master','release'
        end
      end
    end

**project**

Description: Specify a Gerrit event filter that trigger the job

Multiple: Override

Example

    builder.flow 'salesforce-post' do
      gerrit do
        project 'poland/technicalcomponents' do
          branch 'master','release'
          file 'src/Salesforce/**',
               'src/Db/Salesforce/**'
        end
      end
    end
