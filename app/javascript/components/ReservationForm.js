import React from "react"
import PropTypes from "prop-types"
import Form from "react-jsonschema-form"
// import LayoutField from "react-jsonschema-form-layout-grid"

// const fields = {
//   layout_grid: LayoutField
// }

const schema = {
  title: "Prenota la trasferta",
  type: "object",
  required: ["phone_number", "fan_names"],
  properties: {
    phone_number: {type: "string", title: "Numero di telefono", minLength: 7},
    fans_count: {
    	type: "integer",
    	title: "Numero di Partecipanti",
    	enum: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    	minimum: 1,
    	maximum: 10,
    	default: 1
    },
    fan_names: {
      type: "array",
      title: "", // "Elenco Partecipanti",
      description: "Inserisci i dati di ciascun partecipante",
      items: {
      	title: "", //"Partecipante",
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
  // 'ui:field': 'layout_grid',
  // 'ui:layout_grid': { 'ui:row': [
  //   { "ui:col": { md: 12, children: [
  //     { "ui:row": [
  //       { "ui:col": { md: 12, children: ["phone_number"]} }
  //     ]},
  //     { "ui:row": [
  //       { "ui:col": { md: 12, children: ["fans_count"]} }
  //     ]},
  //     { "ui:row": [
  //       { 'ui:col': { md: 12, children: ['fan_names'] } },
  //       { 'ui:col': { md: 6, children: ['fan_names'] } },
  //     ]}
  //   ]}
  //   }
  // ]},
  "fans_count":{
    "ui:widget": "select",
    "ui:options": {
    	"inline": true
    }
  },
  "fan_names": {
  	"ui:options": {
      "addable": false,
      "orderable": false,
      "removable": false,
    },
    "items": {
    	"first_name" : {
        "classNames" : "col-md-6",
        "ui:placeholder": "Nome",
        "ui:options": {
        	"label": false
        }
    	},
    	"last_name" : {
        "classNames" : "col-md-6",
        "ui:placeholder": "Cognome",
        "ui:options": {
        	"label": false
        }
    	}
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
		  // fields={fields}
      onChange={this.onChange.bind(this)}
      onSubmit={this.onSubmit.bind(this)}
      onError={log("errors")} />
    );
  }
}

ReservationForm.propTypes = {
};
export default ReservationForm
