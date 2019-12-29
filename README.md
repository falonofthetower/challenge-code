# README

Clone the repository
Check your versions

* Ruby version `ruby 2.5.1p57`
* Bundler version 2.1.0
`bundle install`

and create/seed the database

* Postgresql version `psql (11.2, server 9.6.11)`

`bin/rake db:reset`
`bin/rake db:reset RAILS_ENV=test`

* How to run the test suite

bin/rspec

For the challenge I realized very rapidly that the potential for scope creep here
is very high. Based upon the conversations I had with Justin I opted for an
approach where I concentrated on building a flexible readable design for the
principle problem of matching events against incoming webhook events. Everything
else has a bit of roughness to the edges.

The webhook events are stubbed out in
[fake_redox_webhook.rb](https://github.com/falonofthetower/roundtrip-challenge/blob/master/app/services/fake_redox_webhook.rb).
The webhook processing is sort of a side note here and shouldn't be presumed to
be robust. For the purposes of this exercise let's accept that is how the events
are showing up and accept that our world doesn't involve security concerns. I
would also presume in a real world scenerio there would be multiple potential
entry points that would include data as to the source they came from. I believe
the design is flexible enough that objects could be broken off specifically for
solving that type of variance.

Once the webhooks are received the process kicks off with [EventsProcessor](https://github.com/falonofthetower/roundtrip-challenge/blob/master/app/services/events_processor.rb). That process then attempts to make some matches.
If you review the [seeds](https://github.com/falonofthetower/roundtrip-challenge/blob/master/db/seeds.rb) you may not that we have created a number of events and plans and a single match. The match is the object of our desire here.
In this case the intended correlation of plans to events is rather dull.
Techinically if that was the actual challenge we could use the single key and
match on color, but for our purposes let's just pretend we need both and not
complicate things.

`Match.count => 1`

`Event.count => 60`

`Event.successful => []`

So one token match, 60 events, and none processed successfully yet

`EventsProcessor.call` # lengthy output

`Event.successful.count => 3`

It matches every event that contains our match string of `Blue~Dark`.

Let's find the next thing to match.

`match_string = MatchMaker.new(Event.missing.first).match_string => "Blue~Light"`

Obviously Blue so:
 
`plan = Plan.find_by(name: "Blue")`

`match_string = MatchMaker.new(Event.missing.first).match_string`

`FactoryBot.create(:match, plan: plan, match_string: match_string)`

We reset the missing matches now that there is a new available match. When and
how this would happen is a deeper system question I won't strive to answer here.

`Event.missing.each {|e| e.update(match_status: 'unchecked') }`

`EventsProcessor.call`

`Event.successful.count => 6`

Rinse and repeat.

Principles behind this structure
- Preservation of the data
  I don't want to muddle the incoming data to be compromised by trying
  to validate or reject it prematurely. You send me something I want to store it
  raw and then process it.

- Make the match in SQL
  I toyed briefly with the idea of doing this in Ruby but that just doesn't
  scale. Not knowing how many matches it would need to sort through a simple
  SELECT WHERE on a string means we are leveraging the right tool for the job.
  There are even Postgresql tools we could use to fuzzy match on the
  match_string and find the closest match.
  https://www.postgresql.org/docs/9.1/fuzzystrmatch.html

Finally there is one small point I would like to push back on in the
instructions.

> as part of the core team, your primary responsibility will revolve around setting patterns the rest of the team can get behind.

I would propose that a better way to look at that is "proposing and teaching
patterns the rest of the team gets behind". The implication of "setting" is
one of command. But we are dealing with not just machines but humans. It is
paramount that the team not only follows the principles but embraces them.

To set a pattern the team doesn't understand will be implemented incorrectly. To
set a pattern the team doesn't yet accept will be implemented inefficiently with
detrimental strife. Software today is very much a team sport. When we teach the
patterns like a rowing stroke, and the team embraces it we pull together and cut
through the resistance like a knife.
