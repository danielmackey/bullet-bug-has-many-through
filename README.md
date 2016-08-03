# Bullet v5.2.0 regression example

After upgrading to Bullet v5.2.0 (with a Rails 5.0.0 app) and had some regressions with some associations that I'm not really sure how to describe, so I made an app/repo to demonstrate it (jump to [setup instructions](#setup))

## Problem
It appears to be a regression between Bullet v5.1.1 and v5.2.0 ([see the diff](https://github.com/flyerhzm/bullet/compare/5.1.1...5.2.0)), as rolling back to the previous 5.1.1 version works.

Given the following models/associations
```rb
class Group < ApplicationRecord
  has_many :memberships
  has_many :people, through: :memberships
end

class Person < ApplicationRecord
  has_many :memberships
  has_many :groups, through: :memberships

  has_many :contacts
end

class Contact < ApplicationRecord
  belongs_to :person
end

class Membership < ApplicationRecord
  belongs_to :person
  belongs_to :group

  has_many :contacts, through: :person
end
```

When viewing a `@membership.contacts` in a view, the collection proxy is returned as `#<Contact::ActiveRecord_Associations_CollectionProxy:0x007ffb59702388>`, as opposed to a `#<ActiveRecord::Associations::CollectionProxy [#<Contact id: ... >]>` (as debugged via rails console). The bug this causes it the inability to run any enumerable methods like `#each` on the collection proxy.

**in view w/ byebug**
```rb
(byebug) @membership
#<Membership id: 1, person_id: 1, group_id: 1, created_at: "2016-08-03 13:37:25", updated_at: "2016-08-03 13:37:25">
(byebug) @membership.contacts
#<Contact::ActiveRecord_Associations_CollectionProxy:0x007ffb59702388>
(byebug) @membership.contacts.count
  CACHE (0.0ms)  SELECT COUNT(*) FROM "contacts" INNER JOIN "people" ON "contacts"."person_id" = "people"."id" WHERE "people"."id" = ?  [["id", 1]]
2
(byebug) @membership.contacts.to_sql
"SELECT \"contacts\".* FROM \"contacts\" INNER JOIN \"people\" ON \"contacts\".\"person_id\" = \"people\".\"id\" WHERE \"people\".\"id\" = 1"
(byebug) @membership.contacts.map(&:value)
*** NoMethodError Exception: undefined method `each' for #<Person:0x007ffb5ad58e98>

nil
```

**in** `rails console`
```rb
irb(main):001:0> @membership = Membership.find(1)
  Membership Load (0.2ms)  SELECT  "memberships".* FROM "memberships" WHERE "memberships"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
=> #<Membership id: 1, person_id: 1, group_id: 1, created_at: "2016-08-03 13:37:25", updated_at: "2016-08-03 13:37:25">
irb(main):002:0> @membership.contacts
  Contact Load (0.1ms)  SELECT "contacts".* FROM "contacts" INNER JOIN "people" ON "contacts"."person_id" = "people"."id" WHERE "people"."id" = ?  [["id", 1]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Contact id: 1, value: "john@acme.co", person_id: 1, created_at: "2016-08-03 13:37:25", updated_at: "2016-08-03 13:37:25">, #<Contact id: 2, value: "john.doe@acme.co", person_id: 1, created_at: "2016-08-03 13:37:25", updated_at: "2016-08-03 13:37:25">]>
irb(main):003:0> @membership.contacts.count
   (0.2ms)  SELECT COUNT(*) FROM "contacts" INNER JOIN "people" ON "contacts"."person_id" = "people"."id" WHERE "people"."id" = ?  [["id", 1]]
=> 2
irb(main):004:0> @membership.contacts.to_sql
=> "SELECT \"contacts\".* FROM \"contacts\" INNER JOIN \"people\" ON \"contacts\".\"person_id\" = \"people\".\"id\" WHERE \"people\".\"id\" = 1"
irb(main):005:0> @membership.contacts.map(&:value)
=> ["john@acme.co", "john.doe@acme.co"]
```

## Setup
```
git clone https://github.com/danielmackey/bullet-bug-has-many-through.git
cd bullet-bug-has-many-through
bin/setup
rails server
```

Then navigate to http://localhost:3000/groups/1 and click on the link to view John/Jane Doe [with](http://localhost:3000/groups/1/memberships/1) and [without](http://localhost:3000/groups/1/memberships/1?skip_bullet=true) Bullet enabled. When Bullet is disabled (the w/o version), the collection proxy behaves normally, but when enabled, generates an error. If you add a `byebug` to `app/views/memberships/show.html.erb:6`, you can play along in the terminal to see the behavior documented above.

