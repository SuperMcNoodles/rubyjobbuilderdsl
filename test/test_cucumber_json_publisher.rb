require_relative './test_xml_generator'

class TestCucumberPublisher < Test::Unit::TestCase
  def test_postbuild_cucumber_json_publisher
    file_location = 'cucumber/results.json'
    ignore_bad_results = 'false'

    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        cucumber_json_publisher do
          test_results file_location
          ignore_bad_tests ignore_bad_results
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    {
      'testResults' => file_location,
      'ignoreBadSteps' => ignore_bad_results,
    }.each do |k, v|
      path = ['./project/publishers/org.jenkinsci.plugins.cucumber.',
              "jsontestsupport.CucumberTestResultArchiver/#{k}"].join('')
      assert_equal v, actual.xpath(path).text
    end
  end
end
