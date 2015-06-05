require_relative './test_xml_generator'

class TestXmlParameter < Test::Unit::TestCase
  def test_parameter
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      parameter 'GERRIT_BRANCH' do
        default 'master'
      end

      parameter 'SKIP_TEST' do
        default 'true'
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 1 => { 'name' => 'GERRIT_BRANCH', 'defaultValue' => 'master' },
      2 => { 'name' => 'SKIP_TEST', 'defaultValue' => 'true' } }.each do |item, data|
      data.each do |k, v|
        assert_equal v, actual.xpath('./project/properties/hudson.model.ParametersDefinitionProperty/parameterDefinitions/' \
          "hudson.model.StringParameterDefinition[#{item}]/#{k}").text, "item #{item}, #{k}"
      end
    end
  end

  def test_password_parameter
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      password_parameter 'PASS' do
        default 'xyz='
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'name' => 'PASS', 'defaultValue' => 'xyz=' }.each do |k, v|
      assert_equal v, actual.xpath('./project/properties/hudson.model.ParametersDefinitionProperty/parameterDefinitions/' \
        "hudson.model.PasswordParameterDefinition/#{k}").text
    end
  end
end
