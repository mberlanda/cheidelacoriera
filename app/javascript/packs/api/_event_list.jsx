import React, {Component} from 'react'
import ReactDOM from 'react-dom'

import EventBox from './../../components/event_box'

class EventList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      url: this.props.url,
      games: []
    };
    this._fetchEvents(this.state.url);
  }

  render(){
    return(
      this.state.games.map((evt) =>
        <EventBox key={evt.id} game={evt} />
      )
    )
  }

  componentDidMount(){
    jQuery('[data-toggle="tooltip"]').tooltip('show');
  }

  _fetchEvents = (eventsUrl) => {
    jQuery.ajax({
      method: 'GET',
      url: eventsUrl,
      format: 'json',
      success: (games) => {
        this.setState({ games });
      }
    });
  }
}

export default EventList
