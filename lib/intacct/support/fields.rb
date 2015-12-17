module Intacct
  module Support
    module Fields
      extend ActiveSupport::Concern

      delegate :read_only_fields, to: :class

      module ClassMethods

        def read_only_fields(*args)
          if args.empty?
            @read_only_fields ||= Set.new
          else
            args.each do |arg|
              read_only_field arg
            end
          end
        end

        def read_only_field(name)
          name_sym = name.to_sym
          read_only_fields << name_sym
          field name
        end


        def fields(*args)
          if args.empty?
            @fields ||= Hash.new
          else
            args.each do |arg|
              field arg
            end
          end
        end

        def field(name, options = {})
          name_sym = name.to_sym
          klass    = options[:class]

          fields[name_sym] = options
          if klass
            define_method(name_sym) do
              attributes[name_sym] ||= klass.new(client)
            end

            define_method("#{name_sym}=") do |value|
              if value.nil?
                attributes.delete(name_sym)
              else
                attributes[name_sym] = value.kind_of?(klass) ? value : klass.new(client, value)
              end
            end
          else
            define_method(name_sym) do
              attributes[name_sym]
            end

            define_method("#{name_sym}=") do |value|
              attributes[name_sym] = value
            end
          end
        end

        def inherited(klass)
          klass.instance_variable_set("@fields", self.fields)
          klass.instance_variable_set("@read_only_fields", self.read_only_fields)
        end

      end

    end
  end
end