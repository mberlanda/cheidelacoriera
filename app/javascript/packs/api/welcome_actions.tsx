import * as React from "react"
import * as ReactDOM from 'react-dom'
import { Action } from './_action'
import { IndexActionProps } from "../../models/indexActionProps"

class WelcomeActions extends React.Component<{}> {
  state: {
    actions: IndexActionProps[];
  }

  constructor(props: {}){
    super(props);
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
    jQuery.get({
      method: 'GET',
      url: '/api/actions/available',
      dataType: 'json',
      success: (actions: IndexActionProps[]) => {
        this.setState({ actions });
      }
    });
  }
}

ReactDOM.render(
  <WelcomeActions />, document.getElementById('welcome-actions')
)