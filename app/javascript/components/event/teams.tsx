import * as React from "react";
import { Game, Team, TransportMean } from "../../models";

interface EventTeamsProps {
  game: Game;
}

export class EventTeams extends React.Component<EventTeamsProps> {
  constructor(props: EventTeamsProps) {
    super(props);
  }

  render() {
    return (
      <div className="row">
        {this._formatTeam(this.props.game.teams.home)}
        {this._formatInfo(this.props.game)}
        {this._formatTeam(this.props.game.teams.away)}
      </div>
    );
  }

  _formatTeam = (team: Team) => {
    return (
      <div className="col-md-5 left event-team">
        <img alt={team.name} className="team-logo" src={team.imageUrl} />
        <p>{team.name}</p>
      </div>
    );
  };

  _formatInfo = (game: Game) => {
    const score = game.score;
    const transportMean = game.transportMean;
    const time = game.time;
    if (score) {
      return this._formatSimple(score);
    } else if (transportMean.iconClass) {
      return this._formatTransportMean(transportMean);
    } else {
      return this._formatSimple(time);
    }
  };

  _formatTransportMean = (transportMean: TransportMean) => {
    return (
      <div className="col-md-2 event-score">
        <i className={transportMean.iconClass} />
        <p>
          <small>{transportMean.name}</small>
        </p>
      </div>
    );
  };

  _formatSimple = (info: string) => {
    return <div className="col-md-2 event-score">{info}</div>;
  };
}
