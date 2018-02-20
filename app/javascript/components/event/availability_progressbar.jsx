import React, { Component } from 'react'

class EventAvailabilityProgressbar extends Component {
    constructor(props){
        super(props);
        let availability = this.props.game.availability;
        this.state = {
            availability: availability,
            occupancy: 100 - availability
        }
    }

    render(){
        const game = this.props.game;
        return (
            <div className="progress event-progress">
                {this._getVisibleBar(game)}
            </div>
        )
    }

    _getVisibleBar = (game) => {
        if (game.currentUser.canBook) {
            let divStyle = {
                width: this.state.occupancy + '%'
            }
        return(
          <div
            className={this._getBarClass()}
            role="progressbar"
            aria-valuenow="0"
            aria-valuemin="0"
            aria-valuemax="100"
            style={divStyle}
        >
            <span className="sr-only">
                {this.state.occupancy + '%'}
            </span>
          </div>
        )
      }
    }

    _getBarClass = () => {
        const occ = this.state.occupancy
        if (occ <= 25) {
            return 'progress-bar progress-bar-success'
        }
        else if (occ <= 50) {
            return 'progress-bar progress-bar-info'
        }
        else if (occ <= 75) {
            return 'progress-bar progress-bar-warning'
        }
        else {
            return 'progress-bar progress-bar-danger'
        }
    }
}

export default EventAvailabilityProgressbar