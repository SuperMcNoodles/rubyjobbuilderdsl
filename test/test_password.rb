require_relative './test_xml_generator'

class TestXmlPassword < Test::Unit::TestCase
  def test_password
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      password 'ADMIN_PASS', 'PhxHFCjgSiXR2umXhALLq+RzqJBxODDJT4t9Tw5JXbI='
    end

    actual = builder.config_as_xml_node('foo')

    { 'name' => 'ADMIN_PASS', 'value' => 'PhxHFCjgSiXR2umXhALLq+RzqJBxODDJT4t9Tw5JXbI=' }.each do |k, v|
      assert v, actual.xpath("./project/buildWrappers/EnvInjectPasswordWrapper/passwordEntries/EnvInjectPasswordEntry/#{k}").text
    end
  end
end
