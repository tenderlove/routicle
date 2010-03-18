require 'test/unit'
require 'routicle'

class TestRouticle < Test::Unit::TestCase
  def test_match
    template = Routicle::Template.new
    template.map('/foo', { :a => :b })
    router = template.compile

    assert_equal({:a => :b}, router.match('/foo'))
  end

  def test_match_with_id
    template = Routicle::Template.new
    template.map('/foo/:id/bar', { :a => :b })
    router = template.compile

    assert_equal({:a => :b}, router.match('/foo/1/bar'))
  end
end
