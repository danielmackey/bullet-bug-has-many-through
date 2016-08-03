class Contact < ApplicationRecord
  belongs_to :person

  delegate :name, # person_name
    to: :person,
    prefix: true
end
