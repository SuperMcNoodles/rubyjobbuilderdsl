require_relative './test_xml_generator'

class TestXmlInject < Test::Unit::TestCase
  def test_freestyle_inject
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      inject_env do
        properties_content 'EXAMPLE1=foo'
        properties_content 'EXAMPLE2=foo'
        properties_file 'env.prop'
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'EnvInjectBuilder/info/propertiesFilePath' => 'env.prop',
      'EnvInjectBuilder/info/propertiesContent' => 'EXAMPLE2=foo',
    }.each do |k, v|
      assert_equal v, actual.xpath('./project/builders/' \
          "#{k}").text, k
    end
  end
end
