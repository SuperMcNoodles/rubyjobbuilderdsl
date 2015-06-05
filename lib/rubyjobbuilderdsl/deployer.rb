require_relative './jenkins_client'

module JenkinsJob
  class Deployer
    def initialize(*builder)
      @builders = builder
    end

    def each(&block)
      @builders.each do |b|
        b.generate_xml do |name, xml, type|
          yield name, xml, type if block
        end
      end
    end

    def generate_xml
      outputdir = ARGV.find { |z| z =~ /--output-dir=/ }.to_s.split('=')[1]
      usage unless outputdir

      each do |name, xml, type|
        path = "#{outputdir}/#{name}.xml"
        $stdout.puts "creating #{type} #{path}"
        File.open(path, 'w+') do |f|
          f.write(xml)
        end
      end
    end

    def deploy(&block)
      config_file = ARGV.find { |z| z =~ /--config-file=/ }.to_s.split('=')[1]
      usage unless config_file

      config = {}
      File.read(config_file).each_line do |line|
        if line =~ /\S+\=\S+/
          key, val = line.split('=')
          config[key] = val.chomp
        end
      end

      client = JenkinsClient.new(config['url'], config['user'], config['password'])
      deployer = self
      client.instance_eval do
        @deployer = deployer
        def each(&block)
          @deployer.each(&block)
        end
      end

      unless block
        block = proc do
          each do |name, xml, type|
            upload_job(name, xml) if type == :job
            upload_view(name, xml) if type == :view
          end
        end
      end

      client.instance_eval(&block)
    end

    def usage
      $stderr.puts(<<-EOS
Usage:

ruby #{File.basename($PROGRAM_NAME)} --xml --output-dir=.|--deploy --config-file=config/localhost.ini]

Example:

ruby #{File.basename($PROGRAM_NAME)} --xml --output-dir=.
ruby #{File.basename($PROGRAM_NAME)} --deploy --config-file=config/localhost.ini
EOS
      )
      exit 1
    end

    def run(&block)
      xml = ARGV.find { |a| a == '--xml' }
      deploy = ARGV.find { |a| a == '--deploy' }

      if xml
        generate_xml
        exit 0
      end

      if deploy
        deploy(&block)
        exit 0
      end

      usage
    end
  end
end
