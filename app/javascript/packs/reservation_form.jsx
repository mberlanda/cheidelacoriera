
import React, { Component } from 'react'
import ReactDOM from 'react-dom'

class UserReservation extends Component {
  render(){
    return (
      <div className="form-inline" >
        { this._inputText(1, "last_name", "Cognome") }
        { this._inputText(1, "first_name", "Nome") }
        <small className="text-danger" id="guest-error" />
        <small className="text-success" id="guest-success" />
      </div>
    )
  }

  _inputText = (idx, elem, placeholder) => {
    return(
      <div className="form-group">
        <input
          name="{elem}"
          id="{elem}{idx}"
          className="form-control fake optional"
          placeholder="{placeholder}"
          type="text"
          onKeyUp={this._getCharacterCount.bind(this)}
        />
      </div>
    )
  }
  _getCharacterCount = () => {
    if (this.value.length < 3) {
      this.setState
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <UserReservation />,
    document.body.appendChild(document.createElement('div')),
  )
})
