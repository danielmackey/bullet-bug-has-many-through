class Group < ApplicationRecord

  has_many :memberships
  has_many :people, through: :memberships

  has_many :contacts, through: :people

end
