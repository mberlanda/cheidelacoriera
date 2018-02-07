import React, {Component} from 'react'
import EventIcon from './event/icon'
import EventAvailabilityProgressbar from './event/availability_progressbar'

class EventBox extends Component {
    render(){
        const game = this.props.game;
        let divStyle = {
            visibility: 'hidden',
            animationName: 'none'
        }
        return(
            <div className="col-sm-6 col-xs-12 text-center wow fadeInLeft" style={divStyle}>
                <div className="panel panel-default event-panel">
                    <div className="panel-body">
                        <EventIcon game={game} />
                        <small>{game.competition}</small>
                        <p>{game.date}</p>
                        <EventAvailabilityProgressbar game={game} />
                    </div>
                </div>
            </div>
        )
    }
}

export default EventBox