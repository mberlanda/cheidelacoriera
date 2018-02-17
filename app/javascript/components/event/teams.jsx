import React, {Component} from 'react'

class EventTeams extends Component {
  constructor(){
    super()
  }

  render(){
    const game = this.props.game;
    const teams =game.teams;

    return(
      <div className="row">
        {this._formatTeam(teams.home)}
        {this._formatInfo(game)}
        {this._formatTeam(teams.away)}
      </div>
    )
  }

  _formatTeam = (team) => {
    return(
      <div className="col-md-5 left event-team">
          <img alt={team.name} className="team-logo" src={team.imageUrl} />
          <p>{team.name}</p>
      </div>
    )
  }

  _formatInfo = (game) => {
    const score = game.score;
    const transportMean = game.transportMean;
    const time = game.time;
    if (score) {
      return(this._formatSimple(score))
    } else if (transportMean.iconClass) {
      return (this._formatTransportMean(transportMean))
    } else {
      return (this._formatSimple(time))
    }
  }

  _formatTransportMean = (transportMean) => {
    return(
      <div className="col-md-2 event-score">
        <i className={transportMean.iconClass} />
        <p>
          <small>{transportMean.name}</small>
        </p>
      </div>
    )
  }

  _formatSimple = (info) => {
    return (
      <div className="col-md-2 event-score">
        {info}
      </div>
    )
  }
}

export default EventTeams;