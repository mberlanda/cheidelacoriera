# frozen_string_literal: true

def show_button_for_user(event)
  if current_user && event.booked_by?(current_user.id)
    {
      className: 'btn btn-default',
      text: t('events.buttons.booked')
    }
  elsif current_user&.can_book?(event)
    {
      text: t('events.buttons.book_now')
    }
  else
    {
      text: t('events.buttons.show')
    }
  end
end

def admin_button_for_user(event)
  {
    className: 'btn btn-default',
    text: t('events.buttons.fans_list'),
    url: seo_url(reservations_event_path(event.slug))
  }
end

def buttons_for(event)
  [].tap do |ary|
    ary << {
      className: 'btn btn-primary',
      url: seo_url(details_event_path(event.slug))
    }.merge(show_button_for_user(event))
    ary << admin_button_for_user(event) if event.book_range? && current_user&.admin?
  end
end

def booking_status(event)
  return 'available' if event.bookable?
  return 'fully_booked' if event.bookable_period?
end

json.array! @events.each do |event|
  json.id event.id
  json.audience event.audience
  json.availability event.percentage_availability
  json.buttons buttons_for(event)
  json.competition event.competition.name
  json.currentUser do
    json.role current_user&.role
    json.canBook current_user&.can_book?(event)
    json.canSeeAvailabilty current_user&.can_see_availability? || false
    json.booked current_user && event.booked_by?(current_user.id)
  end
  json.date I18n.l(event.date, format: :long)
  json.status booking_status(event)
  json.teams do
    json.home do
      json.name event.home_team.name
      json.imageUrl event.home_team.image_url
    end
    json.away do
      json.name event.away_team.name
      json.imageUrl event.away_team.image_url
    end
  end
  json.transportMean do
    json.name event.transport_mean
    json.iconClass Event.transport_mean_class(event.transport_mean)
  end
  json.score event.score
  json.time event.time&.strftime('%H:%M')
end
