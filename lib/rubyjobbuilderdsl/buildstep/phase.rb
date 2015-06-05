module JenkinsJob
  module BuildStep
    class Phase < BasicObject
      attr_reader :name, :jobs_

      def initialize(name)
        @name = name
        @jobs_ = []
      end

      def job(name, &block)
        job = PhaseJob.new(name)
        job.instance_eval(&block) if block

        @jobs_ << job
      end
    end
  end
end
