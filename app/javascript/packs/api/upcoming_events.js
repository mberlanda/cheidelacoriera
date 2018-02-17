import React from 'react'
import ReactDOM from 'react-dom'
import EventList from './_event_list'

ReactDOM.render(
  <EventList url='/api/events/upcoming'/>,
  document.getElementById('event-list')
)
