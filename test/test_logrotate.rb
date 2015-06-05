require_relative './test_xml_generator'

class TestXmlLogrotate < Test::Unit::TestCase
  def test_logrotate
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      logrotate do
        days_to_keep 14
        num_to_keep(-1)
        artifact_days_to_keep 2
        artifact_num_to_keep(-1)
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'daysToKeep' => '14', 'numToKeep' => '-1', 'artifactDaysToKeep' => '2', 'artifactNumToKeep' => '-1' }.each do |k, v|
      assert_equal v, actual.xpath("./project/logRotator/#{k}").text, k
    end
  end
end
