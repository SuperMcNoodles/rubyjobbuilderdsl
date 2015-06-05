module JenkinsJob
  module Common
    class Git < BasicObject
      attr_reader :url_, :basedir_, :reference_repo_, :branches_, :refspec_,
                  :choosing_strategy_, :git_config_name_, :git_config_email_,
                  :fastpoll_, :files_, :wipe_workspace_, :clean_, :jgit_, :credentials_

      def initialize
        @fastpoll_ = true
        @branches_ = ['*/master']
        @jgit_ = false
      end

      def url(value)
        @url_ = value
      end

      def basedir(value)
        @basedir_ = value
      end

      def reference_repo(value)
        @reference_repo_ = value
      end

      # @deprecated Please use {#branch}
      def branches(*value)
        branch(*value)
      end

      def branch(*value)
        @branches_ = value
      end

      def refspec(value)
        @refspec_ = value
      end

      def choosing_strategy(value)
        @choosing_strategy_ = value
      end

      def git_config_name(value)
        @git_config_name_ = value
      end

      def git_config_email(value)
        @git_config_email_ = value
      end

      def fastpoll(value = true)
        @fastpoll_ = value
      end

      def file(*value)
        @files_ = value
      end

      def clean(value = false)
        @clean_ = value
      end

      def wipe_workspace(value = true)
        @wipe_workspace_ = value
      end

      def jgit
        @jgit_ = true
      end

      def credentials(value)
        @credentials_ = value
      end
    end
  end
end
