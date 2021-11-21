import { configure } from "enzyme";
import * as Adapter from "@wojtekmaj/enzyme-adapter-react-17";
configure({ adapter: new Adapter() });

import ReservationForm from "../ReservationForm";
import { Fan } from "../ReservationForm";
import { shallow } from "enzyme";
import * as React from "react";

describe("ReservationForm", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  const defaultFanName: Fan = {
    first_name: "Joe",
    last_name: "Doe",
  };
  const schema = {
    properties: {
      fans_count: {
        type: "integer",
        default: 1,
      },
      fan_names: {
        type: "array",
        minItems: 1,
        maxItems: 1,
        default: [defaultFanName],
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

  const applyFormChange = (reservationForm, formData) => {
    reservationForm.instance().onChange({
      schema: reservationForm.state().schema,
      formData: {
        ...reservationForm.state().formData,
        ...formData,
      },
    });
  };

  describe("onChange", () => {
    const fansAssertions = (
      state: Record<string, any>,
      count: number,
      names: Partial<Fan>[]
    ) => {
      expect(state.formData.fans_count).toBe(count);
      expect(state.formData.fan_names).toMatchObject(names);
      expect(state.schema.properties.fan_names.minItems).toBe(count);
      expect(state.schema.properties.fan_names.maxItems).toBe(count);
      expect(state.schema.properties.fans_count.default).toBe(count);
    };

    it("preserves existing fanNames on fansCount change", () => {
      const reservationForm = shallow(
        <ReservationForm {...registrationFormProps} />
      );

      // Initial state
      fansAssertions(reservationForm.state(), 1, [defaultFanName]);

      const anotherFanName = {
        first_name: "Another",
        last_name: "Fan",
      };
      // Increase the number of participants
      applyFormChange(reservationForm, {
        fan_names: [defaultFanName, anotherFanName],
        fans_count: 3,
      });
      fansAssertions(reservationForm.state(), 3, [
        defaultFanName,
        anotherFanName,
        {},
      ]);

      // Decrease the number of participants
      applyFormChange(reservationForm, {
        fans_count: 1,
      });
      fansAssertions(reservationForm.state(), 1, [defaultFanName]);

      // Update phone number
      const phoneNumber = "1234567";
      applyFormChange(reservationForm, {
        phone_number: phoneNumber,
      });
      fansAssertions(reservationForm.state(), 1, [defaultFanName]);
      expect(reservationForm.state().formData.phone_number).toBe(phoneNumber);

      // Update wihout fanNames
      applyFormChange(reservationForm, {
        fan_names: undefined,
      });
      fansAssertions(reservationForm.state(), 1, [{}]);
    });
  });

  describe("onSubmit", () => {
    /*
      Mocking the original window.location using jsdom and jest is not
      trivial.
      Window location needs to be redefined since jsdom raises
      Not implemented: navigation (except hash changes)
  
      https://remarkablemark.org/blog/2018/11/17/mock-window-location/
      https://github.com/jsdom/jsdom/issues/2112
    */
    const { location } = global;
    const mockLocationReload = jest.fn();

    beforeAll(() => {
      delete global.location;

      global.location = {
        ...location,
        reload: mockLocationReload,
      };
    });

    afterAll(() => {
      global.location = location;
    });

    const testSubmitWithoutConfirmation = (reservationForm) => {
      const mockConfirm = jest.fn(() => {
        return false;
      });
      const mockFetch = jest.fn();
      global.confirm = mockConfirm;
      global.fetch = mockFetch;

      reservationForm.instance().onSubmit();

      expect(mockConfirm).toHaveBeenCalled();
      expect(mockFetch).not.toHaveBeenCalled();
    };

    it("does not submit without confirmation with 1 fan", () => {
      const reservationForm = shallow(
        <ReservationForm {...registrationFormProps} />
      );

      testSubmitWithoutConfirmation(reservationForm);
    });

    it("does not submit without confirmation with multiple fans", () => {
      const reservationForm = shallow(
        <ReservationForm {...registrationFormProps} />
      );
      applyFormChange(reservationForm, {
        fan_names: [defaultFanName, defaultFanName],
        fans_count: 2,
      });
      testSubmitWithoutConfirmation(reservationForm);
    });

    const testSubmitWithConfirmation = (ok: boolean, status: number) => {
      const mockConfirm = jest.fn(() => {
        return true;
      });
      const mockFetch = jest.fn(() => {
        return Promise.resolve({ ok: ok, status: status });
      });

      global.confirm = mockConfirm;
      global.fetch = mockFetch as jest.Mock;

      const reservationForm = shallow(
        <ReservationForm {...registrationFormProps} />
      );

      reservationForm.instance().onSubmit();
      expect(mockConfirm).toHaveBeenCalled();
      expect(mockFetch).toHaveBeenCalled();
    };
    it("submits after confirmation and reloads on success", () => {
      testSubmitWithConfirmation(true, 200);
    });
    it("submits after confirmation and update the state on error", () => {
      testSubmitWithConfirmation(false, 403);
    });
  });
});
