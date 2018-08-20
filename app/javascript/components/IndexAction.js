import React from "react"
import PropTypes from "prop-types"

class IndexAction extends React.Component {

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

IndexAction.propTypes = {
  body: PropTypes.string,
  buttonText: PropTypes.string,
  heading: PropTypes.string,
  iconClass: PropTypes.string,
  name: PropTypes.string,
  url: PropTypes.string,
}

export default IndexAction
