require 'net/http'
require 'net/https'
require 'uri'
require 'base64'
require 'nokogiri'

module JenkinsJob
  class JenkinsClient
    attr_reader :server_url, :username, :password

    def initialize(server_url, username, password)
      @server_url = server_url
      @username = username
      @password = password
    end

    def upload_job(name, xml)
      if job_exists?(name)
        $stderr.puts "updating job #{name}"
        request_uri = "/job/#{name}/config.xml"
      else
        $stderr.puts "creating job #{name}"
        request_uri = "/createItem?name=#{name}"
      end

      request = Net::HTTP::Post.new(request_uri)
      request.content_type = 'application/xml;charset=UTF-8'
      request.body = xml

      response = send_request(request)

      $stderr.puts response.body if response.code == '200'
    end

    def upload_view(name, xml)
      if view_exists?(name)
        $stderr.puts "updating view #{name}"
        request_uri = "/view/#{name}/config.xml"
      else
        $stderr.puts "creating view #{name}"
        request_uri = "/createView?name=#{name}"
      end

      request = Net::HTTP::Post.new(request_uri)
      request.content_type = 'application/xml;charset=UTF-8'
      request.body = xml

      response = send_request(request)

      $stderr.puts response.body if response.code == '200'
    end

    def upload_file(remote_name, content)
      base64_content = Base64.strict_encode64(content)

      groovy_script = <<-EOS
      import org.apache.commons.codec.binary.Base64
      Base64 coder = new Base64()
      env = System.getenv()
      new File(env['JENKINS_HOME'] + '/#{remote_name}').withWriter {
        out -> out.write(new String(coder.decode('#{base64_content}')))
      }
      EOS

      groovysh(groovy_script)
    end

    def groovysh(groovy_script)
      $stdout.puts 'running groovy script'
      request = Net::HTTP::Post.new('/scriptText')

      request.set_form_data('script' => groovy_script)

      response = send_request(request)

      $stderr.puts response.body if response.code == '200'

      response = send_request(request)

      $stderr.puts response.body if response.code == '200'
    end

    def delete_view(name)
      $stdout.puts "deleting view #{name}"
      if view_exists?(name)
        request = Net::HTTP::Post.new("/view/#{name}/doDelete")
        response = send_request(request)
        $stderr.puts response.body if response.code == '200'
      else
        $stdout.puts "view #{name} doesn't exists"
      end
    end

    def delete_job(name)
      $stdout.puts "deleting job #{name}"
      if job_exists?(name)
        request = Net::HTTP::Post.new("/job/#{name}/doDelete")
        response = send_request(request)
        $stderr.puts response.body if response.code == '200'
      else
        $stdout.puts "job #{name} doesn't exists"
      end
    end

    def wipeout_workspace(name)
      $stdout.puts "wiping out workspace of #{name}"
      if job_exists?(name)
        request = Net::HTTP::Post.new("/job/#{name}/doWipeOutWorkspace")
        send_request(request)
      else
        $stdout.puts "job #{name} doesn't exists"
      end
    end

    def disable_job(name)
      $stdout.puts "disabling job #{name}"
      if job_exists?(name)
        request = Net::HTTP::Post.new("/job/#{name}/disable")
        send_request(request)
      else
        $stdout.puts "job #{name} doesn't exists"
      end
    end

    def enable_job(name)
      $stdout.puts "enabling job #{name}"
      if job_exists?(name)
        request = Net::HTTP::Post.new("/job/#{name}/enable")
        send_request(request)
      else
        $stdout.puts "job #{name} doesn't exists"
      end
    end

    def trigger_job(name)
      $stdout.puts "buiding job #{name}"
      if job_exists?(name)
        request = Net::HTTP::Post.new("/job/#{name}/build")
        send_request(request)
      else
        $stdout.puts "job #{name} doesn't exists"
      end
    end

    def jobs(filter)
      if jenkins_xml_doc
        jenkins_xml_doc.xpath('//job/name').map(&:text).select { |name| name =~ /#{filter}/ }
      else
        []
      end
    end

    private

    def jenkins_xml_doc(force = true)
      if force || @jenkins_xml_doc.nil?
        request = Net::HTTP::Get.new('/api/xml')
        response = send_request(request)
        if response.code == '200'
          @jenkins_xml_doc = Nokogiri::XML.parse(response.body)
        end
      end
      @jenkins_xml_doc
    end

    def job_exists?(name)
      if jenkins_xml_doc
        jenkins_xml_doc.xpath('//job/name').map(&:text).include?(name)
      else
        false
      end
    end

    def view_exists?(name)
      if jenkins_xml_doc
        jenkins_xml_doc.xpath('//view/name').map(&:text).include?(name)
      else
        false
      end
    end

    def send_request(request)
      uri = URI.parse("#{server_url}")
      http = Net::HTTP.new(uri.host, uri.port)

      if server_url =~ /^https:/
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request.basic_auth(username, password)
      response = http.request(request)

      if response.code.to_i < 200 || response.code.to_i > 399
        $stderr.puts "Error posting to #{request.path}"
        $stderr.puts "Http response.code: #{response.code}"
        $stderr.puts "Http response.body:\n#{response.body}\n"
      end

      response
    end
  end
end
