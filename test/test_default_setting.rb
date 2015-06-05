require_relative './test_xml_generator'

class TestXmlDefaultSetting < Test::Unit::TestCase
  def test_created_jobs_inherit_default_setting
    builder = JenkinsJob::Builder.new do
      node 'windows'
      quiet_period 5
    end

    builder.freestyle 'show-env' do
      shell 'env'
    end

    builder.freestyle 'show-dir' do
      shell 'pwd'
    end

    actual_show_env = builder.config_as_xml_node('show-env')
    actual_show_dir = builder.config_as_xml_node('show-dir')

    assert_equal '5', actual_show_env.xpath('./project/quietPeriod').text
    assert_equal 'windows', actual_show_env.xpath('./project/assignedNode').text
    assert_equal 'env', actual_show_env.xpath('./project/builders/hudson.tasks.Shell/command').text

    assert_equal '5', actual_show_dir.xpath('./project/quietPeriod').text
    assert_equal 'windows', actual_show_dir.xpath('./project/assignedNode').text
    assert_equal 'pwd', actual_show_dir.xpath('./project/builders/hudson.tasks.Shell/command').text
  end
end
