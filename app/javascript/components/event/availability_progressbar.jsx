import React, { Component } from 'react'

class EventAvailabilityProgressbar extends Component {
    constructor(){
        super();
    }

    render(){
        const availability = this.props.game.availability;
        const occupancy = 100 - availability;
        let divStyle = {
            width: occupancy + '%'
        }
        return (
            <div className="progress event-progress">
                <div
                    className={this._getBarClass(occupancy)}
                    role="progressbar"
                    aria-valuenow="0"
                    aria-valuemin="0"
                    aria-valuemax="100"
                    style={divStyle}
                >
                    <span className="sr-only">
                        {occupancy + '%'}
                    </span>
                </div>
            </div>
        )
    }

    _getBarClass = (occ) => {
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