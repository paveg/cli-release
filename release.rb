require 'octokit'
VERSION_PREFIX = 'v'.freeze
REPO_NAME = 'paveg/cli-release'.freeze

def prepare
  client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
  repo = client.repo(REPO_NAME)
  latest_tag = client.latest_release(repo.full_name).tag_name

  [client, repo, latest_tag]
end

def increment_version(version, semver = :patch)
  major, minor, patch = version.delete(VERSION_PREFIX).split('.').map(&:to_i)
  case semver
  when :major
    major += 1
  when :minor
    minor += 1
  when :patch
    patch += 1
  end
  current_ver = [major, minor, patch].join('.')
  [VERSION_PREFIX, current_ver].join
end

client, repo, latest_tag = prepare
new_tag = increment_version(latest_tag, :patch)
client.create_release(repo.full_name, new_tag)
