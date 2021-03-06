module Routicle
class Template::Scanner

macro
  string    \w+
  id        :id
  format    :format

rule

# [:state]  pattern  [actions]

            {string}  { [@string_syms[text], "/#{text.sub(/\//, '\/')}/"] }
            \/        { [:SLASH, '/\//'] }
            {id}      { [:ID, '/\d+/'] }
            {format}  { [:FORMAT, '/\w+/'] }
            \.        { [:DOT, '/\./'] }

inner

  def initialize
    super
    @string_syms = Hash.new do |h,k|
      h[k] = :"STRING#{h.length + 1}"
    end
  end

  def parse string
    scan_setup string

    list = []
    while tok = next_token; list << tok; end
    list
  end

end
end
