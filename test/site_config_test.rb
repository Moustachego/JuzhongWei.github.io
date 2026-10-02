require "minitest/autorun"
require "yaml"

class SiteConfigTest < Minitest::Test
  CONFIG_PATH = File.expand_path("../_config.yml", __dir__)
  NAVIGATION_PATH = File.expand_path("../_data/navigation.yml", __dir__)

  def setup
    @config = YAML.safe_load(File.read(CONFIG_PATH), aliases: true)
  end

  def test_jekyll_keeps_pages_and_utf8_output_enabled
    assert_includes @config.fetch("include"), "_pages"
    assert_equal "utf-8", @config.fetch("encoding")
    assert_equal "kramdown", @config.fetch("markdown")
  end

  def test_project_pages_metadata_uses_supported_locale_and_path
    assert_equal "zh-CN", @config.fetch("locale")
    assert_equal "/JuzhongWei.github.io", @config.fetch("baseurl")
    assert_equal "Moustachego/JuzhongWei.github.io", @config.fetch("repository")
    assert_equal %w[books manuscripts conferences], @config.fetch("publication_category").keys
    refute @config.fetch("author").key?("publication_category")
  end

  def test_top_navigation_contains_only_publications
    navigation = YAML.safe_load(File.read(NAVIGATION_PATH), aliases: true)

    assert_equal(
      [{"title" => "Publications", "url" => "/publications/"}],
      navigation.fetch("main")
    )
  end
end
