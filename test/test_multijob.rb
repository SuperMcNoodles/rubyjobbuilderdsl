require_relative './test_xml_generator'

class TestXmlMultiJob < Test::Unit::TestCase
  PHASE = './com.tikal.jenkins.plugins.multijob.MultiJobProject' \
    '/builders/com.tikal.jenkins.plugins.multijob.MultiJobBuilder'

  def test_multi_job
    builder = JenkinsJob::Builder.new

    builder.multi 'foo' do
      phase 'db' do
        job 'foo_a'

        job 'foo_b' do
          ignore_result true
          abort_others true
        end
      end

      phase 'service' do
        job 'foo_c' do
          retries 1
          abort_others false
        end
        job 'foo_d'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal %w(db service),
                 actual.xpath("#{PHASE}/phaseName").map(&:text)

    jobs = actual.xpath("#{PHASE}/phaseJobs/com.tikal.jenkins.plugins.multijob.PhaseJobsConfig")

    assert_equal %w(foo_a foo_b foo_c foo_d),
                 jobs.xpath('./jobName').map(&:text)

    foo_b = jobs.find { |x| x.children.find { |y| y.text == 'foo_b' } }
    assert_equal 'NEVER', foo_b.xpath('./killPhaseOnJobResultCondition').text
    assert_equal 'true', foo_b.xpath('./abortAllJob').text

    foo_c = jobs.find { |x| x.children.find { |y| y.text == 'foo_c' } }
    assert_equal '1', foo_c.xpath('./maxRetries').text
    assert_equal 'false', foo_c.xpath('./abortAllJob').text

    assert_equal %w(FAILURE NEVER FAILURE FAILURE),
                 actual.xpath("#{PHASE}/phaseJobs/com.tikal.jenkins.plugins.multijob.PhaseJobsConfig/killPhaseOnJobResultCondition").map(&:text)
  end
end
