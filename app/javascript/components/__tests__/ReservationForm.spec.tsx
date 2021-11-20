import { configure } from "enzyme";
import * as Adapter from "@wojtekmaj/enzyme-adapter-react-17";
configure({ adapter: new Adapter() });

import ReservationForm from "../ReservationForm";
import { mount } from "enzyme";
import * as React from "react";

describe("ReservationForm", () => {
  const defaultFanName = {
    first_name: "Joe",
    last_name: "Doe",
  };
  const schema = {
    properties: {
      fans_count: {
        type: "integer",
      },
      fan_names: {
        type: "array",
        minItems: 1,
        maxItems: 1,
        default: 1,
      },
    },
  };

  const formData = {
    fans_count: 1,
    fan_names: [defaultFanName],
  };

  const registrationFormProps = {
    schema: schema,
    ui_schema: {},
    form_data: formData,
    url: "an-endpoint-to-mock",
    authenticity_token: "a-valid-token",
  };

  it("preserves existing fanNames on fansCount change", () => {
    const reservationForm = mount(
      <ReservationForm {...registrationFormProps} />
    );

    expect(reservationForm.state().formData.fans_count).toBe(1);
    expect(reservationForm.state().formData.fan_names).toMatchObject([
      defaultFanName,
    ]);

    const anotherFanName = {
      first_name: "Another",
      last_name: "Fan",
    };

    reservationForm.instance().onChange({
      schema: schema,
      formData: {
        fan_names: [defaultFanName, anotherFanName],
        fans_count: 3,
      },
    });

    expect(reservationForm.state().formData.fans_count).toBe(3);
    expect(reservationForm.state().formData.fan_names).toMatchObject([
      defaultFanName,
      anotherFanName,
      {},
    ]);

    reservationForm.instance().onChange({
      schema: schema,
      formData: {
        fan_names: [defaultFanName, anotherFanName, {}],
        fans_count: 1,
      },
    });
    expect(reservationForm.state().formData.fans_count).toBe(1);
    expect(reservationForm.state().formData.fan_names).toMatchObject([
      defaultFanName,
    ]);
  });
});
