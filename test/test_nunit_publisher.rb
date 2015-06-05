require_relative './test_xml_generator'

class TestXmlNUnitPublisher < Test::Unit::TestCase
  def test_postbuild_nunit_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_nunit_report 'a\\b'
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'testResultsPattern' => 'a\\b' }.each do |k, v|
       assert_equal v, actual.xpath(
         "./project/publishers/hudson.plugins.nunit.NUnitPublisher/#{k}").text, k
     end
  end
end
