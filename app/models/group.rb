class Group < ApplicationRecord

  has_many :memberships
  has_many :people, through: :memberships

  has_many :group_contacts, through: :people, source: :contacts

end
