require_relative './test_xml_generator'

class TestXvfb < Test::Unit::TestCase
  def test_enable_xvfb
    install_name = 'Xvfb'
    screen_resolution = '1024x768x24'
    debug = 'false'
    timeout = '0'
    display_name_offset = '1'
    shutdown_with_build = 'false'
    auto_display_name = 'true'
    parallel_build = 'false'

    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      xvfb do
        install_name(install_name)
      end
    end

    actual = builder.config_as_xml_node('foo')

    base_xpath = './project/buildWrappers/org.jenkinsci.plugins.xvfb.XvfbBuildWrapper/'

    assert_equal install_name, actual.xpath("#{base_xpath}installationName").text, "installation name was not #{install_name}"
    assert_equal debug, actual.xpath("#{base_xpath}debug").text, "debug property was not #{debug}"
    assert_equal timeout, actual.xpath("#{base_xpath}timeout").text, "timeout property was not #{timeout}"
    assert_equal display_name_offset, actual.xpath("#{base_xpath}displayNameOffset").text, "displayNameOffset was not #{display_name_offset}"
    assert_equal shutdown_with_build, actual.xpath("#{base_xpath}shutdownWithBuild").text, "shutdown_with_build was not #{shutdown_with_build}"
    assert_equal auto_display_name, actual.xpath("#{base_xpath}autoDisplayName").text, "autoDisplayName was not #{auto_display_name}"
    assert_equal screen_resolution, actual.xpath("#{base_xpath}screen").text, "screen resolution was not #{screen_resolution}"
    assert_equal parallel_build, actual.xpath("#{base_xpath}parallelBuild").text, "parallelBuild was not #{parallel_build}"
  end
end
