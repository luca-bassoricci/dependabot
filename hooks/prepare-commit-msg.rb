#!/usr/bin/env ruby

# frozen_string_literal: true

require "yaml"

branch = `git branch --show-current`
prefix = branch.split("-").first
categories = YAML.load_file(".gitlab/changelog_config.yml")["categories"]
return unless categories.key?(prefix)

commit_msg = ARGV[0]
File.write(commit_msg, "#{prefix}: #{File.read(commit_msg)}")
