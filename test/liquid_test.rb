require File.dirname(__FILE__) + '/helper'

class LiquidTest < Test::Unit::TestCase
  def liquid_app(&block)
    mock_app {
      set :views, File.dirname(__FILE__) + '/views'
      get '/', &block
    }
    get '/'
  end

  it 'renders inline Liquid strings' do
    liquid_app { liquid '{{ 1|plus:1 }}' }
    assert ok?
    assert_equal '2', body
  end

  it 'renders .liquid files in views path' do
    liquid_app { liquid :hello }
    assert ok?
    assert_equal "Hello World\n", body
  end

  it 'takes a :locals option' do
    liquid_app {
      locals = {'foo' => 'Bar'}
      liquid '{{ foo }}', :locals => locals
    }
    assert ok?
    assert_equal 'Bar', body
  end

  it "renders with inline layouts" do
    mock_app {
      layout { 'THIS. IS. {{ content|upcase }}!' }
      get('/') { liquid 'Sparta' }
    }
    get '/'
    assert ok?
    assert_equal 'THIS. IS. SPARTA!', body
  end

  it "renders with file layouts" do
    liquid_app {
      liquid 'Hello World', :layout => :layout2
    }
    assert ok?
    assert_equal "Liquid Layout!\nHello World\n", body
  end
end
