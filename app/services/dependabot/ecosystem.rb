# frozen_string_literal: true

module Dependabot
  # :reek:TooManyConstants
  class Ecosystem
    BUNDLER = "bundler"
    COMPOSER = "composer"
    GO = "gomod"
    GRADLE = "gradle"
    MAVEN = "maven"
    NPM = "npm"
    PIP = "pip"
    NUGET = "nuget"
    GIT = "gitsubmodule"
    MIX = "mix"
    CARGO = "cargo"

    PACKAGE_ECOSYSTEM_MAPPING = {
      NPM => "npm_and_yarn",
      GO => "go_modules",
      GIT => "submodules",
      MIX => "hex"
    }.freeze
  end
end
