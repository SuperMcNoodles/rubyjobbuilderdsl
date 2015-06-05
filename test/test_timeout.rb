require_relative './test_xml_generator'

class TestXmlTimeout < Test::Unit::TestCase
  def test_timeout
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      timeout 'elastic' do
        elastic_percentage 200
        elastic_default_timeout 30
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'timeoutMinutes' => '3', 'failBuild' => 'false', 'writingDescription' => 'false', 'timeoutPercentage' => '200',
     'timeoutMinutesElasticDefault' => '30',  'timeoutType' =>  'elastic' }.each do |k, v|
      assert_equal v, actual.xpath("./project/buildWrappers/hudson.plugins.build__timeout.BuildTimeoutWrapper/#{k}").text, k
    end
  end
end
