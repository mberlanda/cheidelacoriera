import { configure } from "enzyme";
import * as Adapter from "@wojtekmaj/enzyme-adapter-react-17";
configure({ adapter: new Adapter() });

import { EventIcon } from "..";

describe("EventIcon", () => {
  const STATUSES = [undefined, "available", "fully_booked"];
  const AUDIENCES = [undefined, "preferred", "gold"];

  STATUSES.forEach((status: string) => {
    AUDIENCES.forEach((audience: string) => {
      test(`when status: "${status}" and audience: "${audience}"`, () => {
        const statusProp = status ? { status: status } : {};
        const audienceProp = audience ? { audience: audience } : {};
        const eventIcon = new EventIcon({
          game: { ...statusProp, ...audienceProp },
        });

        expect(eventIcon.render()).toMatchSnapshot();
      });
    });
  });
});
