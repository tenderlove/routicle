require 'test/unit'
require 'routicle'

module Routicle
  class Template
    class TestScanner < Test::Unit::TestCase
      def setup
        @scanner = Scanner.new
      end

      def test_scanroute
        seq = @scanner.parse 'foo/bar'
        assert_equal([:STRING1, :SLASH, :STRING2], seq.map { |x| x.first })
      end

      def test_scan_route_repeat
        seq = @scanner.parse 'foo/foo'
        assert_equal([:STRING1, :SLASH, :STRING1], seq.map { |x| x.first })
      end

      def test_scan_reuses_tokens
        seq = @scanner.parse 'foo/bar'
        assert_equal([:STRING1, :SLASH, :STRING2], seq.map { |x| x.first })

        seq = @scanner.parse 'bar/foo'
        assert_equal([:STRING2, :SLASH, :STRING1], seq.map { |x| x.first })
      end

      def test_scan_dot
        seq = @scanner.parse 'foo.bar'
        assert_equal([:STRING1, :DOT, :STRING2], seq.map { |x| x.first })
      end

      def test_scan_format
        seq = @scanner.parse 'foo.:format'
        assert_equal([:STRING1, :DOT, :FORMAT], seq.map { |x| x.first })
      end
    end
  end
end
