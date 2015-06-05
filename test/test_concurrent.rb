require_relative './test_xml_generator'

class TestXmlConcurrent < Test::Unit::TestCase
  def test_concurrent_per_project
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      concurrent do
        max_per_node 2
        max_total 0
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 'true', actual.xpath('./project/concurrentBuild').text

    { 'maxConcurrentPerNode' => '2', 'maxConcurrentTotal' => '0', 'throttleEnabled' => 'true',
     'throttleOption' => 'project', 'configVersion' => '1' }.each do |k, v|
      assert_equal v, actual.xpath("./project/properties/hudson.plugins.throttleconcurrents.ThrottleJobProperty/#{k}").text, k
    end
  end

  def test_concurrent_per_category
    builder = JenkinsJob::Builder.new

    builder.freestyle 'foo' do
      concurrent do
        max_per_node 2
        max_total 0
        category 'servicetest'
      end
    end

    actual = builder.config_as_xml_node('foo')

    assert_equal 'true', actual.xpath('./project/concurrentBuild').text

    { 'maxConcurrentPerNode' => '2', 'maxConcurrentTotal' => '0', 'throttleEnabled' => 'true',
     'throttleOption' => 'category', 'configVersion' => '1', 'categories/string' => 'servicetest' }.each do |k, v|
      assert_equal v, actual.xpath("./project/properties/hudson.plugins.throttleconcurrents.ThrottleJobProperty/#{k}").text, k
    end
  end
end
