module JenkinsJob
  class View
    attr_reader :name, :jobname_

    def initialize(name, builder)
      @builder = builder
      @name = name
    end

    def job(regex)
      @jobname_ = regex
    end
  end
end
