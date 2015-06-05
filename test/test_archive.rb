require_relative './test_xml_generator'

class TestXmlArchive < Test::Unit::TestCase
  def test_postbuild_archive
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        archive do
          file 'a/**',
               'b/**',
               'c/lib/**'
          latest_only true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'artifacts' => 'a/**,b/**,c/lib/**',
      'latestOnly' => 'true' }.each do |k, v|
      assert_equal v, actual.xpath("./project/publishers/hudson.tasks.ArtifactArchiver/#{k}").text, k
    end
  end
end
