require_relative './test_xml_generator'

class TestChuckNorrisPublisher < Test::Unit::TestCase
  def test_postbuild_chucknorris_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        chucknorris
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert actual.at('./project/publishers/hudson.plugins.chucknorris.CordellWalkerRecorder/factGenerator')
  end
end
