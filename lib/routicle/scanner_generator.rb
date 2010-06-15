require 'erb'
require 'routicle/template/scanner'

module Routicle
  class ScannerGenerator
    attr_reader :lexemes

    def initialize
      @template_scanner = Routicle::Template::Scanner.new
      @lexemes = {}
    end

    def possible_tokens
      @lexemes.keys.map { |tuple| tuple.first }
    end

    ###
    # Adds a sequence of +tokens+ to the scanner generator.  Returns the token
    # names for each token.
    #
    #   scangen.add(%w{ / foo }) # => [:SLASH, :STRING2]

    def add route
      tuples = @template_scanner.parse route
      tuples.each { |tuple| @lexemes[tuple] = true }
      tuples.map { |x| x.first }
    end
    alias :<< :add

    def compile
      line = __LINE__ + 2
      template = <<-eos
        def next_token
          return if @ss.eos?
          case
          <% @lexemes.keys.each do |sym, regex| %>
          when text = @ss.scan(<%= regex %>)
            [:<%= sym %>, text]
          <% end %>
          else
            raise "can't match %s", @ss.string[@ss.pos .. -1]
          end
        end
      eos
      klass = Class.new(Scanner)
      klass.class_eval ERB.new(template).result(binding), __FILE__, line
      klass.new
    end
  end
end
