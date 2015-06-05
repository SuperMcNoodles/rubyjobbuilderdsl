require_relative 'common/parameter'
require_relative 'common/git'
require_relative 'common/gerrit'
require_relative 'common/logrotate'
require_relative 'common/scms'
require_relative 'common/throttle'
require_relative 'common/build_timeout'
require_relative 'common/artifactory'
require_relative 'common/pollscm'
require_relative 'common/timed'
require_relative 'common/password'
require_relative 'common/timestamps'
require_relative 'common/blocking_job'
require_relative 'postbuild'

module JenkinsJob
  module Common
    class Common
      attr_reader :builder,
                  :node_, :quiet_period_, :logrotate_,
                  :parameters_, :postbuild_, :scm_,
                  :triggers_, :concurrent_, :wrappers_, :properties_,
                  :desc_

      def initialize(builder)
        @builder = builder
        @triggers_ = {}
        @wrappers_ = {}
        @properties_ = {}
        @parameters_ = {}
        @concurrent_ = false
      end

      def node(value)
        @node_ = value
      end

      def quiet_period(value)
        @quiet_period_ = value
      end

      def logrotate(&block)
        rotate = LogRotate.new
        rotate.instance_eval(&block)
        @logrotate_ = rotate
      end

      def parameter(name, &block)
        param = Parameter.new(name)
        param.instance_eval(&block) if block_given?

        @parameters_[name] = param
      end

      def password_parameter(name, &block)
        param = PasswordParameter.new(name)
        param.instance_eval(&block) if block_given?

        @parameters_[name] = param
      end

      def postbuild(&block)
        @postbuild_ = ::JenkinsJob::Postbuild::Postbuild.new(self) unless @postbuild_
        @postbuild_.instance_eval(&block)
      end

      def git(&block)
        git = Git.new
        git.instance_eval(&block)

        @scm_ = git
      end

      def scms(&block)
        scms = Scms.new
        scms.instance_eval(&block)

        @scm_ = scms
      end

      def gerrit(&block)
        gerrit = Gerrit.new
        gerrit.instance_eval(&block)

        @triggers_['gerrit'] = gerrit
      end

      def pollscm(value)
        @triggers_['pollscm'] = PollSCM.new(value)
      end

      def timed(value)
        @triggers_['timed'] = Timed.new(value)
      end

      def concurrent(&block)
        @concurrent_ = true

        throttle = Throttle.new
        throttle.instance_eval(&block)

        @properties_['throttle'] = throttle
      end

      def timestamps
        @wrappers_['timestamp'] = Timestamps.new
      end

      def timeout(type, &block)
        build_timeout = BuildTimeout.new(type)
        build_timeout.instance_eval(&block)

        @wrappers_['timeout'] = build_timeout
      end

      def artifactory(&block)
        artifact = Artifactory.new
        artifact.instance_eval(&block)

        @wrappers_['artifactory'] = artifact
      end

      def password(name, password)
        password = Password.new(name, password)

        @wrappers_['password'] = password
      end

      def blocked_by(*value)
        blocking_job = BlockingJob.new(value)

        @properties_['blocking_job'] = blocking_job
      end

      def desc(value)
        @desc_ = value
      end
    end
  end
end
