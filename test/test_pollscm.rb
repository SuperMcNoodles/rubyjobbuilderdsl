require_relative './test_xml_generator'

class TestXmlPollSCM < Test::Unit::TestCase
  def test_pollscm
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      pollscm '*/5 * * * *'
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal '*/5 * * * *', actual.xpath('./project/triggers/hudson.triggers.SCMTrigger/spec').text
  end
end
