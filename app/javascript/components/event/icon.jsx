import React, {Component} from 'react'

class  Icon extends Component {
    render(){
        return(
            <i
                className={this.props.className}
                aria-hidden="true"
                data-toggle="tooltip"
                title={this.props.message}
            >
                <span className="sr-only">
                    {this.props.message}
                </span>
            </i>
        )
    }
}

class EventIcon extends Component {
    render(){
        const status = this.props.game.status || '';
        const audience = this.props.game.audience || '';
        return(
            <div className="pull-right">
                <Icon
                    className={this._getClasses(status)}
                    message={this._getMessage(status)}
                />
                <Icon
                    className={this._getClasses(audience)}
                    message={this._getMessage(audience)}
                />
            </div>
        )
    }

    _getClasses = (elem) => {
        if (elem === 'available') {
            return 'fa fa-calendar-check-o icon-green'
        }
        else if (elem === 'fully_booked') {
            return 'fa fa-calendar-times-o icon-red'
        }
        else if (elem === 'preferred') {
            return 'fa fa-star icon-yellow'
        }
        else if (elem === 'gold') {
            return 'fa fa-trophy icon-yellow'
        }
        else {
            return 'hidden'
        }
    }

    _getMessage = (elem) => {
        if (elem === 'available') {
            return 'Prenotabile'
        }
        else if (elem === 'fully_booked') {
            return 'Disponibilità Esaurita'
        }
        else if (elem === 'preferred') {
            return 'Solo Corieristi Semper Fidelis'
        }
        else if (elem === 'gold') {
            return 'Solo Corieristi Gold'
        }
        else {
            return ''
        }
    }
}

export default EventIcon;
