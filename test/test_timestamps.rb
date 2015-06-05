require_relative './test_xml_generator'

class TestXmlTimestamps < Test::Unit::TestCase
  def test_timestamps
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      timestamps
    end

    actual = builder.config_as_xml_node('foo')
    assert actual.at('./project/buildWrappers/hudson.plugins.timestamper.TimestamperBuildWrapper')
  end
end
