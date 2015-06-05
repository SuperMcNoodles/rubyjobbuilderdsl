require_relative './test_xml_generator'

class TestXmlXTapPublisher < Test::Unit::TestCase
  def test_postbuild_tap_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_tap 'TestResultsInTapFormat.tap' do
          verbose true
          require_plan true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'testResults' => 'TestResultsInTapFormat.tap',
      'verbose' => 'true',
      'require_plan' => 'true'
    }.each do |k, v|
      assert v, actual.xpath("./project/publishers/org.tap4j.plugin.TapPublisher/#{k}").text
    end
  end
end
