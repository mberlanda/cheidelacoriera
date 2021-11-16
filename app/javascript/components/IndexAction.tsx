import * as React from "react"
import { IndexActionProps } from "../models/indexActionProps"

export default class IndexAction extends React.Component<IndexActionProps, {}> {
  constructor(props: IndexActionProps) {
    super(props);
  }

  render(){
    return(
      <div className="col-sm-6 features-box wow fadeInLeft">
        <div className="row">
          <div className="col-sm-3 features-box-icon">
            <i className={this.props.iconClass}/>
          </div>
          <div className="col-sm-9">
            <h3>{this.props.heading}</h3>
            <p className="features-box-body">{this.props.body}</p>
            <br/>
            <div className="features-box-button">
              <a
                href={this.props.url}
                className="btn btn-primary gtm-home-action"
                data-action={this.props.name}
              > {this.props.buttonText} </a>
            </div>
          </div>
        </div>
        <div className="row"><hr/></div>
      </div>
    )
  }
}
