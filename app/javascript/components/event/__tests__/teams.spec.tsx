import { configure } from "enzyme";
import * as Adapter from "@wojtekmaj/enzyme-adapter-react-17";
configure({ adapter: new Adapter() });

import { EventTeams } from "../teams";
import { shallow } from "enzyme";
import * as React from "react";

describe("EventTeams", () => {
  const teams = {
    away: {
      imageUrl: "http://link-to-team-1",
      name: "Team 1",
    },
    home: {
      imageUrl: "http://link-to-team-2",
      name: "Team 2",
    },
  };
  const busTransportMean = {
    iconClass: "fa fa-bus",
    name: "bus",
  };

  const time = "2021-11-20";

  ["1-1", undefined].forEach((score) => {
    [busTransportMean, undefined].forEach((transportMean) => {
      test(`when score=${score}, transportMean=${JSON.stringify(
        transportMean
      )} and time=${time} `, () => {
        const game = {
          time: time,
          score: score,
          teams: teams,
          transportMean: transportMean,
        };
        const eventTeam = shallow(<EventTeams game={game} />);
        expect(eventTeam.instance().render()).toMatchSnapshot();
      });
    });
  });
});
