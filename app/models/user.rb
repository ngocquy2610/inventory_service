class User < ApplicationRecord
  enum :role, {
    admin: 0,
    inventory_manager: 1,
    kitchen_staff: 2,
    receptionist: 3,
    waiter: 4,
    customer: 5
  }
  def readonly? = true
end