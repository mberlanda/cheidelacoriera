# cheidelacoriera

This Rails application aims to become a management system for away fans.

It should include two levels of users:
- administrators: can create new events, set the amount of seats/tickets, export list of participants for every event
- fans: can register for a match

In terms of models, it should include:
- users: credentials and permissions scope
  - fans: people associated to a user account (first_name, last_name, date_of_birth, place_of_birth, fidelity_card_no)
- teams: name, country, url, image_url
- competitions (e.g. championship, national cup, European cup ...)
  - events: date_time, competition, season, home_team, away_team, score, notes
- transport_means
- travels : event, transport_mean
  - travel_seats: total, requested, reserved, available
  - fan_travels: travel, fan, status
