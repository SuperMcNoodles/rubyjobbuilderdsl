require_relative './test_xml_generator'

class TestXmlBlockingJob < Test::Unit::TestCase
  def test_blocking_job
    builder = JenkinsJob::Builder.new

    builder.freestyle 'pre-deploy' do
      blocked_by 'deploy', 'post-deploy'
    end

    actual = builder.config_as_xml_node('pre-deploy')

    { 'useBuildBlocker' => 'true',
      'blockingJobs' => "deploy\npost-deploy" }.each do |k, v|
      assert v, actual.xpath("./project/properties/hudson.plugins.buildblocker.BuildBlockerProperty/#{k}").text
    end
  end
end
