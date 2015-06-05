require_relative './common'
require_relative './buildstep/shell'
require_relative './buildstep/copyartifact'
require_relative './buildstep/inject_env'
require_relative './buildstep/ant'

module JenkinsJob
  class FreeStyle < Common::Common
    include BuildStep

    attr_reader :name, :workspace_, :builders_

    def initialize(name, builder)
      super(builder)
      @name = name
      @builders_ = []
    end

    def workspace(value)
      @workspace_ = value
    end

    def shell(cmd)
      @builders_ << Shell.new(cmd)
    end

    def batch(cmd)
      @builders_ << Batch.new(cmd)
    end

    def powershell(cmd)
      @builders_ << Powershell.new(cmd)
    end

    def inject_env(&block)
      inject = InjectEnv.new
      inject.instance_eval(&block) if block_given?

      @builders_ << inject
    end

    def ant(&block)
      ant = Ant.new
      ant.instance_eval(&block) if block_given?

      @builders_ << ant
    end

    def copyartifact(artifact_job, &block)
      # sandbox for copy artifacts dsl
      copyartifact = CopyArtifact.new(artifact_job)
      copyartifact.instance_eval(&block)

      @builders_ << copyartifact
    end
  end
end
