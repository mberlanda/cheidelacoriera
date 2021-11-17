import * as React from "react";
import { EventAvailabilityProgressbar, EventIcon, EventTeams } from "./event";
import { Button, Game } from "./../models";

interface EventBoxProps {
  game: Game;
}

class EventBox extends React.Component<EventBoxProps> {
  constructor(props: EventBoxProps) {
    super(props);
  }

  render() {
    return this._renderWrapper(
      <div className="panel panel-default event-panel">
        {this._renderBody(this.props.game)}
        {this._renderFooter(this.props.game?.buttons || [])}
      </div>
    );
  }

  _renderWrapper(body: JSX.Element) {
    const divStyle = {
      animationName: "none",
    };
    return (
      <div
        className="col-sm-6 col-xs-12 text-center wow fadeInLeft"
        style={divStyle}
      >
        {body}
      </div>
    );
  }

  _renderBody(game: Game) {
    return (
      <div className="panel-body">
        <EventIcon game={game} />
        <small>{game.competition}</small>
        <p>{game.date}</p>
        <EventAvailabilityProgressbar game={game} />
        <EventTeams game={game} />
      </div>
    );
  }
  _renderFooter(buttons: Button[]) {
    return (
      <div className="panel-footer event-footer">
        {buttons.map((button) => (
          <a key={button.url} href={button.url} className={button.className}>
            {button.text}
          </a>
        ))}
      </div>
    );
  }
}

export default EventBox;
