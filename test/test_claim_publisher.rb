require_relative './test_xml_generator'

class TestXmlClaimPublisher < Test::Unit::TestCase
  def test_postbuild_nunit_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        allow_broken_build_claiming
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert actual.at('./project/publishers/hudson.plugins.claim.ClaimPublisher')
  end
end
