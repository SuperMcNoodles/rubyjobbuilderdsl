require_relative './test_xml_generator'

class TestXmlPostbuildScript < Test::Unit::TestCase
  def test_postbuild_shell
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        shell 'cd Reports && mv $(ls *.xml) merge.xml'
        batch 'hostname'
        powershell 'Write-Host "hello world"'
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'hudson.tasks.Shell/command' => 'cd Reports && mv $(ls *.xml) merge.xml',
      'hudson.tasks.BatchFile/command' => 'hostname',
      'hudson.plugins.powershell.PowerShell/command' => 'Write-Host "hello world"',
    }.each do |k, v|
      assert_equal v, actual.xpath('./project/publishers/' \
        "org.jenkinsci.plugins.postbuildscript.PostBuildScript/buildSteps/#{k}").text, k
    end
  end
end
