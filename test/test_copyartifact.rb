require_relative './test_xml_generator'

class TestXmlCopyArtifact < Test::Unit::TestCase
  def test_copy_lastest
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      copyartifact 'bar' do
        file 'a/**',
             'b/**'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 'bar', actual.xpath('./project/builders/hudson.plugins.copyartifact.CopyArtifact/project').text
    assert_equal 'a/**,b/**', actual.xpath('./project/builders/hudson.plugins.copyartifact.CopyArtifact/filter').text
    assert actual.at('./project/builders/hudson.plugins.copyartifact.CopyArtifact/target')

    assert_equal 'false', actual.xpath('./project/builders/hudson.plugins.copyartifact.CopyArtifact/flatten').text
    assert_equal 'false', actual.xpath('./project/builders/hudson.plugins.copyartifact.CopyArtifact/optional').text
    assert actual.at('./project/builders/hudson.plugins.copyartifact.CopyArtifact/parameters')

    assert_equal 'false', actual.xpath('./project/builders/hudson.plugins.copyartifact.CopyArtifact/' \
      "selector[contains(@class,'hudson.plugins.copyartifact.StatusBuildSelector')]/stable").text
  end

  def test_copy_specific_build
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      copyartifact 'bar' do
        build_number '$ARTIFACT_BUILD_NUMBER'
        file 'a/**',
             'b/**'
        to '$BUILD_NUMBER'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal '$ARTIFACT_BUILD_NUMBER', actual.xpath('./project/builders/hudson.plugins.copyartifact.CopyArtifact/' \
      "selector[contains(@class,'hudson.plugins.copyartifact.SpecificBuildSelector')]/buildNumber").text
  end
end
