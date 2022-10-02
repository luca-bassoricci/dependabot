# frozen_string_literal: true

module Gitlab
  class LabelCreator < ApplicationService
    def initialize(project_name:, name:, color:)
      @project_name = project_name
      @name = name
      @color = color
    end

    def call
      log(:debug, "Creating label #{name}")
      return log(:debug, "Skipping label creation, already exists!") if exists?

      gitlab.create_label(project_name, name, color)
    end

    private

    attr_reader :project_name, :name, :color

    # Check if label exists
    #
    # @return [Boolean]
    def exists?
      project_labels.include?(name)
    end

    # Project labels
    #
    # @return [Array]
    def project_labels
      RequestStore.fetch(:labels) { gitlab.labels(project_name).auto_paginate.map(&:name) }
    end
  end
end
