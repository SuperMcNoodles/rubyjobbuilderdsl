require_relative 'postbuild/archive'
require_relative 'postbuild/logparser'
require_relative 'postbuild/html_publisher'
require_relative 'postbuild/email_publisher'
require_relative 'postbuild/nunit_publisher'
require_relative 'postbuild/xunit_publisher'
require_relative 'postbuild/cloverphp_publisher'
require_relative 'postbuild/javadoc_publisher'
require_relative 'postbuild/pmd_publisher'
require_relative 'postbuild/claim_publisher'
require_relative 'postbuild/tap_publisher'
require_relative 'postbuild/chucknorris_publisher'
require_relative 'postbuild/game_publisher'
require_relative 'postbuild/script'
require_relative 'postbuild/trigger'
require_relative 'postbuild/groovy'
require_relative 'postbuild/cucumber_json_publisher'
require_relative 'buildstep/shell'

# dsl methods for job builder
module JenkinsJob
  module Postbuild
    class Postbuild < BasicObject
      attr_reader :job, :publishers_

      def initialize(job)
        @job = job
        @publishers_ = {}
      end

      def archive(&block)
        # sandbox for archive dsl
        archive = Archive.new
        archive.instance_eval(&block)

        @publishers_['archive'] = archive
      end

      def publish_html(name, &block)
        # sandbox for html publisher dsl
        publisher = HtmlPublisher.new(name)
        publisher.instance_eval(&block)

        @publishers_['publish_html'] ||= []
        @publishers_['publish_html'] << publisher
      end

      def send_email(recipients, &block)
        publisher = EmailPublisher.new(recipients)
        publisher.instance_eval(&block) if block

        @publishers_['send_email'] = publisher
      end

      def publish_nunit_report(test_results_pattern, &block)
        publisher = NUnitPublisher.new(test_results_pattern)
        publisher.instance_eval(&block) if block

        @publishers_['publish_nunit_report'] = publisher
      end

      def publish_xunit_report(test_results_pattern, &block)
        publisher = XUnitPublisher.new(test_results_pattern)
        publisher.instance_eval(&block) if block

        @publishers_['publish_xunit_report'] = publisher
      end

      def publish_tap(test_results, &block)
        publisher = TapPublisher.new(test_results)
        publisher.instance_eval(&block) if block

        @publishers_['publish_tap'] = publisher
      end

      def logparser(rule_file, &block)
        # sandbox for html publisher dsl
        logparser = LogParser.new(rule_file)
        logparser.instance_eval(&block) if block

        @publishers_['logparser'] = logparser
      end

      def shell(value)
        @publishers_['postbuildscript'] ||= PostbuildScript.new
        @publishers_['postbuildscript'].add(::JenkinsJob::BuildStep::Shell.new(value))
      end

      def batch(value)
        @publishers_['postbuildscript'] ||= PostbuildScript.new
        @publishers_['postbuildscript'].add(::JenkinsJob::BuildStep::Batch.new(value))
      end

      def powershell(value)
        @publishers_['postbuildscript'] ||= PostbuildScript.new
        @publishers_['postbuildscript'].add(::JenkinsJob::BuildStep::Powershell.new(value))
      end

      def trigger(*project, &block)
        trigger = PostbuildTrigger.new(project)
        trigger.instance_eval(&block) if block
        @publishers_['trigger-parameterized-builds'] = trigger
      end

      def groovy(value)
        @publishers_['groovy'] = PostbuildGroovy.new(value)
      end

      def publish_cloverphp(&block)
        clover = CloverPhpPublisher.new
        clover.instance_eval(&block) if block
        @publishers_['clover-php'] = clover
      end

      def cucumber_json_publisher(&block)
        cucumber = CucumberJsonPublisher.new
        cucumber.instance_eval(&block) if block
        @publishers_['cucumber'] = cucumber
      end

      def publish_javadoc(&block)
        doc = JavaDocPublisher.new
        doc.instance_eval(&block) if block
        @publishers_['java-doc'] = doc
      end

      def publish_pmd(&block)
        pmd = PMDPublisher.new
        pmd.instance_eval(&block) if block
        @publishers_['pmd'] = pmd
      end

      def publish_chucknorris(&block)
        chucknorris = ChuckNorrisPublisher.new
        chucknorris.instance_eval(&block) if block
        @publishers_['chucknorris'] = chucknorris
      end
      alias_method :chucknorris, :publish_chucknorris

      def publish_game(&block)
        game = GamePublisher.new
        game.instance_eval(&block) if block
        @publishers_['game'] = game
      end
      alias_method :game, :publish_game

      def allow_broken_build_claiming
        publisher = ClaimPublisher.new
        @publishers_['claim-publisher'] = publisher
      end
    end
  end
end
