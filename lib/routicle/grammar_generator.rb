require 'erb'
require 'racc'
require 'racc/grammarfileparser'

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
    : <%= sentence.first.join(' ') %> { result = <%= sentence.last.inspect %> }
  <% end %>
end
---- inner
  def initialize scanner
    @scanner = scanner
  end

  def parse str
    @scanner.scan_setup str
    do_parse
  end
  alias :match :parse

  def next_token; @scanner.next_token; end
      eoruby
      grammar = template.result binding

      if $DEBUG
        puts "############# GENERATED GRAMMAR"
        puts grammar
        puts "############# END GENERATED GRAMMAR"
      end

      grammar
    end

    ###
    # Returns a Parser class that can be instantiated
    def to_parser
      parser     = Racc::GrammarFileParser.new
      result     = parser.parse to_yacc
      nfa        = Racc::States.new(result.grammar).nfa
      parsegen   = Racc::ParserFileGenerator.new nfa.dfa, result.params
      parser_src = parsegen.generate_parser

      if $DEBUG
        puts "############# PARSED GRAMMAR"
        puts parser_src
        puts "############# END PARSED GRAMMAR"
      end

      Module.new { class_eval parser_src }.const_get('GeneratedGrammar')
    end
  end
end
