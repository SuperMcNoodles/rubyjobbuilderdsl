require_relative './test_xml_generator'

class TestXmlHtmlPublisher < Test::Unit::TestCase
  def test_postbuild_html_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_html 'Test Report' do
          dir '$BUILD_NUMBER\\Reports'
          file 'test-report.html'
          keep_all false
          allow_missing true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    {
      'reportName' => 'Test Report',
      'reportDir' => '$BUILD_NUMBER\Reports',
      'reportFiles' => 'test-report.html',
      'keepAll' => 'false',
      'allowMissing' => 'true',
      'wrapperName' => 'htmlpublisher-wrapper.html'
    }.each do |k, v|
      assert_equal v, actual.xpath('./project/publishers/htmlpublisher.HtmlPublisher/' \
        "reportTargets/htmlpublisher.HtmlPublisherTarget/#{k}").text, k
    end
  end

  def test_postbuild_multiple_html_publisher
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_html 'Test Report' do
          dir '$BUILD_NUMBER\\Reports'
          file 'test-report.html'
          keep_all false
          allow_missing true
        end
        publish_html 'Test Report 2' do
          dir '$BUILD_NUMBER\\Reports'
          file 'test-report-2.html'
          keep_all false
          allow_missing true
        end
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 2, actual.xpath('count(./project/publishers/htmlpublisher.HtmlPublisher)').to_i
  end
end
