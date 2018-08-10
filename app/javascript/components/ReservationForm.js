import React from "react"
import PropTypes from "prop-types"
import Form from "react-jsonschema-form"

const formData = {};

const log = (type) => console.log.bind(console, type);

class ReservationForm extends React.Component {
  constructor(props){
  	super(props)
  	this.state = {
  	  schema: this.props.schema,
  	  uiSchema: this.props.ui_schema,
  	  formData
  	}
  }

  onSubmit(event){
  	confirm(
    	"Vuoi confermare questa prenotazione? " +
    	JSON.stringify(this.state.formData, null, 2)
    );
  }

  onChange(event) {
  	const newSchema = event.schema;
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
			...newFormData, fan_names: Array(fansCount).fill({})
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
     	uiSchema={this.state.uiSchema}
		  formData={this.state.formData}
      onChange={this.onChange.bind(this)}
      onSubmit={this.onSubmit.bind(this)}
      onError={log("errors")} />
    );
  }
}

ReservationForm.propTypes = {
	schema: PropTypes.object,
	ui_schema: PropTypes.object
};
export default ReservationForm
