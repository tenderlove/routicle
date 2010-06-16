require 'test/unit'
require 'routicle'

class TestScanner < Test::Unit::TestCase
  def setup
    @gen = Routicle::ScannerGenerator.new
  end

  def test_tokenize_format
    @gen << '/foo.:format'
    scanner = @gen.compile
    tokens = tokenize(scanner, '/foo.xml')
    assert_equal [
      :SLASH,
      :STRING1,
      :DOT,
      :FORMAT
    ], tokens.map { |x| x.first }
  end

  def test_tokenize
    @gen << '/'
    scanner = @gen.compile

    tokens = tokenize(scanner, '/')
    assert_equal([[:SLASH, '/']], tokens)
  end

  def test_tokenize_slash_id
    @gen << '/:id'
    scanner = @gen.compile

    tokens = tokenize(scanner, '/10')
    assert_equal([[:SLASH, '/'], [:ID, '10']], tokens)
  end

  def test_tokenize_user_input
    @gen << '/foo/bar/:id'
    scanner = @gen.compile

    tokens = tokenize(scanner, '/foo/bar/10')
    assert_equal([
      [:SLASH, '/'],
      [:STRING1, 'foo'],
      [:SLASH, '/'],
      [:STRING2, 'bar'],
      [:SLASH, '/'],
      [:ID, '10']
    ], tokens)
  end

  def tokenize scanner, string
    list = []
    scanner.scan_setup(string)
    while tok = scanner.next_token
      list << tok
    end
    list
  end
end
