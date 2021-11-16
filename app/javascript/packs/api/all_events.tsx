import * as React from "react"
import * as ReactDOM from 'react-dom'
import { EventList } from './_event_list'

ReactDOM.render(
  <EventList url='/api/events' />,
  document.getElementById('event-list')
)
