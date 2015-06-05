require_relative './test_xml_generator'

class TestXmlFlow < Test::Unit::TestCase
  def test_flow
    groovy_code = <<EOS
build("ops-" + params["GERRIT_BRANCH"], GERRIT_REFSPEC: "refs/heads/${params["GERRIT_BRANCH"]}",
  GERRIT_BRANCH: params["GERRIT_BRANCH"])
EOS
    builder = JenkinsJob::Builder.new
    builder.flow 'foo' do
      dsl groovy_code
    end

    actual = builder.config_as_xml_node('foo')
    { 'buildNeedsWorkspace' => 'true', 'dsl' => groovy_code }.each do |k, v|
      assert_equal v, actual.xpath("./com.cloudbees.plugins.flow.BuildFlow/#{k}").text, k
    end
  end
end
