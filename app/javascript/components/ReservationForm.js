import React from "react"
import PropTypes from "prop-types"
import Form from "react-jsonschema-form"

const log = (type) => console.log.bind(console, type);

class ReservationForm extends React.Component {
  constructor(props){
    super(props)
    this.state = {
      schema: this.props.schema,
      uiSchema: this.props.ui_schema,
      formData: this.props.form_data,
      authenticity_token: this.props.authenticity_token
    }
  }

  onSubmit(event){
    const AuthenticityToken = document.getElementsByName('csrf-token')[0].content;
    let fansCountConfirmation = this._fansCountConfirmation()
    if (confirm(
      "Vuoi confermare questa prenotazione per " +
      fansCountConfirmation + "?"
    )){
      fetch(this.props.url, {
        method: 'POST',
        credentials: 'same-origin',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.state.authenticity_token,
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: JSON.stringify({
          authenticity_token: this.state.authenticity_token,
          reservation: this.state.formData
        })
      }).then( (resp)=> {
        if (resp.ok) {
          location.reload()
        } else {
          console.log(resp)
        }
      })
    }
  }

  _fansCountConfirmation() {
    let fansCountFinal = this.state.formData.fans_count;
    if (fansCountFinal == 1) {
      return "una persona";
    } else {
      return fansCountFinal + " persone"
    }
  }

  onChange(event) {
    const newSchema = Object.assign(event.schema);
    const newFormData = Object.assign(event.formData);
    const fansCount = newFormData.fans_count;
    const fanNames = newFormData.fan_names || [];

    if ( fanNames.length != fansCount) {
    newSchema.properties.fan_names.minItems = fansCount;
    newSchema.properties.fan_names.maxItems = fansCount;
    newSchema.properties.fans_count.default = fansCount;
    /*
    let newFanNames = this._increaseFansInputs(
      this._decreaseFansInputs(fanNames, fansCount),
      fansCount
    )
    */

    let finalFormData = {
      ...newFormData, fan_names: Array(fansCount).fill({}) // newFanNames
    }

    this.setState({
      schema: newSchema,
      formData: finalFormData
      })
  } else {
    this.setState({
      formData: newFormData
    })
  }
  }

  _updateSchema(newSchema) {
    this.setState(schema: newSchema)
  }

  _increaseFansInputs(fanNames, fansCount){
    if (fanNames.length < fansCount) {
      fanNames.push({ first_name: undefined, last_name: undefined })
      return this._increaseFansInputs(fanNames, fansCount)
    } else {
      return fanNames
    }
  }

  _decreaseFansInputs(fanNames, fansCount){
    if (fanNames.length > fansCount) {
      fanNames.pop()
      return this._decreaseFansInputs(fanNames, fansCount)
    } else {
      return fanNames
    }
  }

  render () {
    return (
     <Form schema={this.state.schema}
      id="react-reservation-form"
       uiSchema={this.state.uiSchema}
      formData={this.state.formData}
      method="post"
      action={this.props.url}
      onChange={this.onChange.bind(this)}
      onSubmit={this.onSubmit.bind(this)}
      onError={log("errors")} >
      <p>
        <button className= "btn btn-info" type="submit">Prenota</button>
      </p>
      </Form>
    );
  }
}

ReservationForm.propTypes = {
  schema: PropTypes.object,
  ui_schema: PropTypes.object,
  form_data: PropTypes.object,
  url: PropTypes.string,
};
export default ReservationForm
