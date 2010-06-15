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

  def test_route_to_list
    dest = [{ :a => :b }, 'cookie', 'monster']
    template = Routicle::Template.new
    template.map('/foo/:id/bar', dest)
    router = template.compile

    assert_equal(dest, router.match('/foo/1/bar'))
  end
end
