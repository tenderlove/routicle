require 'erb'
require 'routicle/template/scanner'

module Routicle
  class ScannerGenerator
    attr_reader :lexemes

    def initialize
      @template_scanner = Routicle::Template::Scanner.new
      @lexemes = []
    end

    ###
    # Adds a +route+ to the scanner generator.  Returns the token
    # names for each token.
    #
    #   scangen.add('/foo') # => [:SLASH, :STRING2]

    def add route
      tuples = @template_scanner.parse route
      @lexemes += tuples
      @lexemes.uniq!
      tuples.map { |x| x.first }
    end
    alias :<< :add

    def compile
      line = __LINE__ + 2
      template = <<-eos
        def next_token
          return if @ss.eos?
          case
          <% @lexemes.each do |sym, regex| %>
          when text = @ss.scan(<%= regex %>)
            [:<%= sym %>, text]
          <% end %>
          else
            raise "can't match %s", @ss.string[@ss.pos .. -1]
          end
        end
      eos
      scanner_src = ERB.new(template).result(binding)

      if $DEBUG
        puts "######### SCANNER SOURCE"
        puts scanner_src
        puts "######### END SCANNER SOURCE"
      end

      klass = Class.new(Scanner)
      klass.class_eval scanner_src, __FILE__, line
      klass.new
    end
  end
end
