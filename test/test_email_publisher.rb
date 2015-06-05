require_relative './test_xml_generator'

class TestXmlEmailPublisher < Test::Unit::TestCase
  def test_postbuild_email_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        send_email 'test@example.com' do
          notify_every_unstable_build false
          send_to_individuals true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'recipients' => 'test@example.com',
      'dontNotifyEveryUnstableBuild' => 'true',
      'sendToIndividuals' => 'true'
     }.each do |k, v|
       assert_equal v, actual.xpath("./project/publishers/hudson.tasks.Mailer/#{k}").text, k
     end
  end

  def test_postbuild_email_publisher_defaults
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        send_email 'test@example.com'
      end
    end

    actual = builder.config_as_xml_node('foo')

    { 'recipients' => 'test@example.com',
      'dontNotifyEveryUnstableBuild' => 'false',
      'sendToIndividuals' => 'false'
     }.each do |k, v|
       assert_equal v, actual.xpath("./project/publishers/hudson.tasks.Mailer/#{k}").text, k
     end
  end
end
