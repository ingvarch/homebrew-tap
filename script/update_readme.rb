# Rebuilds the cask table in README.md from Casks/*.rb.
module UpdateReadme
  START = "<!-- casks:start -->".freeze
  FINISH = "<!-- casks:end -->".freeze

  module_function

  def render(readme, casks)
    head, rest = readme.split(START, 2)
    _, tail = rest&.split(FINISH, 2)
    raise "README.md needs #{START} and #{FINISH}" unless tail

    "#{head}#{START}\n#{table(casks)}#{FINISH}#{tail}"
  end

  def table(casks)
    rows = casks.map { |text| parse(text) }.sort_by { |c| c[:token] }.map do |c|
      "| [#{c[:token]}](#{c[:homepage]}) | #{c[:desc]} |\n"
    end
    "| Cask | What it is |\n| --- | --- |\n#{rows.join}"
  end

  def parse(text)
    token = text[/^cask "([^"]+)"/, 1]
    %i[desc homepage].to_h do |key|
      [key, text[/^\s*#{key} "(.*)"$/, 1] || raise("cask #{token} has no #{key}")]
    end.merge(token: token)
  end
end

if $PROGRAM_NAME == __FILE__
  root = File.expand_path("..", __dir__)
  readme = File.join(root, "README.md")
  casks = Dir[File.join(root, "Casks", "*.rb")].map { |path| File.read(path) }
  File.write(readme, UpdateReadme.render(File.read(readme), casks))
end
