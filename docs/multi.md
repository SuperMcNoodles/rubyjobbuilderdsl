## Create multi job project

**phase**

Description: Run a job phase. Phases are executed sequentially, however jobs within a phase run in parallel.

Multiple: Add

Example

    builder.multi 'hello_world-deploy' do
      phase 'hello_world-db-deploy' do
        job 'foo-db'

        job 'bar-db' do
          ignore_result true
        end
      end

      phase 'hello_world-service-deploy' do
        job 'foo-service' do
          retries 1
          abort_others false
        end
        job 'bar-service'
      end
    end