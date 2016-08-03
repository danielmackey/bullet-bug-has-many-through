class Person < ApplicationRecord

  has_many :contacts

  has_many :memberships
  has_many :groups, through: :memberships

end
