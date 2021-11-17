import * as React from "react";
import * as $ from "jquery";
import "bootstrap";
import EventBox from "../../components/event_box";
import { Game } from "../../models";

declare global {
  interface JQuery {
    tooltip(arg: any): JQuery;
  }
}

interface EventListProps {
  url: string;
}

export class EventList extends React.Component<EventListProps> {
  state: {
    games: Game[];
    url: string;
  };

  constructor(props: EventListProps) {
    super(props);
    this.state = {
      url: this.props.url,
      games: [],
    };
    this._fetchEvents(this.state.url);
  }

  render() {
    return this.state.games.map((evt) => <EventBox key={evt.id} game={evt} />);
  }

  componentDidMount() {
    // using window.$ may preserve the plugin registered
    $('[data-toggle="tooltip"]').tooltip("show");
  }

  _fetchEvents = (eventsUrl: string) => {
    $.get({
      method: "GET",
      url: eventsUrl,
      dataType: "json",
      success: (games: Game[]) => {
        this.setState({ games });
      },
    });
  };
}
