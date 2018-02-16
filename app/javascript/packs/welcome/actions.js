import React, {Component} from 'react'
import ReactDOM from 'react-dom'

import Action from './_action'

class Actions extends Component {
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
      url: '/welcome/menu_actions',
      format: 'json',
      success: (actions) => {
        this.setState({ actions });
      }
    });
  }
}

ReactDOM.render(
  <Actions />, document.getElementById('welcome-actions')
)