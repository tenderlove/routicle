require 'erb'

module Routicle
  class GrammarGenerator
    def initialize
      @sentences = []
    end

    ###
    # Add +sequence+ to the grammar generator.  The generated grammar will
    # return +result+ given a pattern that matches +sequence+.
    def add sequence, result
      @sentences << [sequence, result]
    end

    def to_yacc
      tokens = @sentences.map { |x| x.first }.flatten

      template = ERB.new <<-eoruby
class GeneratedGrammar
<% tokens.each do |token| %>token <%= token %>
<% end %>
rule<% @sentences.each do |sentence| %>
  url
    : <%= sentence.first.join(' ') %> { <%= sentence.last.inspect %> }
  <% end %>
end
      eoruby
      template.result binding
    end
  end
end
