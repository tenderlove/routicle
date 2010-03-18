require 'strscan'

module Routicle
  class Scanner
    def initialize
      @ss = nil
    end

    def scan_setup str
      @ss = StringScanner.new str
    end

    def next_token
      raise NotImplementedError, 'subclass me!'
    end
  end
end
