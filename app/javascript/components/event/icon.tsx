import * as React from "react";
import { Game } from "../../models";

interface IconProps {
  className: string;
  message: string;
}

class Icon extends React.Component<IconProps> {
  constructor(props: IconProps) {
    super(props);
  }
  render() {
    return (
      <i
        className={this.props.className}
        aria-hidden="true"
        data-toggle="tooltip"
        title={this.props.message}
      >
        <span className="sr-only">{this.props.message}</span>
      </i>
    );
  }
}

interface EventIconProps {
  game: Game;
}

enum IconTypes {
  available = "available",
  fully_booked = "fully_booked",
  preferred = "preferred",
  gold = "gold",
}

const EventIconClasses: { [key in IconTypes]: string } = {
  available: "fa fa-calendar-check-o icon-green",
  fully_booked: "fa fa-calendar-times-o icon-red",
  preferred: "fa fa-star icon-yellow",
  gold: "fa fa-trophy icon-yellow",
};

const EventIconMessages: { [key in IconTypes]: string } = {
  available: "Prenotabile",
  fully_booked: "Disponibilità Esaurita",
  preferred: "Solo Corieristi Semper Fidelis",
  gold: "Solo Corieristi Gold",
};

export class EventIcon extends React.Component<EventIconProps> {
  constructor(props: EventIconProps) {
    super(props);
  }

  render() {
    const status = this.props.game.status || "";
    const audience = this.props.game.audience || "";
    return (
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
    );
  }

  _getClasses = (elem: string) => {
    return EventIconClasses[elem] || "hidden";
  };

  _getMessage = (elem: string) => {
    return EventIconMessages[elem] || "";
  };
}
