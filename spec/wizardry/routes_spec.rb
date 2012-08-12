require 'spec_helper'

describe 'Wizardry Routing' do
  it 'must accept wizardry `edit` routes' do
    assert_recognizes({ controller: 'products', action: 'edit', id: '1', step: 'initial'}, '/products/1/edit/initial')
    assert_recognizes({ controller: 'products', action: 'edit', id: '1', step: 'middle'}, '/products/1/edit/middle')
    assert_recognizes({ controller: 'products', action: 'edit', id: '1', step: 'final'}, '/products/1/edit/final')
    assert '/products/1/initial', edit_product_path(id: 1, step: 'initial')
  end

  it 'must accept only valid steps' do
    assert_raises ActionController::RoutingError do
      assert_recognizes({ controller: 'products', action: 'edit', id: '1', step: 'fictional'}, '/products/1/edit/fictional')
    end
  end

  it 'must not accept default `edit` route' do
    assert_raises ActionController::RoutingError do
      assert_recognizes({ controller: 'products', action: 'edit', id: '1'}, '/products/1/edit')
    end
  end

  it 'must not accept `destroy` route' do
    assert_raises ActionController::RoutingError do
      assert_recognizes({ controller: 'products', action: 'destroy', id: '1'}, { path: '/products/1', method: :delete })
    end
  end

  it 'must accept routes defined in block' do
    assert_recognizes({ controller: 'products', action: 'commit' }, '/products/commit')
    assert '/products/commit', commit_products_path
  end

  it 'must have overriden `new` path name' do
    assert_recognizes({ controller: 'products', action: 'new' }, '/products/make')
    assert '/products/make', new_product_path
  end

  it 'must have `wizardry_resources` helper' do
    with_routing do |set|
      set.draw{ wizardry_resources :products }

      assert_recognizes({ controller: 'products', action: 'edit', id: '1', step: 'initial'}, '/products/1/edit/initial')
    end
  end

  it 'must have `wizardry_resource` helper' do
    with_routing do |set|
      set.draw{ wizardry_resource :products }

      assert_recognizes({ controller: 'products', action: 'edit', step: 'initial'}, '/products/edit/initial')
    end
  end

  it 'must not let to use `has_wizardry` outside resource(s) scope' do
    with_routing do |set|
      assert_raises ArgumentError do
        set.draw{ has_wizardry }
      end
    end
  end

  it 'must not accept default `edit` route with `only` option' do
    with_routing do |set|
      set.draw{ wizardry_resources :products, only: [:edit, :update] }

      assert_raises ActionController::RoutingError do
        assert_recognizes({ controller: 'products', action: 'edit', id: '1'}, '/products/1/edit')
      end
    end
  end
end
