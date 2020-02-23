source 'https://rubygems.org'

git_source(:biggerconcept) do |repo_name|
  username = ENV['BIGGERCONCEPT_CI_USER']
  password = ENV['BIGGERCONCEPT_CI_PASSWORD']
  git_host = ENV['BIGGERCONCEPT_GIT_HOSTpro']
  "https://#{username}:#{password}@#{git_host}/#{repo_name}"
end

gemspec
