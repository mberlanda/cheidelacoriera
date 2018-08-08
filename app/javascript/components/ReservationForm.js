import React from "react"
import PropTypes from "prop-types"
import Form from "react-jsonschema-form"

const schema = {
  title: "Prenota la trasferta",
  type: "object",
  required: ["phone_number", "fan_names"],
  properties: {
    phone_number: {type: "string", title: "Numero di telefono", minLength: 7},
    fans_count: {
    	type: "integer",
    	title: "Numero di Partecipanti",
    	minimum: 1,
    	maximum: 10,
    	default: 1
    },
    fan_names: {
      type: "array",
      title: "Elenco Partecipanti",
      items: {
      	type: "object",
      	required: ["first_name", "last_name"],
      	properties: {
          first_name: {
            type: "string",
            title: "Nome",
            minLength: 3
          },
          last_name: {
            type: "string",
            title: "Cognome",
            minLength: 3
          },
      	}
      },
      minItems: 1,
      maxItems: 10,
      uniqueItems: true
    },
    notes: { type: "string", title: "Note" }
  }
};

const uiSchema = {
  "fans_count":{
    "ui:widget": "range"
  },
  "fan_names": {
  	"ui:options": {
      "addable": false,
      "orderable": false,
      "removable": false,
      "inline": true
    }
  },
  "notes": {
  	"ui:widget" : "textarea"
  }
}

const formData = {};

const log = (type) => console.log.bind(console, type);

class ReservationForm extends React.Component {
  constructor(props){
  	super(props)
  	this.state = {
  	  schema,
  	  uiSchema,
  	  formData
  	}
  }

  onSubmit(event){
  	console.log('Event', event);
    alert(JSON.stringify(this.state.formData, null, 2))
  }

  onChange(event) {
  	console.log('Event', event);
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
		console.log(finalFormData)
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
};
export default ReservationForm
