# frozen_string_literal: true

# Remove unnecessary logging of metrics requests
#
module Yabeda
  module Prometheus
    module Mmap
      class Exporter < ::Prometheus::Client::Rack::Exporter
        def self.rack_app(exporter = self, path: "/metrics")
          Rack::Builder.new do
            use ::Rails::Rack::Logger
            use Rack::ShowExceptions
            use exporter, path: path
            run NOT_FOUND_HANDLER
          end
        end
      end
    end
  end
end
