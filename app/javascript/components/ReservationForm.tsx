import * as React from "react";
import Form from "react-jsonschema-form";

const log = (type) => console.log.bind(console, type);

interface ReservationFormProps {
  schema: Record<string, unknown>;
  ui_schema: Record<string, unknown>;
  form_data: Record<string, unknown>;
  url: string;
  authenticity_token: string;
}

export interface Fan {
  first_name: string;
  last_name: string;
}

class ReservationForm extends React.Component<ReservationFormProps> {
  state: {
    schema: Record<string, unknown>;
    uiSchema: Record<string, unknown>;
    formData: Record<string, unknown>;
    authenticity_token: string;
  };

  constructor(props: ReservationFormProps) {
    super(props);
    this.state = {
      schema: props.schema,
      uiSchema: props.ui_schema,
      formData: props.form_data,
      authenticity_token: props.authenticity_token,
    };
  }

  _buildHeaders = (): HeadersInit => {
    return {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-Token": this.state.authenticity_token,
      "X-Requested-With": "XMLHttpRequest",
    };
  };

  onSubmit = () => {
    if (
      confirm(
        `Vuoi confermare questa prenotazione per ${this._fansCountConfirmation()} ?`
      )
    ) {
      fetch(this.props.url, {
        method: "POST",
        credentials: "same-origin",
        headers: this._buildHeaders(),
        body: JSON.stringify({
          authenticity_token: this.state.authenticity_token,
          reservation: this.state.formData,
        }),
      }).then((resp) => {
        if (resp.ok) {
          location.reload();
        } else {
          console.log(resp);
        }
      });
    }
  };

  _fansCountConfirmation = () => {
    const fansCountFinal = this.state.formData.fans_count;
    if (fansCountFinal == 1) {
      return "una persona";
    } else {
      return fansCountFinal + " persone";
    }
  };

  onChange = (event) => {
    const newSchema = Object.assign(event.schema);
    const newFormData = Object.assign(event.formData);
    const fansCount = newFormData.fans_count;
    const fanNames = newFormData.fan_names || [];

    if (fanNames.length != fansCount) {
      newSchema.properties.fan_names.minItems = fansCount;
      newSchema.properties.fan_names.maxItems = fansCount;
      newSchema.properties.fans_count.default = fansCount;

      // This allows to preserve the previous selection when
      // updating the fansCount
      const fans = Array(fansCount).fill({});
      [...fanNames].forEach((element, index) => {
        if (index < fansCount) {
          fans[index] = element;
        }
      });

      this.setState({
        schema: newSchema,
        formData: {
          ...newFormData,
          fan_names: fans,
        },
      });
    } else {
      this.setState({
        formData: newFormData,
      });
    }
  };

  render() {
    return (
      <Form
        schema={this.state.schema}
        id="react-reservation-form"
        uiSchema={this.state.uiSchema}
        formData={this.state.formData}
        method="post"
        action={this.props.url}
        onChange={this.onChange.bind(this)}
        onSubmit={this.onSubmit.bind(this)}
        onError={log("errors")}
      >
        <p>
          <button className="btn btn-info" type="submit">
            Prenota
          </button>
        </p>
      </Form>
    );
  }
}

export default ReservationForm;
