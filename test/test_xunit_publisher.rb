require_relative './test_xml_generator'

class TestXmlXUnitPublisher < Test::Unit::TestCase
  def test_postbuild_xunit_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_xunit_report 'a\\b' do
          failed_threshold :total_failed_tests => 0
          unstable_threshold :total_skipped_tests => 0
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert 'a\\b', actual.xpath('./project/publishers/xunit/types/NUnitJunitHudsonTestType/pattern').text
    assert '0', actual.xpath('./project/publishers/xunit/thresholds/org.jenkinsci.plugins.xunit.threshold.FailedThreshold/failureThreshold').text
    assert '0', actual.xpath('./project/publishers/xunit/thresholds/org.jenkinsci.plugins.xunit.threshold.SkippedThreshold/unstableThreshold').text
  end
end
