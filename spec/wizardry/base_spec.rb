require 'spec_helper'

describe Wizardry::Base do
  describe 'class methods' do
    it 'must support `wizardry` method' do
      assert_respond_to Product, :wizardry
    end

    it 'must have steps array' do
      assert_equal Product.steps, %w[initial middle final]
    end

    it 'must have steps regexp' do
      assert_equal Product.steps_regexp, /initial|middle|final/
    end

    it 'must be instance of StringInquirer class in steps array' do
      assert_equal Product.steps.map{ |s| s.instance_of?(ActiveSupport::StringInquirer) }, [true, true, true]
    end
  end

  describe 'instance methods' do
    before do
      @product = Product.new
    end

    it 'must return current step as first step' do
      assert_equal @product.current_step, 'initial'
    end

    it 'must update current step name with instance of StringInquirer' do
      @product.current_step = 'middle'
      assert_equal @product.current_step, 'middle'
      assert_instance_of ActiveSupport::StringInquirer, @product.current_step
    end

    it 'must update current step name when symbol is passed' do
      @product.current_step = :middle
      assert_equal @product.current_step, 'middle'
    end

    it 'must not update current step name' do
      @product.current_step = :fictional
      refute_equal @product.current_step, 'fictional'
    end

    it 'must have ordinal methods' do
      assert_equal @product.first_step,  'initial'
      assert_equal @product.second_step, 'middle'
      assert_equal @product.last_step,   'final'

      assert @product.first_step?
      refute @product.second_step?
      @product.current_step = :middle
      refute @product.first_step?
      assert @product.second_step?

      assert_respond_to @product, :last_step?
      refute_respond_to @product, :third_step
      refute_respond_to @product, :third_step?
    end

    it 'must return next step name' do
      assert_equal @product.next_step, 'middle'
    end

    it 'must return `nil` on last step' do
      @product.current_step = :final
      assert_nil @product.next_step
    end

    it 'must return `nil` on first step' do
      assert_nil @product.previous_step
    end

    it 'must return previous step name' do
      @product.current_step = :middle
      assert_equal @product.previous_step, 'initial'
    end

    it 'must return translated name of step' do
      assert_equal @product.step_title(:middle), 'Upload images'
    end

    it 'must return translated name of current step if no step passed' do
      assert_equal @product.step_title, 'Product details'
      @product.current_step = :middle
      assert_equal @product.step_title, 'Upload images'
    end

    it 'must fall back to default name of step' do
      assert_equal @product.step_title(:final), 'Final'
      assert_equal @product.step_title('final'), 'Final'
    end

    it 'must return `nil` for nonexistent step name' do
      assert_nil @product.step_title(:fictional)
    end
  end
end
