import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import jQuery from 'jquery'

import EventBox from './../components/event_box'

const $ = jQuery;

class EventList extends Component {
    constructor() {
        super();
        this.games = [
            {
                id: 123,
                audience: 'preferred',
                availability: 24,
                competition: 'Europa League',
                date: '22 Febbraio 2018',
                status: 'available',
                currentUser: {
                    role: 'admin',
                    canBook: true,
                    booked: false
                }
            },
            {
                id: 234,
                audience: 'everyone',
                availability: 77,
                competition: 'Serie A',
                date: '12 Febbraio 2018',
                status: 'fully_booked',
                awayTeam: {
                    name: '',
                    logoUrl: ''
                },
                homeTeam: {
                    name: '',
                    logoUrl: ''
                },
                currentUser: null
            }
        ]
    }

    render(){
        return(
            this.games.map((evt) => <EventBox key={evt.id} game={evt} />)
        )
    }
}

$().ready(() => {
    ReactDOM.render(
        <EventList />,
        document.body.appendChild(document.createElement('div')),
    )
})
