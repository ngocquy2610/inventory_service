class User < ApplicationRecord
  self.table_name = "users"

  enum :role, {
    admin: 0,
    inventory_manager: 1,
    kitchen_staff: 2,
    receptionist: 3,
    waiter: 4,
    customer: 5
  }

  def readonly?
    true
  end

  class << self
    %i[
      update_all delete_all delete destroy_all
      insert insert! insert_all insert_all! upsert upsert_all
    ].each do |name|
      define_method(name) { |*, **| raise ActiveRecord::ReadOnlyRecord, "User is read-only" }
    end
  end

  # update_column(s) và delete bỏ qua readonly? ở instance.
  def update_columns(*) = raise(ActiveRecord::ReadOnlyRecord, "User is read-only")
  def delete = raise(ActiveRecord::ReadOnlyRecord, "User is read-only")
end