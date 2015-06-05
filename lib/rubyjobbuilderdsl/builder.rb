require_relative 'freestyle'
require_relative 'flow'
require_relative 'multijob'
require_relative 'view'
require_relative 'xml_generator'

module JenkinsJob
  # dsl methods for job builder
  class Builder
    attr_reader :jobs, :views

    def initialize(&block)
      @default_setting = []
      @default_setting << block if block_given?
      @jobs = {}
      @views = {}
    end

    def add_extension(&block)
      @default_setting << block if block_given?
    end

    def freestyle(name, &block)
      @jobs[name] = FreeStyle.new(name, self)

      @default_setting.each do |extension|
        @jobs[name].instance_eval(&extension)
      end

      @jobs[name].instance_eval(&block)
    end

    def flow(name, &block)
      @jobs[name] = Flow.new(name, self)

      @default_setting.each do |extension|
        @jobs[name].instance_eval(&extension)
      end

      @jobs[name].instance_eval(&block)
    end

    def multi(name, &block)
      @jobs[name] = MultiJob.new(name, self)

      @default_setting.each do |extension|
        @jobs[name].instance_eval(&extension)
      end

      @jobs[name].instance_eval(&block)
    end

    def view(name, &block)
      @views[name] = View.new(name, self)
      @views[name].instance_eval(&block)
    end

    def generate_xml
      return unless block_given?
      generator = XmlGenerator.new
      @jobs.each do |name, job|
        yield name, generator.generate(job), :job
      end
      @views.each do |name, job|
        yield name, generator.generate(job), :view
      end
    end
  end
end
