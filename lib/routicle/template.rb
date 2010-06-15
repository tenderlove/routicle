module Routicle
  class Template
    def initialize
      @routes = {}
      @scangen = ScannerGenerator.new
      @gramgen = GrammarGenerator.new
    end

    def map route, desination
      @routes[route] = desination
    end

    def compile
      @routes.each do |resource, destination|
        tokens = @scangen.add resource
        @gramgen.add tokens, destination
      end
      @gramgen.to_parser.new @scangen.compile
    end
  end
end

