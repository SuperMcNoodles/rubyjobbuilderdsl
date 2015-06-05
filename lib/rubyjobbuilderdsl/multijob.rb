require_relative './common'
require_relative './buildstep/phase'
require_relative './buildstep/phase_job'

module JenkinsJob
  class MultiJob < Common::Common
    include BuildStep

    attr_reader :name, :builders_

    def initialize(name, builder)
      super(builder)
      @name = name
      @builders_ = []
    end

    def phase(name, &block)
      phase = Phase.new(name)
      phase.instance_eval(&block) if block

      @builders_ << phase
    end
  end
end
