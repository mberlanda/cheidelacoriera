import React, {Component} from 'react';
import ReactDOM from 'react-dom';

import Form from "react-jsonschema-form";

const schema = {
  title: "Prenota la trasferta",
  type: "object",
  required: ["phone_number", "fan_names"],
  properties: {
    phone_number: {type: "string", title: "Numero di telefono", minLength: 7},
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
    }
  }
};

const log = (type) => console.log.bind(console, type);

ReactDOM.render((
  <Form schema={schema}
        onChange={log("changed")}
        onSubmit={log("submitted")}
        onError={log("errors")} />
), document.getElementById("react-reservation-form"));