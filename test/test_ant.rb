require_relative './test_xml_generator'

class TestXmlAnt < Test::Unit::TestCase
  def test_ant
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      ant do
        target 'clean', 'lint'
        buildfile 'foo.xml'
        java_opts '-Xmx512m', '-Xms512m'
        property 'skipTest' => 'false'
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'hudson.tasks.Ant/targets' => 'clean lint',
      'hudson.tasks.Ant/buildFile' => 'foo.xml',
      'hudson.tasks.Ant/properties' => '-DskipTest=false',
      'hudson.tasks.Ant/antOpts' => '-Xmx512m -Xms512m',
    }.each do |k, v|
      assert_equal v, actual.xpath('./project/builders/' \
          "#{k}").text, k
    end
  end

  def test_ant_defalt_target
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      ant do
      end
    end

    actual = builder.config_as_xml_node('foo')
    assert actual.at('./project/builders/hudson.tasks.Ant/targets')
  end
end
