require_relative './test_xml_generator'

class TestXmlGit < Test::Unit::TestCase
  def test_git
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      git do
        url 'ssh://bar@gerrit.mycompany.com:29418/foo'
        basedir 'foo'
        reference_repo '$HOME/foo.git'
        branches '$GERRIT_BRANCH'
        refspec '$GERRIT_REFSPEC'
        choosing_strategy 'gerrit'
        git_config_name 'bar'
        git_config_email 'bar@mycompany.com'
        clean true
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal '2', actual.xpath("./project/scm[contains(@class,'hudson.plugins.git.GitSCM') and @plugin='git@2.0']/configVersion").text

    { 'name' => 'origin', 'refspec' => '$GERRIT_REFSPEC',
     'url' => 'ssh://bar@gerrit.mycompany.com:29418/foo' }.each do |k, v|
      assert_equal v,  actual.xpath("./project/scm/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/#{k}").text, k
    end

    assert_equal '$GERRIT_BRANCH',  actual.xpath('./project/scm/branches/hudson.plugins.git.BranchSpec/name').text

    assert actual.at('./project/scm/extensions/hudson.plugins.git.extensions.impl.BuildChooserSetting/' \
      "buildChooser[contains(@class,'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTriggerBuildChooser')]")

    assert_equal 'foo', actual.xpath('./project/scm/extensions/' \
      'hudson.plugins.git.extensions.impl.RelativeTargetDirectory/relativeTargetDir').text
    assert_equal '$HOME/foo.git', actual.xpath('./project/scm/extensions/' \
      'hudson.plugins.git.extensions.impl.CloneOption/reference').text

    { 'name' => 'bar', 'email' => 'bar@mycompany.com' }.each do |k, v|
      assert_equal v, actual.xpath("./project/scm/extensions/hudson.plugins.git.extensions.impl.UserIdentity/#{k}").text, k
    end

    assert actual.at('./project/scm/extensions/hudson.plugins.git.extensions.impl.CleanCheckout')
  end

  def test_filter_by_path
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      git do
        url 'ssh://bar@gerrit.mycompany.com:29418/foo/a'
        file 'src/a/.*',
             'src/Db/a/.*'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal "src/a/.*\nsrc/Db/a/.*", actual.xpath('./project/scm/extensions/' \
      'hudson.plugins.git.extensions.impl.PathRestriction/includedRegions').text
  end

  def test_jgit
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      git do
        url 'bar@git.mycompany.com:/foo'
        jgit
        credentials 'bar'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 'jgit', actual.xpath('./project/scm/gitTool').text
    assert_equal 'bar', actual.xpath('./project/scm/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/credentialsId').text
  end
end
