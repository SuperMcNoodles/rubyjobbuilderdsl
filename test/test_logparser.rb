require_relative './test_xml_generator'

class TestXmlLogparser < Test::Unit::TestCase
  def test_postbuild_logparser
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        logparser '/var/lib/jenkins/build_parsing_rules' do
          fail_on_error
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'unstableOnWarning' => 'false',
      'failBuildOnError' => 'true',
      'parsingRulesPath' => '/var/lib/jenkins/build_parsing_rules'
     }.each do |k, v|
       assert_equal v, actual.xpath("./project/publishers/hudson.plugins.logparser.LogParserPublisher/#{k}").text, k
     end
  end
end
