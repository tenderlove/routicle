require 'erb'

module Routicle
  class ScannerGenerator
    attr_reader :lexemes

    def initialize
      @lexemes = [
        [:ID, '/\d+/'],
        [:SLASH, '/\//']
      ]
    end

    def possible_tokens
      @lexemes.map { |tuple| tuple.first }
    end

    ###
    # Adds a sequence of +tokens+ to the scanner generator.  Returns the token
    # names for each token.
    #
    #   scangen.add(%w{ / foo }) # => [:SLASH, :STRING2]

    def add tokens
      seq = []
      tokens.each do |token|
        if ':id' == token
          seq << :ID
          next
        end

        # FIXME: this is a total hack
        matcher = "/#{token.sub(/\//, '\/')}/"

        if tuple = @lexemes.find { |k,v| v == matcher }
          seq << tuple.first
        else
          tuple = [:"STRING#{@lexemes.length}", "/#{token}/"]
          seq << tuple.first
          @lexemes << tuple
        end
      end
      seq
    end
    alias :<< :add

    def compile
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
      klass = Class.new(Scanner)
      klass.class_eval ERB.new(template).result(binding)
      klass.new
    end
  end
end
