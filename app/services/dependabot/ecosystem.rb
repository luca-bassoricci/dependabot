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
  end
end
