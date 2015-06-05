require_relative './test_xml_generator'

class TestXmlGerrit < Test::Unit::TestCase
  def test_gerrit_project
    builder = JenkinsJob::Builder.new

    builder.flow 'foo' do
      gerrit do
        patchset_uploaded

        project 'foo/bar' do
          branch 'master', 'release'
          file 'a/**',
               'b/**'
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'compareType' => 'PLAIN', 'pattern' => 'foo/bar' }.each do |k, v|
      assert_equal v, actual.xpath('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/gerritProjects/' \
                     "com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject/#{k}").text, k
    end

    { 1 =>  { 'compareType' => 'ANT', 'pattern' => 'master' },
      2 =>  { 'compareType' => 'ANT', 'pattern' => 'release' } }.each do |item, data|
      data.each do |k, v|
        assert_equal v, actual.xpath('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/gerritProjects/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject/branches/' \
                     "com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.Branch[#{item}]/#{k}").text, "item #{item}, #{k}"
      end
    end

    { 1 =>  { 'compareType' => 'ANT', 'pattern' => 'a/**' },
      2 =>  { 'compareType' => 'ANT', 'pattern' => 'b/**' } }.each do |item, data|
      data.each do |k, v|
        assert_equal v, actual.xpath('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/gerritProjects/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject/filePaths/' \
                     "com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.FilePath[#{item}]/#{k}").text, "item #{item}, #{k}"
      end
    end
  end

  def test_patchset_uploaded
    builder = JenkinsJob::Builder.new

    builder.flow 'foo' do
      gerrit do
        patchset_uploaded
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert actual.at('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/triggerOnEvents/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginPatchsetCreatedEvent')
  end

  def test_gerrit_change_merged
    builder = JenkinsJob::Builder.new

    builder.flow 'foo' do
      gerrit do
        change_merged
      end
    end

    actual = builder.config_as_xml_node('foo')
    assert actual.at('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/triggerOnEvents/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginChangeMergedEvent')
  end

  def test_gerrit_one_comment_added
    builder = JenkinsJob::Builder.new

    builder.flow 'foo' do
      gerrit do
        comment_added 'Code-Review' => '2'
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'verdictCategory' => 'Code-Review', 'commentAddedTriggerApprovalValue' => '2' }.each do |k, v|
      assert_equal v, actual.xpath('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
                     'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/triggerOnEvents/' \
                     "com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginCommentAddedEvent/#{k}").text, k
    end
  end

  def test_gerrit_more_comment_added
    builder = JenkinsJob::Builder.new

    builder.flow 'foo' do
      gerrit do
        comment_added 'Code-Review' => '2', 'Verified' => '1'
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 1 => { 'verdictCategory' => 'Code-Review', 'commentAddedTriggerApprovalValue' => '2' },
      2 => { 'verdictCategory' => 'Verified', 'commentAddedTriggerApprovalValue' => '1' } }.each do |item, data|
      data.each do |k, v|
        assert_equal v, actual.xpath('./com.cloudbees.plugins.flow.BuildFlow/triggers/' \
          'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger/triggerOnEvents/' \
          "com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginCommentAddedEvent[#{item}]/#{k}").text,
                     "item #{item}, #{k}"
      end
    end
  end
end
