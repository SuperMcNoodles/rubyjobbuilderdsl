require_relative './test_xml_generator'

class TestXmlCloverPhp < Test::Unit::TestCase
  def test_clover_php
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      postbuild do
        publish_cloverphp do
          xml_location 'build/coverage_clover.xml'
          html_report_dir 'build/coverage'
          healthy_target :method => 70, :statement => 80
        end
      end
    end

    actual = builder.config_as_xml_node('foo')
    { 'publishHtmlReport' => 'true',
      'reportDir' => 'build/coverage',
      'xmlLocation' => 'build/coverage_clover.xml',
      'disableArchiving' => 'false' }.each do |k, v|
      assert_equal v, actual.xpath("./project/publishers/org.jenkinsci.plugins.cloverphp.CloverPHPPublisher/#{k}").text, k
    end

    { 'methodCoverage' => '70',
      'statementCoverage' => '80' }.each do |k, v|
      assert_equal v, actual.xpath("./project/publishers/org.jenkinsci.plugins.cloverphp.CloverPHPPublisher/healthyTarget/#{k}").text, k
    end
    %w(unhealthyTarget failingTarget).each do |target|
      assert actual.at("./project/publishers/org.jenkinsci.plugins.cloverphp.CloverPHPPublisher/#{target}")
    end
  end
end
