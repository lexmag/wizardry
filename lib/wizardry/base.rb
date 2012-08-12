module Wizardry
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def wizardry(*steps)
        class_attribute :steps, :steps_regexp, instance_writer: false

        self.steps = steps.map{ |s| s.to_s.inquiry }
        self.steps_regexp = Regexp.new(steps.join('|'))

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
        step = step.to_s
        @current_step = step.inquiry if steps.include?(step)
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
