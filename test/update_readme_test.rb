require "minitest/autorun"
require_relative "../script/update_readme"

class UpdateReadmeTest < Minitest::Test
  def cask(token, version: "1.0.0", desc: "Tool #{token}", homepage: "https://github.com/ingvarch/#{token}")
    lines = [%(cask "#{token}" do)]
    lines << %(  version "#{version}") if version
    lines << %(  desc "#{desc}") if desc
    lines << %(  homepage "#{homepage}") if homepage
    lines << "end"
    lines.join("\n")
  end

  README = <<~MD
    # homebrew-tap

    <!-- casks:start -->
    old table
    <!-- casks:end -->

    Footer.
  MD

  def test_replaces_table_between_markers_and_keeps_the_rest
    result = UpdateReadme.render(README, [cask("urga", version: "0.12.0", desc: "Terminal UI for HashiCorp Nomad")])

    assert_equal <<~MD, result
      # homebrew-tap

      <!-- casks:start -->
      | Cask | Version | What it is |
      | --- | --- | --- |
      | [urga](https://github.com/ingvarch/urga) | 0.12.0 | Terminal UI for HashiCorp Nomad |
      <!-- casks:end -->

      Footer.
    MD
  end

  def test_sorts_casks_by_token
    result = UpdateReadme.render(README, [cask("urga"), cask("azt"), cask("tent")])

    rows = result.lines.grep(/^\| \[/).map { |l| l[/\[(\w+)\]/, 1] }
    assert_equal %w[azt tent urga], rows
  end

  def test_fails_without_markers
    error = assert_raises(RuntimeError) { UpdateReadme.render("# no markers\n", [cask("urga")]) }
    assert_match "casks:start", error.message
  end

  def test_fails_on_cask_without_version
    error = assert_raises(RuntimeError) { UpdateReadme.render(README, [cask("urga", version: nil)]) }
    assert_match(/urga.*version/, error.message)
  end

  def test_fails_on_cask_without_desc
    error = assert_raises(RuntimeError) { UpdateReadme.render(README, [cask("urga", desc: nil)]) }
    assert_match(/urga.*desc/, error.message)
  end

  def test_fails_on_cask_without_homepage
    error = assert_raises(RuntimeError) { UpdateReadme.render(README, [cask("urga", homepage: nil)]) }
    assert_match(/urga.*homepage/, error.message)
  end
end
