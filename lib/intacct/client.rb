module Intacct
  class Client
    attr_accessor :xml_sender_id, :xml_password, :user_id, :password, :company_id
    attr_accessor :credentials

    def initialize(options = {})
      @credentials = {
        xml_sender_id: options.fetch(:xml_sender_id, Intacct.xml_sender_id),
        xml_password:  options.fetch(:xml_password, Intacct.xml_password),
        user_id:       options.fetch(:user_id, Intacct.app_user_id),
        password:      options.fetch(:password, Intacct.app_password),
        company_id:    options.fetch(:company_id, Intacct.app_company_id)
      }

      raise ArgumentError, 'Missing credential value.' if credentials.values.any?(&:nil?)
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s.in? models
        Intacct::BaseFactory.new(self, method_name)
      else
        super method_name
      end
    end

    def respond_to?(method_name)
      if method_name.to_s.in? models
        true
      else
        super method_name
      end
    end

    def models
      %w(bills customers invoices projects vendors)
    end
  end
end