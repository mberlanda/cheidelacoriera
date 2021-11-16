import * as React from "react"
import { IndexActionProps } from "../../models/indexActionProps"

export class Action extends React.Component<IndexActionProps> {
  constructor(props: IndexActionProps) {
    super(props);
  }

  render(){
    const action = this.props;
    return(
      <div className="col-sm-6 features-box wow fadeInLeft">
        <div className="row">
          <div className="col-sm-3 features-box-icon">
            <i className={action.iconClass}/>
          </div>
          <div className="col-sm-9">
            <h3>{action.heading}</h3>
            <p className="features-box-body">{action.body}</p>
            <br/>
            <div className="features-box-button">
              <a
                href={action.url}
                className="btn btn-primary gtm-home-action"
                data-action={action.name}
              > {action.buttonText} </a>
            </div>
          </div>
        </div>
        <div className="row"><hr/></div>
      </div>
    )
  }
}
