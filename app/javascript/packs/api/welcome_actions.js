import React, {Component} from 'react'
import ReactDOM from 'react-dom'

import Action from './_action'

class WelcomeActions extends Component {
  constructor(){
    super();
    this.state = {
      actions: []
    };
    this._fetchActions();
  }

  render(){
    return(
      this.state.actions.map(action =>
        <Action action={action} key={action.name}/>
      )
    )
  }

  _fetchActions = () => {
    jQuery.ajax({
      method: 'GET',
      url: '/api/actions/available',
      format: 'json',
      success: (actions) => {
        this.setState({ actions });
      }
    });
  }
}

ReactDOM.render(
  <WelcomeActions />, document.getElementById('welcome-actions')
)