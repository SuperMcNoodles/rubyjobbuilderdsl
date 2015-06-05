require_relative './test_xml_generator'

class TestXmlTimed < Test::Unit::TestCase
  def test_timed
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      timed '*/5 * * * *'
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal '*/5 * * * *', actual.xpath('./project/triggers/hudson.triggers.TimerTrigger/spec').text
  end
end
