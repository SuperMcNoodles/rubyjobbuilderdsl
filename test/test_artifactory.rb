require_relative './test_xml_generator'

class TestXmlArtifactory < Test::Unit::TestCase
  def test_artifactory
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      artifactory do
        server 'artifactory.mycompany.com'
        repository 'bar'
        deploy '*.gz'
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'details/artifactoryName' => 'artifactory.mycompany.com',
      'details/repositoryKey' => 'bar',
      'details/snapshotsRepositoryKey' => 'bar',
      'deployPattern' => '*.gz',
      'deployBuildInfo' => 'false',
      'includeEnvVars' => 'false',
     }.each do |k, v|
      assert_equal v, actual.xpath("./project/buildWrappers/org.jfrog.hudson.generic.ArtifactoryGenericConfigurator/#{k}").text, k
    end
  end
end
