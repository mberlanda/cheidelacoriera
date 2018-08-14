# frozen_string_literal: true

module ReservationSchema
  module_function

  def jsonschema(minimum: 1, maximum: 10, default: 1)
    {
      title: 'Prenota la trasferta',
      description: schema_description(maximum),
      type: 'object',
      required: %w[phone_number fan_names],
      properties: {
        authenticity_token: { type: 'string' },
        event_id: { type: 'integer' },
        user_id: { type: 'integer' },
        phone_number: { type: 'string', title: 'Numero di telefono', minLength: 7 },
        fans_count: {
          type: 'integer',
          title: 'Numero di Partecipanti',
          enum: (minimum..maximum).to_a,
          minimum: minimum,
          maximum: maximum,
          default: default
        },
        fan_names: {
          type: 'array',
          title: '',
          description: 'Inserisci i dati di ciascun partecipante',
          items: {
            title: '',
            type: 'object',
            required: %w[first_name last_name],
            properties: {
              first_name: {
                type: 'string',
                title: 'Nome',
                minLength: 3
              },
              last_name: {
                type: 'string',
                title: 'Cognome',
                minLength: 3
              }
            }
          },
          minItems: minimum,
          maxItems: maximum,
          uniqueItems: true
        },
        notes: { type: 'string', title: 'Note' }
      }
    }
  end

  def ui_schema
    {
      "authenticity_token": { "ui:widget": 'hidden' },
      "event_id": { "ui:widget": 'hidden' },
      "user_id": { "ui:widget": 'hidden' },
      "fans_count": {
        "ui:widget": 'select',
        "ui:options": {
          "inline": true
        }
      },
      "fan_names": {
        "ui:options": {
          "addable": false,
          "orderable": false,
          "removable": false
        },
        "items": {
          "first_name": {
            "classNames": 'col-md-6',
            "ui:placeholder": 'Nome',
            "ui:options": {
              "label": false
            }
          },
          "last_name": {
            "classNames": 'col-md-6',
            "ui:placeholder": 'Cognome',
            "ui:options": {
              "label": false
            }
          }
        }
      },
      "notes": {
        "ui:widget": 'textarea'
      }
    }
  end

  def schema_description(max_pax)
    places = max_pax > 1 ? "#{max_pax} posti" : '1 posto'
    "Per questa partita potrai prenotare un massimo di #{places}. "\
    'Per fini organizzativi, ti invitiamo ad indicare il Nome e il Cognome ' \
    'di ciascun partecipante che si unirà alla trasferta'
  end
end