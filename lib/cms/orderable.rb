module CMS::Orderable
  extend ActiveSupport::Concern

  def order_scope
    self.class
  end

  module ClassMethods
    def orderable name
      default_scope order(name)
      after_save :"order_#{name}"

      define_method :"order_#{name}" do
        order_scope.where("#{name} >= #{send(name)}").where("id != #{id}").select(:id).select(name).inject(send(name)) do |i, record|
          record.update_column name, (i += 1) ; i
        end

        order_scope.all.inject(1) do |i, record|
          record.update_column name, i ; i + 1
        end
      end
    end
  end
end
