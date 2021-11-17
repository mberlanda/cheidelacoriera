import * as React from "react";
import { EventAvailabilityProgressbar, EventIcon, EventTeams } from "./event";
import { Game } from "./../models";

interface EventBoxProps {
  game: Game;
}

class EventBox extends React.Component<EventBoxProps> {
  constructor(props: EventBoxProps) {
    super(props);
  }

  render() {
    const game = this.props.game;
    const buttons = game ? game.buttons : [];
    const divStyle = {
      // visibility: 'hidden',
      animationName: "none",
    };
    return (
      <div
        className="col-sm-6 col-xs-12 text-center wow fadeInLeft"
        style={divStyle}
      >
        <div className="panel panel-default event-panel">
          <div className="panel-body">
            <EventIcon game={game} />
            <small>{game.competition}</small>
            <p>{game.date}</p>
            <EventAvailabilityProgressbar game={game} />
            <EventTeams game={game} />
          </div>
          <div className="panel-footer event-footer">
            {buttons.map((button) => (
              <a
                key={button.url}
                href={button.url}
                className={button.className}
              >
                {button.text}
              </a>
            ))}
          </div>
        </div>
      </div>
    );
  }
}

export default EventBox;
