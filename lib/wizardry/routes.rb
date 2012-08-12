class ActionDispatch::Routing::Mapper
  def has_wizardry
    unless resource_scope?
      raise ArgumentError, "can't use has_wizardry outside resource(s) scope"
    end

    options = @scope[:scope_level_resource].options

    if options.has_key?(:only)
      only = Array.wrap(options.delete(:only))
      only.map!(&:to_sym).delete(:edit)
      options.merge!(only: only) if only.present?
    end

    except = Array.wrap(options.delete(:except))
    except.map!(&:to_sym) << :edit
    options.merge!(except: except.uniq)

    res = @scope[:scope_level_resource].instance_variable_get(:@name)

    get 'edit/:step' => :edit, step: res.to_s.classify.constantize.steps_regexp, as: :edit, on: :member
  end

  [:resources, :resource].each do |method|
    class_eval <<-EOT, __FILE__, __LINE__ + 1
      def wizardry_#{method}(*res)  # def wizardry_resources(*res)
        #{method} *res do           #   resources *res do
          has_wizardry              #     has_wizardry
          yield if block_given?     #     yield if block_given?
        end                         #   end
      end                           # end
    EOT
  end
end
