import { configure } from "enzyme";
import * as Adapter from "@wojtekmaj/enzyme-adapter-react-17";
configure({ adapter: new Adapter() });
import { EventAvailabilityProgressbar } from "..";
import { Game } from "../../../models";

describe("EventAvailabilityProgressbar", () => {
  [
    { availability: 100 },
    { availability: 100, currentUser: { canBook: false } },
    { availability: 1, currentUser: { canBook: true } },
    { availability: 26, currentUser: { canBook: true } },
    { availability: 51, currentUser: { canBook: true } },
    { availability: 76, currentUser: { canBook: true } },
  ].forEach((game: Partial<Game>) => {
    test(`when availability: ${game.availability}, currentUser: ${
      game.currentUser && JSON.stringify(game.currentUser)
    }`, () => {
      const progressBar = new EventAvailabilityProgressbar({
        game: game,
      });
      expect(progressBar.render()).toMatchSnapshot();
    });
  });
});
