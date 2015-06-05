require_relative './test_xml_generator'

class TestXmlScms < Test::Unit::TestCase
  def test_git
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      scms do
        git do
          url 'ssh://bar@gerrit.mycompany.com:29418/a'
          basedir 'a'
          branches '*/master'
          clean true
        end
        git do
          url 'ssh://bar@gerrit.mycompany.com:29418/b'
          basedir 'b'
          branches '*/master'
          clean true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    expected_class = 'org.jenkinsci.plugins.multiplescms.MultiSCM'
    expected_scm = 'scm'
    scm_nodes = "./project/scm[contains(@class,'#{expected_class}') and @plugin='multiple-scms@0.3']/scms/#{expected_scm}"
    assert_equal 2, actual.xpath("count(#{scm_nodes})").to_i
  end
end
