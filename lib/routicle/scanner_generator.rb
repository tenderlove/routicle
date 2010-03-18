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

    def << tokens
      tokens.each do |token|
        next if ':id' == token

        matcher = "/#{token}/"
        next if @lexemes.any? { |k,v| v == matcher }

        @lexemes << [:"STRING#{@lexemes.length}", "/#{token}/"]
      end
    end

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
