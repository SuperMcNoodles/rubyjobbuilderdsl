require_relative './test_xml_generator'

class TestGamePublisher < Test::Unit::TestCase
  def test_postbuild_game_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        game
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert actual.at('./project/publishers/hudson.plugins.cigame.GamePublisher')
  end
end
