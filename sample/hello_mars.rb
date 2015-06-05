require_relative '../lib/rubyjobbuilderdsl'

builder = JenkinsJob::Builder.new

builder.freestyle 'hello_mars' do
  shell 'echo hello mars > hello_mars-1.0.$BUILD_NUMBER.txt && gzip hello_mars-1.0.$BUILD_NUMBER.txt'
end

builder.view 'test' do
  job 'test-.*'
end

JenkinsJob::Deployer.new(builder).run do
  disable_job 'hello_mars'
  wipeout_workspace 'hello_mars'
  delete_job 'hello_mars'
  delete_view 'test'

  each do |name, xml, type|
    upload_view(name, xml) if type == :view
    upload_job(name, xml) if type == :job
  end

  groovysh 'println "hello world"'
  enable_job 'hello_mars'
  trigger_job 'hello_mars'
end
