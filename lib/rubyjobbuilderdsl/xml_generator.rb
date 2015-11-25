require 'builder'

class BasicObject
  def class
    (class << self; self end).superclass
  end
end

module JenkinsJob
  class XmlGenerator
    GENERATOR_BY_CLASS = {
      FreeStyle => lambda { |generator, model, xml_node| generator.generate_freestyle(model, xml_node) },
      Flow => lambda { |generator, model, xml_node| generator.generate_flow(model, xml_node) },
      MultiJob => lambda { |generator, model, xml_node| generator.generate_multi_job(model, xml_node) },
      View => lambda { |generator, model, xml_node| generator.generate_view(model, xml_node) },
      Common::Throttle => lambda { |generator, model, xml_node| generator.generate_throttle(model, xml_node) },
      Common::LogRotate => lambda { |generator, model, xml_node| generator.generate_logrotate(model, xml_node) },
      Common::PollSCM => lambda { |generator, model, xml_node| generator.generate_pollscm(model, xml_node) },
      Common::Timed => lambda { |generator, model, xml_node| generator.generate_timed(model, xml_node) },
      Common::BuildTimeout => lambda { |generator, model, xml_node| generator.generate_build_timeout(model, xml_node) },
      Common::Timestamps => lambda { |generator, model, xml_node| generator.generate_timestamps(model, xml_node) },
      Common::Artifactory => lambda { |generator, model, xml_node| generator.generate_artifactory(model, xml_node) },
      Common::Password => lambda { |generator, model, xml_node| generator.generate_password(model, xml_node) },
      Common::Gerrit => lambda { |generator, model, xml_node| generator.generate_gerrit(model, xml_node) },
      Common::GerritProject => lambda { |generator, model, xml_node| generator.generate_gerrit_project(model, xml_node) },
      Common::Git  => lambda { |generator, model, xml_node| generator.generate_git(model, xml_node) },
      Common::Scms => lambda { |generator, model, xml_node| generator.generate_scms(model, xml_node) },
      Common::Parameter => lambda { |generator, model, xml_node| generator.generate_param(model, xml_node) },
      Common::PasswordParameter => lambda { |generator, model, xml_node| generator.generate_password_param(model, xml_node) },
      Common::BlockingJob => lambda { |generator, model, xml_node| generator.generate_blocking_job(model, xml_node) },
      BuildStep::Shell => lambda { |generator, model, xml_node| generator.generate_shell(model, xml_node) },
      BuildStep::Powershell => lambda { |generator, model, xml_node| generator.generate_powershell(model, xml_node) },
      BuildStep::Batch => lambda { |generator, model, xml_node| generator.generate_batch(model, xml_node) },
      BuildStep::CopyArtifact => lambda { |generator, model, xml_node| generator.generate_copyartifact(model, xml_node) },
      BuildStep::InjectEnv => lambda { |generator, model, xml_node| generator.generate_inject_env(model, xml_node) },
      BuildStep::Ant => lambda { |generator, model, xml_node| generator.generate_ant(model, xml_node) },
      BuildStep::Phase => lambda { |generator, model, xml_node| generator.generate_phase(model, xml_node) },
      BuildStep::Xvfb => lambda { |generator, model, xml_node| generator.generate_xvfb(model, xml_node) },
      Postbuild::Postbuild => lambda { |generator, model, xml_node| generator.generate_postbuild(model, xml_node) },
      Postbuild::Archive => lambda { |generator, model, xml_node| generator.generate_archive(model, xml_node) },
      Postbuild::EmailPublisher => lambda { |generator, model, xml_node| generator.generate_email_publisher(model, xml_node) },
      Postbuild::NUnitPublisher => lambda { |generator, model, xml_node| generator.generate_nunit_publisher(model, xml_node) },
      Postbuild::XUnitPublisher => lambda { |generator, model, xml_node| generator.generate_xunit_publisher(model, xml_node) },
      Postbuild::HtmlPublisher => lambda { |generator, model, xml_node| generator.generate_html_publisher(model, xml_node) },
      Postbuild::CucumberJsonPublisher => lambda { |generator, model, xml_node| generator.generate_cucumber_publisher(model, xml_node) },
      Postbuild::LogParser => lambda { |generator, model, xml_node| generator.generate_logparser(model, xml_node) },
      Postbuild::PostbuildScript => lambda { |generator, model, xml_node| generator.generate_postbuild_script(model, xml_node) },
      Postbuild::PostbuildGroovy => lambda { |generator, model, xml_node| generator.generate_postbuild_groovy(model, xml_node) },
      Postbuild::PostbuildTrigger => lambda { |generator, model, xml_node| generator.generate_postbuild_trigger(model, xml_node) },
      Postbuild::CloverPhpPublisher => lambda { |generator, model, xml_node| generator.generate_clover_php(model, xml_node) },
      Postbuild::JavaDocPublisher => lambda { |generator, model, xml_node| generator.generate_javadoc(model, xml_node) },
      Postbuild::PMDPublisher => lambda { |generator, model, xml_node| generator.generate_pmd(model, xml_node) },
      Postbuild::ClaimPublisher => lambda { |generator, model, xml_node| generator.generate_claim_publisher(model, xml_node) },
      Postbuild::TapPublisher => lambda { |generator, model, xml_node| generator.generate_tap_publisher(model, xml_node) },
      Postbuild::GamePublisher => lambda { |generator, model, xml_node| generator.generate_game_publisher(model, xml_node) },
      Postbuild::ChuckNorrisPublisher => lambda { |generator, model, xml_node| generator.generate_chucknorris_publisher(model, xml_node) },
    }

    def generate(model, xml_node = ::Builder::XmlMarkup.new(:indent => 2))
      if GENERATOR_BY_CLASS[model.class]
        GENERATOR_BY_CLASS[model.class].call(self, model, xml_node)
      else
        fail "Missing XML generator for class #{model.class}"
      end
    end

    def generate_common(model, project)
      project.actions
      if model.desc_
        project.description(model.desc_)
      else
        project.description('<!-- Managed by Jenkins Job Builder -->')
      end

      project.keepDependencies(false)
      project.blockBuildWhenDownstreamBuilding(false)
      project.blockBuildWhenUpstreamBuilding(false)
      project.concurrentBuild(model.concurrent_)
      project.quietPeriod(model.quiet_period_) if model.quiet_period_

      if model.node_
        project.assignedNode(model.node_)
        project.canRoam(false)
      else
        project.canRoam(true)
      end

      generate(model.logrotate_, project) if model.logrotate_

      if model.properties_.empty? && model.parameters_.empty?
        project.properties
      else
        project.properties do |properties|
          model.properties_.values.each { |e| generate(e, properties) }

          unless model.parameters_.empty?
            properties.tag!('hudson.model.ParametersDefinitionProperty') do |node|
              node.parameterDefinitions do |params_def|
                model.parameters_.values.each { |e| generate(e, params_def) }
              end
            end
          end
        end
      end

      if model.scm_
        generate(model.scm_, project)
      else
        project.scm(:class => 'hudson.scm.NullSCM')
      end

      unless model.triggers_.empty?
        project.triggers(:class => 'vector') do |triggers|
          model.triggers_.values.each { |e| generate(e, triggers) }
        end
      end

      if model.postbuild_
        project.publishers do |publishers|
          generate(model.postbuild_, publishers)
        end
      else
        project.publishers
      end

      if model.wrappers_.empty?
        project.buildWrappers
      else
        project.buildWrappers do |wrappers|
          model.wrappers_.values.each { |e| generate(e, wrappers) }
        end
      end
    end

    def generate_freestyle(model, root)
      result = root.project do |project|
        generate_common(model, project)
        project.customWorkspace(model.workspace_) if model.workspace_
        if model.builders_.empty?
          project.builders
        else
          project.builders do |builders|
            model.builders_.each { |e| generate(e, builders) }
          end
        end
      end
      result
    end

    def generate_flow(model, root)
      result = root.tag!('com.cloudbees.plugins.flow.BuildFlow') do |project|
        project.buildNeedsWorkspace(true)
        project.dsl(model.dsl_)
        generate_common(model, project)
      end
      result
    end

    def generate_multi_job(model, root)
      result = root.tag!('com.tikal.jenkins.plugins.multijob.MultiJobProject', :plugin => 'jenkins-multijob-plugin@1.13') do |project|
        generate_common(model, project)
        if model.builders_.empty?
          project.builders
        else
          project.builders do |builders|
            model.builders_.each { |e| generate(e, builders) }
          end
        end
      end
      result
    end

    def generate_view(model, root)
      result = root.tag!('hudson.model.ListView') do |view|
        view.name(model.name)
        view.filterExecutors(false)
        view.filterQueue(false)
        view.properties(:class => 'hudson.model.View$PropertyList')
        view.jobNames do |jobs|
          jobs.comparator(:class => 'hudson.util.CaseInsensitiveComparator')
        end
        view.jobFilters
        view.columns do |cols|
          cols.tag!('hudson.views.StatusColumn')
          cols.tag!('hudson.views.WeatherColumn')
          cols.tag!('hudson.views.JobColumn')
          cols.tag!('hudson.views.LastSuccessColumn')
          cols.tag!('hudson.views.LastFailureColumn')
          cols.tag!('hudson.views.LastDurationColumn')
          cols.tag!('hudson.views.BuildButtonColumn')
        end
        view.includeRegex(model.jobname_)
        view.recurse(false)
      end
      result
    end

    def generate_shell(model, builders)
      builders.tag!('hudson.tasks.Shell') do |shell|
        shell.command(model.cmd_)
      end
    end

    def generate_powershell(model, builders)
      builders.tag!('hudson.plugins.powershell.PowerShell') do |shell|
        shell.command(model.cmd_)
      end
    end

    def generate_inject_env(model, builders)
      builders.tag!('EnvInjectBuilder') do |inject|
        inject.tag!('info') do |info|
          info.propertiesFilePath(model.properties_file_) if model.properties_file_
          info.propertiesContent(model.properties_content_)
        end
      end
    end

    def generate_batch(model, builders)
      builders.tag!('hudson.tasks.BatchFile') do |batch|
        batch.command(model.cmd_)
      end
    end

    def generate_copyartifact(model, builders)
      builders.tag!('hudson.plugins.copyartifact.CopyArtifact') do |copy|
        copy.project(model.project_)
        copy.filter(model.filter_) if model.filter_
        if model.target_
          copy.target(model.target_)
        else
          copy.target
        end
        copy.flatten(false)
        copy.optional(false)
        copy.parameters
        if model.build_number_
          copy.selector(:class => 'hudson.plugins.copyartifact.SpecificBuildSelector') do |s|
            s.buildNumber(model.build_number_)
          end
        else
          copy.selector(:class => 'hudson.plugins.copyartifact.StatusBuildSelector') do |s|
            s.stable(false)
          end
        end
      end
    end

    def generate_ant(model, builders)
      builders.tag!('hudson.tasks.Ant', :plugin => 'ant@1.2') do |ant|
        if model.targets_.empty?
          ant.targets
        else
          ant.targets(model.targets_.join(' '))
        end
        ant.buildFile(model.buildfile_) if model.buildfile_
        ant.properties(model.properties_.map { |k, v| "-D#{k}=#{v}" }.join(' ')) unless model.properties_.empty?
        ant.antOpts(model.java_opts_.join(' ')) unless model.java_opts_.empty?
      end
    end

    def generate_phase(model, builders)
      builders.tag!('com.tikal.jenkins.plugins.multijob.MultiJobBuilder') do |phase|
        phase.phaseName(model.name)
        phase.phaseJobs do |phaseJobs|
          model.jobs_.each do |job|
            phaseJobs.tag!('com.tikal.jenkins.plugins.multijob.PhaseJobsConfig') do |conf|
              conf.jobName(job.name)
              conf.currParams(true)
              conf.exposedSCM(true)
              conf.disableJob(false)
              conf.parsingRulesPath
              conf.maxRetries(job.retries_)
              if job.retries_ > 0
                conf.enableRetryStrategy(true)
              else
                conf.enableRetryStrategy(false)
              end
              conf.enableCondition(false)
              conf.abortAllJob(job.abort_others_)
              conf.condition
              conf.configs(:class => 'empty-list')
              if job.ignore_result_
                conf.killPhaseOnJobResultCondition('NEVER')
              else
                conf.killPhaseOnJobResultCondition('FAILURE')
              end
              conf.buildOnlyIfSCMChanges(false)
            end
          end
        end
        phase.continuationCondition('SUCCESSFUL')
      end
    end

    def generate_throttle(model, properties)
      properties.tag!('hudson.plugins.throttleconcurrents.ThrottleJobProperty') do |throttle|
        throttle.maxConcurrentPerNode(model.max_per_node_)
        throttle.maxConcurrentTotal(model.max_total_)
        throttle.throttleEnabled(true)

        if model.categories_
          throttle.categories do |categories|
            model.categories_.each { |cat| categories.string(cat) }
          end
          throttle.throttleOption('category')
        else
          throttle.throttleOption('project')
        end
        throttle.configVersion(1)
      end
    end

    def generate_logrotate(model, project)
      project.logRotator do |log|
        log.daysToKeep(model.days_to_keep_) if model.days_to_keep_
        log.numToKeep(model.num_to_keep_) if model.num_to_keep_
        log.artifactDaysToKeep(model.artifact_days_to_keep_) if model.artifact_days_to_keep_
        log.artifactNumToKeep(model.artifact_num_to_keep_) if model.artifact_num_to_keep_
      end
    end

    def generate_pollscm(model, triggers)
      triggers.tag!('hudson.triggers.SCMTrigger') do |scm|
        scm.spec(model.value_)
      end
    end

    def generate_timed(model, triggers)
      triggers.tag!('hudson.triggers.TimerTrigger') do |timed|
        timed.spec(model.value_)
      end
    end

    def generate_gerrit(model, triggers)
      triggers.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTrigger') do |gerrit|
        gerrit.spec
        gerrit.gerritProjects do |gerrit_projects|
          model.projects_.each { |p| generate(p, gerrit_projects) }
        end

        gerrit.skipVote do |skip_vote|
          skip_vote.onSuccessful(false)
          skip_vote.onFailed(false)
          skip_vote.onUnstable(false)
          skip_vote.onNotBuilt(false)
        end
        gerrit.silentMode(false)
        gerrit.escapeQuotes(true)
        gerrit.noNameAndEmailParameters(false)
        gerrit.dynamicTriggerConfiguration('False')
        gerrit.triggerConfigURL
        gerrit.allowTriggeringUnreviewedPatches(false)

        gerrit.triggerOnEvents do |events|
          if model.patchset_uploaded_
            events.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginPatchsetCreatedEvent')
          end

          if model.change_merged_
            events.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginChangeMergedEvent')
          end

          model.comment_added_.each do |e|
            events.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.events.PluginCommentAddedEvent') do |comment|
              comment.verdictCategory(e[:approval_category])
              comment.commentAddedTriggerApprovalValue(e[:approval_value])
            end
          end
        end

        gerrit.buildStartMessage
        gerrit.buildFailureMessage
        gerrit.buildSuccessfulMessage
        gerrit.buildUnstableMessage
        gerrit.customUrl
        gerrit.serverName('__ANY__')
      end
    end

    def generate_gerrit_project(model, gerrit_projects)
      gerrit_projects.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.GerritProject') do |project|
        project.compareType('PLAIN')
        project.pattern(model.project_)
        project.branches do |branches|
          model.branches_.each do |pattern|
            branches.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.Branch') do |branch|
              branch.compareType('ANT')
              branch.pattern(pattern)
            end
          end
        end
        project.filePaths do |file_paths|
          model.files_.each do |pattern|
            file_paths.tag!('com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.data.FilePath') do |path|
              path.compareType('ANT')
              path.pattern(pattern)
            end
          end
        end if model.files_
      end
    end

    def generate_build_timeout(model, wrappers)
      wrappers.tag!('hudson.plugins.build__timeout.BuildTimeoutWrapper') do |timeout|
        timeout.timeoutMinutes(3)
        timeout.failBuild(false)
        timeout.writingDescription(false)
        timeout.timeoutType(model.type_)
        timeout.timeoutPercentage(model.elastic_percentage_)
        timeout.timeoutMinutesElasticDefault(model.elastic_default_timeout_)
      end
    end

    def generate_timestamps(_model, wrappers)
      wrappers.tag!('hudson.plugins.timestamper.TimestamperBuildWrapper')
    end

    def generate_password(model, wrappers)
      wrappers.tag!('EnvInjectPasswordWrapper', :plugin => 'envinject@1.90') do |env|
        env.injectGlobalPasswords(true)
        env.maskPasswordParameters(false)
        env.passwordEntries do |entries|
          entries.EnvInjectPasswordEntry do |entry|
            entry.name(model.name_)
            entry.value(model.password_)
          end
        end
      end
    end

    def generate_xvfb(model, wrappers)
      wrappers.tag!('org.jenkinsci.plugins.xvfb.XvfbBuildWrapper', :plugin => 'xvfb@1.0.16') do |xvfb|
        xvfb.installationName(model.install_name_)
        xvfb.screen(model.screen_)
        xvfb.debug(model.debug_)
        xvfb.timeout(model.timeout_)
        xvfb.displayNameOffset(model.display_name_offset_)
        xvfb.shutdownWithBuild(model.shutdown_with_build_)
        xvfb.autoDisplayName(model.auto_display_name_)
        xvfb.parallelBuild(model.parallel_build_)
      end
    end

    def generate_artifactory(model, wrappers)
      wrappers.tag!('org.jfrog.hudson.generic.ArtifactoryGenericConfigurator',
                    :plugin => 'artifactory@2.2.4') do |artifact|
        artifact.details do |details|
          details.artifactoryName(model.server_)
          details.repositoryKey(model.repository_)
          details.snapshotsRepositoryKey(model.repository_)
          details.artifactoryUrl
          details.stagingPlugin
        end
        artifact.deployPattern(model.deploy_.join(' '))
        artifact.resolvePattern(model.resolve_.join(' '))
        artifact.matrixParams
        artifact.deployBuildInfo(model.build_info_)
        artifact.includeEnvVars(false)
        artifact.envVarsPatterns do |env|
          env.includePatterns
          env.excludePatterns('*password*,*secret*')
        end
        artifact.discardOldBuilds(false)
        artifact.artifactdiscardBuildArtifacts(true)
      end
    end

    def generate_git(model, project)
      project.scm(:class => 'hudson.plugins.git.GitSCM', :plugin => 'git@2.0') do |scm|
        scm.configVersion(2)

        scm.userRemoteConfigs do |remote|
          remote.tag!('hudson.plugins.git.UserRemoteConfig') do |user|
            user.name('origin')
            user.refspec(model.refspec_)
            user.url(model.url_)
            user.credentialsId(model.credentials_)
          end
        end

        scm.branches do |branches|
          model.branches_.each do |b|
            branches.tag!('hudson.plugins.git.BranchSpec') do |spec|
              spec.name(b)
            end
          end
        end

        scm.gitTool('jgit') if model.jgit_

        scm.extensions do |ext|
          generate_git_ext(model, ext)
        end
      end
    end

    def generate_scms(model, project)
      project.scm(:class => 'org.jenkinsci.plugins.multiplescms.MultiSCM', :plugin => 'multiple-scms@0.3') do |scm|
        unless model.scms_.empty?
          scm.scms do |multiple_scms|
            model.scms_.each { |e| generate(e, multiple_scms) }
          end
        end
      end
    end

    def generate_git_ext(model, ext)
      ext.tag!('hudson.plugins.git.extensions.impl.UserExclusion')
      if model.choosing_strategy_ == 'gerrit'
        ext.tag!('hudson.plugins.git.extensions.impl.BuildChooserSetting') do |strategy|
          strategy.buildChooser(:class =>
            'com.sonyericsson.hudson.plugins.gerrit.trigger.hudsontrigger.GerritTriggerBuildChooser') do |gerrit|
            gerrit.separator('#')
          end
        end
      end
      ext.tag!('hudson.plugins.git.extensions.impl.SubmoduleOption') do |submodule|
        submodule.disableSubmodules(false)
        submodule.recursiveSubmodules(false)
      end
      if model.basedir_
        ext.tag!('hudson.plugins.git.extensions.impl.RelativeTargetDirectory') do |target|
          target.relativeTargetDir(model.basedir_)
        end
      end
      if model.reference_repo_
        ext.tag!('hudson.plugins.git.extensions.impl.CloneOption') do |target|
          target.reference(model.reference_repo_)
        end
      end
      if model.git_config_name_
        ext.tag!('hudson.plugins.git.extensions.impl.UserIdentity') do |identity|
          identity.name(model.git_config_name_)
          identity.email(model.git_config_email_)
        end
      end
      ext.tag!('hudson.plugins.git.extensions.impl.CleanCheckout') if model.clean_
      ext.tag!('hudson.plugins.git.extensions.impl.DisableRemotePoll') unless model.fastpoll_
      ext.tag!('hudson.plugins.git.extensions.impl.WipeWorkspace') if model.wipe_workspace_
      if model.files_
        ext.tag!('hudson.plugins.git.extensions.impl.PathRestriction') do |restrict|
          restrict.includedRegions(model.files_.join("\n"))
          restrict.excludedRegions
        end
      else
        ext.tag!('hudson.plugins.git.extensions.impl.PathRestriction')
      end
    end

    def generate_param(model, params_def)
      params_def.tag!('hudson.model.StringParameterDefinition') do |str_param|
        str_param.name(model.name)
        str_param.description(model.description_)
        str_param.defaultValue(model.default_)
      end
    end

    def generate_password_param(model, params_def)
      params_def.tag!('hudson.model.PasswordParameterDefinition') do |str_param|
        str_param.name(model.name)
        str_param.description(model.description_)
        str_param.defaultValue(model.default_)
      end
    end

    def generate_blocking_job(model, properties)
      properties.tag!('hudson.plugins.buildblocker.BuildBlockerProperty',
                      :plugin => 'build-blocker-plugin@1.4.1') do |blocker|

        blocker.useBuildBlocker(true)
        blocker.blockingJobs(model.jobs_.join("\n"))
      end
    end

    def generate_postbuild(model, publishers)
      model.publishers_.values.flatten.each { |e| generate(e, publishers) }
    end

    def generate_archive(model, publishers)
      publishers.tag!('hudson.tasks.ArtifactArchiver') do |archive|
        archive.artifacts(model.artifacts_)
        archive.latestOnly(model.latest_only_) if model.latest_only_
        archive.allowEmptyArchive(model.allow_empty_) if model.allow_empty_
      end
    end

    def generate_email_publisher(model, publishers)
      publishers.tag!('hudson.tasks.Mailer') do |email|
        email.recipients(model.recipients_)
        email.dontNotifyEveryUnstableBuild(!model.notify_every_unstable_build_)
        email.sendToIndividuals(model.send_to_individuals_)
      end
    end

    def generate_nunit_publisher(model, publishers)
      publishers.tag!('hudson.plugins.nunit.NUnitPublisher') do |nunit|
        nunit.testResultsPattern(model.test_results_pattern_)
        nunit.debug(model.debug_)
        nunit.keepJUnitReports(model.keep_junit_reports_)
        nunit.skipJUnitArchiver(model.skip_junit_archiver_)
      end
    end

    def generate_xunit_publisher(model, publishers)
      publishers.tag!('xunit', :plugin => 'xunit@1.92') do |xunit|
        xunit.types do |types|
          types.NUnitJunitHudsonTestType do |nunit|
            nunit.pattern(model.test_results_pattern_)
            nunit.skipNoTestFiles(false)
            nunit.failIfNotNew(true)
            nunit.deleteOutputFiles(true)
            nunit.stopProcessingIfError(true)
          end
        end
        xunit.thresholds do |thresholds|
          thresholds.tag!('org.jenkinsci.plugins.xunit.threshold.FailedThreshold') do |test|
            if model.failed_threshold_[:total_failed_tests]
              test.failureThreshold(model.failed_threshold_[:total_failed_tests])
            else
              test.failureThreshold
            end
            if model.failed_threshold_[:new_failed_tests]
              test.failureNewThreshold(model.failed_threshold_[:new_failed_tests])
            else
              test.failureNewThreshold
            end
            if model.unstable_threshold_[:total_failed_tests]
              test.unstableThreshold(model.unstable_threshold_[:total_failed_tests])
            else
              test.unstableThreshold
            end
            if model.unstable_threshold_[:new_failed_tests]
              test.unstableNewThreshold(model.unstable_threshold_[:new_failed_tests])
            else
              test.unstableNewThreshold
            end
          end
          thresholds.tag!('org.jenkinsci.plugins.xunit.threshold.SkippedThreshold') do |test|
            if model.failed_threshold_[:total_skipped_tests]
              test.failureThreshold(model.failed_threshold_[:total_skipped_tests])
            else
              test.failureThreshold
            end
            if model.failed_threshold_[:new_skipped_tests]
              test.failureNewThreshold(model.failed_threshold_[:new_skipped_tests])
            else
              test.failureNewThreshold
            end
            if model.unstable_threshold_[:total_skipped_tests]
              test.unstableThreshold(model.unstable_threshold_[:total_skipped_tests])
            else
              test.unstableThreshold
            end
            if model.unstable_threshold_[:new_skipped_tests]
              test.unstableNewThreshold(model.unstable_threshold_[:new_skipped_tests])
            else
              test.unstableNewThreshold
            end
          end
        end
        xunit.thresholdMode(1)
        xunit.extraConfiguration do |extra|
          extra.testTimeMargin(3000)
        end
      end
    end

    def generate_html_publisher(model, publishers)
      publishers.tag!('htmlpublisher.HtmlPublisher') do |html|
        html.reportTargets do |target|
          target.tag!('htmlpublisher.HtmlPublisherTarget') do |html_target|
            html_target.reportName(model.name)
            html_target.reportDir(model.dir_)
            html_target.reportFiles(model.file_)
            html_target.keepAll(model.keep_all_)
            html_target.allowMissing(model.allow_missing_)
            html_target.wrapperName('htmlpublisher-wrapper.html')
          end
        end
      end
    end

    def generate_cucumber_publisher(model, publishers)
      publishers.tag!(
        'org.jenkinsci.plugins.cucumber.jsontestsupport.CucumberTestResultArchiver',
        :plugin => 'cucumber-testresult-plugin@0.8.2') do |cucumber|
        cucumber.testResults(model.test_results_)
        cucumber.ignoreBadSteps(model.ignore_bad_tests_)
      end
    end
    def generate_logparser(model, publishers)
      publishers.tag!('hudson.plugins.logparser.LogParserPublisher') do |logparser|
        logparser.unstableOnWarning(model.unstable_on_warning_)
        logparser.failBuildOnError(model.fail_on_error_)
        logparser.parsingRulesPath(model.rule_file_)
      end
    end

    def generate_postbuild_script(model, publishers)
      publishers.tag!('org.jenkinsci.plugins.postbuildscript.PostBuildScript') do |script|
        script.buildSteps do |steps|
          model.builders_.each { |e| generate(e, steps) }
        end
      end
    end

    def generate_postbuild_groovy(model, publishers)
      publishers.tag!('org.jvnet.hudson.plugins.groovypostbuild.GroovyPostbuildRecorder') do |recorder|
        recorder.groovyScript(model.value_)
        recorder.behavior(0)
      end
    end

    def generate_postbuild_trigger(model, publishers)
      publishers.tag!('hudson.plugins.parameterizedtrigger.BuildTrigger') do |trigger|
        trigger.tag!('configs') do
          generate_trigger_project(model, publishers)
        end
      end
    end

    def generate_trigger_project(model, publishers)
      publishers.tag!('hudson.plugins.parameterizedtrigger.BuildTriggerConfig') do |project|
        project.tag!('configs') do |config|
          if model.predefined_parameters_
            config.tag!('hudson.plugins.parameterizedtrigger.PredefinedBuildParameters') do |params|
              params.properties(model.predefined_parameters_)
            end
          end
          if model.file_
            config.tag!('hudson.plugins.parameterizedtrigger.FileBuildParameters') do |params|
              params.propertiesFile(model.file_)
              params.failTriggerOnMissing(model.fail_on_missing_) if model.fail_on_missing_
              params.failTriggerOnMissing(false) unless model.fail_on_missing_
              params.useMatrixChild(false)
              params.onlyExactRuns(false)
            end
          end
          if model.current_parameters_
            config.tag!('hudson.plugins.parameterizedtrigger.CurrentBuildParameters')
          end
          if model.pass_through_git_commit_
            config.tag!('hudson.plugins.git.GitRevisionBuildParameters') do |git|
              git.combineQueuedCommits(true)
            end
          end
        end
        project.projects(model.project_.join(','))
        project.condition('SUCCESS')
        project.triggerWithNoParameters(model.trigger_with_no_parameters_)
      end
    end

    def generate_clover_php(model, publishers)
      publishers.tag!('org.jenkinsci.plugins.cloverphp.CloverPHPPublisher',
                      :plugin => 'cloverphp@0.3.3') do |clover|
        clover.xmlLocation(model.xml_location_)
        if model.html_report_dir_
          clover.publishHtmlReport(true)
          clover.reportDir(model.html_report_dir_)
        end
        clover.disableArchiving(!model.archive_)

        if model.healthy_target_
          clover.healthyTarget do |target|
            target.methodCoverage(model.healthy_target_[:method])
            target.statementCoverage(model.healthy_target_[:statement])
          end
        else
          clover.healthyTarget
        end

        if model.unhealthy_target_
          clover.unhealthyTarget do |target|
            target.methodCoverage(model.unhealthy_target_[:method])
            target.statementCoverage(model.unhealthy_target_[:statement])
          end
        else
          clover.unhealthyTarget
        end

        if model.failing_target_
          clover.failingTarget do |target|
            target.methodCoverage(model.failing_target_[:method])
            target.statementCoverage(model.failing_target_[:statement])
          end
        else
          clover.failingTarget
        end
      end
    end

    def generate_javadoc(model, publishers)
      publishers.tag!('hudson.tasks.JavadocArchiver',
                      :plugin => 'javadoc@1.1') do |doc|
        doc.javadocDir(model.doc_dir_)
        doc.keepAll(model.keep_all_)
      end
    end

    def generate_pmd(model, publishers)
      publishers.tag!('hudson.plugins.pmd.PmdPublisher',
                      :plugin => 'pmd@3.38') do |pmd|
        pmd.healthy
        pmd.unHealthy
        pmd.thresholdLimit(model.threshold_limit_)
        pmd.pluginName('[PMD]')
        pmd.defaultEncoding
        pmd.canRunOnFailed(false)
        pmd.useStableBuildAsReference(false)
        pmd.useDeltaValues(false)
        pmd.thresholds do |analysis|
          analysis.unstableTotalAll
          analysis.unstableTotalHigh
          analysis.unstableTotalNormal
          analysis.unstableTotalLow
          analysis.failedTotalAll
          analysis.failedTotalHigh
          analysis.failedTotalNormal
          analysis.failedTotalLow
        end
        pmd.shouldDetectModules(false)
        pmd.dontComputeNew(true)
        pmd.doNotResolveRelativePaths(true)
        pmd.pattern(model.pmd_results_)
      end
    end

    def generate_claim_publisher(_, publishers)
      publishers.tag!('hudson.plugins.claim.ClaimPublisher', :plugin => 'claim@2.3')
    end

    def generate_tap_publisher(model, publishers)
      publishers.tag!('org.tap4j.plugin.TapPublisher',
                      :plugin => 'tap@1.20') do |tap|
        tap.testResults(model.test_results_)
        tap.failIfNoResults(model.fail_if_no_test_results_)
        tap.failedTestsMarkBuildAsFailure(model.fail_if_test_fail_)
        tap.includeCommentDiagnostics(model.include_diagnostics_)
        tap.planRequired(model.require_plan_)
        tap.verbose(model.verbose_)

        tap.outputTapToConsole(false)
        tap.enableSubtests(false)
        tap.discardOldReports(false)
        tap.todoIsFailure(false)
        tap.validateNumberOfTests(false)
      end
    end

    def generate_game_publisher(_, publishers)
      publishers.tag!('hudson.plugins.cigame.GamePublisher', :plugin => 'ci-game@1.19')
    end

    def generate_chucknorris_publisher(_, publishers)
      publishers.tag!('hudson.plugins.chucknorris.CordellWalkerRecorder', :plugin => 'chucknorris@0.5') do |chucknorris|
        chucknorris.factGenerator
      end
    end
  end
end
