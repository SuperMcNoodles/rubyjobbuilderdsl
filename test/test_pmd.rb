require_relative './test_xml_generator'

class TestXmlAnt < Test::Unit::TestCase
  def test_javadoc
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_pmd do
          pmd_results 'build/phppmd.txt'
        end
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'pattern' => 'build/phppmd.txt',
      'thresholdLimit' => 'low',
      'pluginName' => '[PMD]' }.each do |k, v|
      assert_equal v, actual.xpath("./project/publishers/hudson.plugins.pmd.PmdPublisher/#{k}").text, k
    end
  end
end
