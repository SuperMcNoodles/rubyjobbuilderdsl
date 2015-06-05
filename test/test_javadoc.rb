require_relative './test_xml_generator'

class TestXmlAnt < Test::Unit::TestCase
  def test_javadoc
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_javadoc do
          doc_dir 'build/doc'
          keep_all false
        end
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'keepAll' => 'false',
      'javadocDir' => 'build/doc' }.each do |k, v|
      assert_equal v, actual.xpath("./project/publishers/hudson.tasks.JavadocArchiver/#{k}").text, k
    end
  end
end
