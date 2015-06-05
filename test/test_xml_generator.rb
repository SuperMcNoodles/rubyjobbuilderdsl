require 'test/unit'
require 'nokogiri'
require 'fileutils'

require_relative '../lib/rubyjobbuilderdsl'

module JenkinsJob
  class Builder
    def tmpdir
      ::File.join(File.dirname(__FILE__), '..', 'tmp')
    end

    def debug
      ::File.exist?(tmpdir)
    end

    def config_as_xml_node(jobname)
      generate_xml do |name, xml|
        if name == jobname
          File.open(::File.join(tmpdir, "#{name}.xml"), 'w+') do |f|
            f.write(xml)
          end if debug
          return Nokogiri::XML.parse(xml)
        end
      end
    end
  end
end
