module Routicle
  class Template
    def initialize
      @routes = {}
    end

    def map route, desination
      @routes[route] = desination
    end

    def compile
      scangen  = ScannerGenerator.new

      @routes.each do |resource, destination|
        scangen << resource.split('/').find_all { |part| !part.empty? }
      end
    end
  end
end

