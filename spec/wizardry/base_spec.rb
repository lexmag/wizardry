require 'spec_helper'

describe Wizardry::Base do
  describe 'class methods' do
    it 'must support `wizardry` method' do
      assert_respond_to Product, :wizardry
    end

    it 'must have steps array' do
      assert_equal Product.steps, [:initial, :middle, :final]
    end
  end

  describe 'instance methods' do
    before :each do
      @product = Product.new
    end

    it 'must return current step as first step' do
      assert_equal @product.current_step, :initial
    end

    it 'must set current step name' do
      @product.current_step = :middle
      assert_equal @product.current_step, :middle
    end

    it 'must have ordinal methods' do
      assert_equal @product.first_step,  :initial
      assert_equal @product.second_step, :middle
      assert_equal @product.last_step,   :final

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
      assert_equal @product.next_step, :middle
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
      assert_equal @product.previous_step, :initial
    end
  end
end
