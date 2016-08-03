class Membership < ApplicationRecord

  belongs_to :person
  belongs_to :group

  has_many :contacts, through: :person

  delegate :name, to: :person

end
