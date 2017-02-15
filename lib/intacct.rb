$: << File.expand_path(File.dirname(__FILE__))

require 'intacct/version'
require 'net/http'
require 'nokogiri'
require 'hooks'
require 'active_support/all'
require 'intacct/init'

require 'intacct/actions'
require 'intacct/base'
require 'intacct/base_factory'
require 'intacct/client'
require 'intacct/callbacks'
require 'intacct/errors'
require 'intacct/query_result'
require 'intacct/response'
require 'intacct/xml_request'
require 'intacct/utils'

require 'intacct/models/bill'
require 'intacct/models/class_dimension'
require 'intacct/models/customer'
require 'intacct/models/department'
require 'intacct/models/employee'
require 'intacct/models/expense'
require 'intacct/models/expense_type'
require 'intacct/models/gl_detail'
require 'intacct/models/invoice'
require 'intacct/models/item'
require 'intacct/models/location'
require 'intacct/models/project'
require 'intacct/models/project_resource'
require 'intacct/models/project_status'
require 'intacct/models/project_type'
require 'intacct/models/sales_document'
require 'intacct/models/so_transaction_definition'
require 'intacct/models/task'
require 'intacct/models/task_resource'
require 'intacct/models/timesheet'
require 'intacct/models/timesheet_entry'
require 'intacct/models/vendor'


class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end
end

module Intacct
  extend self

  attr_accessor :xml_sender_id  , :xml_password    ,
                :user_id        , :company_id      , :password ,
                :invoice_prefix , :bill_prefix     ,
                :vendor_prefix  , :customer_prefix ,
                :project_prefix , :task_prefix

  def configure
    yield self
  end
end
