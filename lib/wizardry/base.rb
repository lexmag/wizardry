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
        steps[current_step_idx + 1] unless last_step?
      end

      def previous_step
        steps[current_step_idx - 1] unless first_step?
      end

      def step_title(step = current_step)
        return if step !~ steps_regexp
        I18n.translate(step, scope: 'wizardry.steps', default: step.to_s.humanize)
      end

      private

      def current_step_idx
        steps.index(current_step)
      end
    end
  end
end

ActiveRecord::Base.send :include, Wizardry::Base
