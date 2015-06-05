require_relative './test_xml_generator'

class TestXmlPostbuildGroovy < Test::Unit::TestCase
  def test_postbuild_groovy
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        groovy 'manager.buildFailure()'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 'manager.buildFailure()', actual.xpath('./project/publishers/' \
      'org.jvnet.hudson.plugins.groovypostbuild.GroovyPostbuildRecorder/groovyScript').text

    assert_equal '0', actual.xpath('./project/publishers/' \
      'org.jvnet.hudson.plugins.groovypostbuild.GroovyPostbuildRecorder/behavior').text
  end
end
