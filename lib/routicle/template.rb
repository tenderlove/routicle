module Routicle
  class Template
    def initialize
      @routes = {}
    end

    def map route, desination
      @routes[route] = desination
    end

    def compile
      scanner = ScannerGenerator.new

      @routes.each do |resource, destination|
        scanner << resource.split('/').find_all { |part| !part.empty? }
      end
    end
  end
end

