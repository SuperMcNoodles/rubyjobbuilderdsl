require_relative './test_xml_generator'

class TestXmlFreestyle < Test::Unit::TestCase
  def test_freestyle
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      desc 'this is a foo'
      workspace 'foo-$BUILD_NUMBER'
      node 'windows'
      quiet_period 5
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal '', actual.xpath('./project/actions').text
    assert_equal 'this is a foo', actual.xpath('./project/description').text
    assert_equal 'false', actual.xpath('./project/keepDependencies').text
    assert_equal 'false', actual.xpath('./project/blockBuildWhenDownstreamBuilding').text
    assert_equal 'false', actual.xpath('./project/concurrentBuild').text
    assert_equal 'foo-$BUILD_NUMBER', actual.xpath('./project/customWorkspace').text
    assert_equal '5', actual.xpath('./project/quietPeriod').text
    assert_equal 'windows', actual.xpath('./project/assignedNode').text
    assert_equal 'false', actual.xpath('./project/canRoam').text
    assert_equal '', actual.xpath('./project/properties').text
    assert_equal 'hudson.scm.NullSCM',  actual.xpath('./project/scm').attr('class').text
    assert_equal '', actual.xpath('./project/builders').text
    assert_equal '', actual.xpath('./project/publishers').text
    assert_equal '', actual.xpath('./project/buildWrappers').text
  end

  def test_builders
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      powershell 'Get-Service bar.* | foreach { sc.exe stop $_.Name }'
      shell 'rm -rf * || true'
      batch 'c:\Nuget\NuGet.exe Install ServiceTestRunner -source ArtifactoryBuildScripts -config c:\Nuget\NuGet.Config'
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 'Get-Service bar.* | foreach { sc.exe stop $_.Name }',
                 actual.xpath('./project/builders/hudson.plugins.powershell.PowerShell/command').text

    assert_equal 'rm -rf * || true',
                 actual.xpath('./project/builders/hudson.tasks.Shell/command').text

    assert_equal 'c:\Nuget\NuGet.exe Install ServiceTestRunner -source ArtifactoryBuildScripts -config c:\Nuget\NuGet.Config',
                 actual.xpath('./project/builders/hudson.tasks.BatchFile/command').text
  end
end
