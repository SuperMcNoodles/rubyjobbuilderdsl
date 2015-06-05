require_relative './test_xml_generator'

class TestXmlPostbuildTrigger < Test::Unit::TestCase
  ROOT = './project/publishers/hudson.plugins.parameterizedtrigger.BuildTrigger/configs'
  TRIGGER_CONFIG = 'hudson.plugins.parameterizedtrigger.BuildTriggerConfig'

  def test_postbuild_trigger
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        trigger 'bar' do
          trigger_with_no_parameters true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    expected_trigger_configuration = {
      'projects' => 'bar',
      'condition' => 'SUCCESS',
      'triggerWithNoParameters' => 'true'
    }

    expected_trigger_configuration.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/#{key}").text
      assert_equal expected_value, given_value, key
    end
  end

  def test_postbuild_trigger_multiple_projects
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        trigger 'bar1', 'bar2' do
          trigger_with_no_parameters true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    expected_trigger_configuration = {
      'projects' => 'bar1,bar2',
      'condition' => 'SUCCESS',
      'triggerWithNoParameters' => 'true'
    }

    expected_trigger_configuration.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/#{key}").text
      assert_equal expected_value, given_value, key
    end
  end

  def test_trigger_paramaterized_with_file
    expected_file_build_tag = 'hudson.plugins.parameterizedtrigger.FileBuildParameters'
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        trigger 'bar' do
          file 'env.properties'
        end
      end
    end

    expected_file_parameters = {
      'propertiesFile' => 'env.properties',
      'failTriggerOnMissing' => 'false',
      'useMatrixChild' => 'false',
      'onlyExactRuns' => 'false'
    }

    expected_trigger_configuration = {
      'projects' => 'bar',
      'condition' => 'SUCCESS',
      'triggerWithNoParameters' => 'false'
    }

    actual = builder.config_as_xml_node('foo')

    expected_trigger_configuration.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/#{key}").text
      assert_equal expected_value, given_value, key
    end

    expected_file_parameters.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/configs/#{expected_file_build_tag}/#{key}").text
      assert_equal expected_value, given_value, key
    end
  end

  def test_trigger_paramaterized_with_current_parameters
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        trigger 'bar' do
          current_parameters true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')
    given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/configs").children.to_s.strip
    expected_config = '<hudson.plugins.parameterizedtrigger.CurrentBuildParameters/>'
    assert_equal expected_config, given_value, 'config'

    expected_trigger_configuration = {
      'projects' => 'bar',
      'condition' => 'SUCCESS',
      'triggerWithNoParameters' => 'false'
    }

    expected_trigger_configuration.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/#{key}").text
      assert_equal expected_value, given_value, key
    end
  end

  def test_trigger_paramaterized_with_predefined_parameters
    expected_predefined_build_tag = 'hudson.plugins.parameterizedtrigger.PredefinedBuildParameters'
    builder = JenkinsJob::Builder.new
    builder.freestyle 'foo' do
      postbuild do
        trigger 'bar' do
          predefined_parameters 'BUILD_NUM' => '${BUILD_NUMBER}',
                                'PACKAGE_VERSION' => '${PACKAGE_VERSION}'
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    expected_predefined_parameters = { 'properties' => "BUILD_NUM=${BUILD_NUMBER}\nPACKAGE_VERSION=${PACKAGE_VERSION}" }
    expected_predefined_parameters.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/configs/#{expected_predefined_build_tag}/#{key}").text
      assert_equal expected_value, given_value, key
    end

    expected_trigger_configuration = {
      'projects' => 'bar',
      'condition' => 'SUCCESS',
      'triggerWithNoParameters' => 'false'
    }

    expected_trigger_configuration.each do |key, expected_value|
      given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/#{key}").text
      assert_equal expected_value, given_value, key
    end
  end

  def test_trigger_paramaterized_with_pass_through_git_commit
    builder = JenkinsJob::Builder.new
    builder.freestyle 'foo' do
      postbuild do
        trigger 'bar' do
          pass_through_git_commit
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    given_value = actual.xpath("#{ROOT}/#{TRIGGER_CONFIG}/configs/hudson.plugins.git.GitRevisionBuildParameters/combineQueuedCommits").text
    assert_equal 'true', given_value
  end
end
