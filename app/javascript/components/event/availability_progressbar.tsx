import * as React from 'react'
import { Game } from "../../models"

interface ProgressbarProps {
    game: Game;
}

// TODO: this can be refactored
interface ProgressbarState {
    availability: number;
    occupancy: number;
}

export class EventAvailabilityProgressbar extends React.Component<ProgressbarProps> {
    state: ProgressbarState;
    
    constructor(props: ProgressbarProps){
        super(props);
        let availability = this.props.game.availability;
        this.state = {
            availability: availability,
            occupancy: 100 - availability
        }
    }

    render(){
        return (
            <div className="progress event-progress">
                {this._getVisibleBar(this.props.game)}
            </div>
        )
    }

    _getVisibleBar = (game: Game) => {
        if (game.currentUser?.canBook) {
            let divStyle = {
                width: `${this.state.occupancy}%`
            }
        return(
          <div
            className={this._getBarClass()}
            role="progressbar"
            aria-valuenow={0}
            aria-valuemin={0}
            aria-valuemax={100}
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
