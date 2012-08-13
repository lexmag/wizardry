# Wizardry

Simple step-by-step wizard for Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wizardry'
```

And run the `bundle` command to install it.

## Usage

Bring wizardry to your model:

```ruby
class Product < ActiveRecord::Base
  wizardry :initial, :middle, :final
end
```

And you will get a bunch of methods.
To get name of the current step:

```ruby
@product.current_step # => 'initial'
```

To change the current step name:

```ruby
@product.current_step = :middle
```

Will be set only if new step name is included in wizardry steps (**initial**, **middle**, **final** in our example).

For the second step name:

```ruby
@product.second_step # => 'middle'
```

Also `first_step`, `third_step`, etc. methods are available.

You can check position of the current step:

```ruby
@product.second_step? # => true
# or
@product.current_step.middle? # => true
```

Also `first_step?`, `third_step?`, etc. methods are accessible.

To get name of the next and previous steps:

```ruby
@product.next_step
# and
@product.previous_step
```

If not exists next/previous step then `nil` will be returned.

Class methods are accessible:

```ruby
Product.steps # => ['initial', 'middle', 'final']
# and
Product.steps_regexp # => /initial|middle|final/
```

### Routing helpers

Wizardry includes some routing helpers:

```ruby
resources :products do
  has_wizardry
end
# same as
wizardry_resources :products
```

will replace default *:id/edit* path with *:id/edit/:step* (and `:step => /initial|middle|final/` in our example).
`has_wizardry` is also acceptable for singular resources. And `wizardry_resource` herper is here for that.
