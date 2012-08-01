module Wizardry
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def wizardry(*steps)
        cattr_accessor :steps, instance_writer: false

        self.steps = steps

        include WizardryMethods

        [*Wizardry::ORDINALS.first(steps.size - 1), :last].each do |method|
          class_eval <<-EOT, __FILE__, __LINE__ + 1
            def #{method}_step                # def first_step
              steps.#{method}                 #   steps.first
            end                               # end

            def #{method}_step?               # def first_step?
              current_step == #{method}_step  #   current_step == first_step
            end                               # end
          EOT
        end
      end
    end

    module WizardryMethods
      def current_step
        @current_step ||= first_step
      end

      def current_step=(step)
        @current_step = step if steps.include?(step)
      end

      def next_step
        steps[current_step_index + 1] unless last_step?
      end

      def previous_step
        steps[current_step_index - 1] unless first_step?
      end

      private

      def current_step_index
        steps.index(current_step)
      end
    end
  end
end

ActiveRecord::Base.send :include, Wizardry::Base
