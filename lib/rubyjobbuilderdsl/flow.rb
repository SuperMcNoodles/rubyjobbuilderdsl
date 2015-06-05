module JenkinsJob
  class Flow < Common::Common
    attr_reader :name, :dsl_

    def initialize(name, builder)
      super(builder)
      @name = name
    end

    def dsl(value)
      @dsl_ = value
    end
  end
end
