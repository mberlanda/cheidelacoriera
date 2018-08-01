import React from "react"
import PropTypes from "prop-types"
class ReservationForm extends React.Component {
  render () {
    return (
      <React.Fragment>
        Schema: {this.props.schema}
        Form Data: {this.props.formData}
        Ui Schema: {this.props.uiSchema}
        Max Fans: {this.props.maxFans}
      </React.Fragment>
    );
  }
}

ReservationForm.propTypes = {
  schema: PropTypes.object,
  formData: PropTypes.object,
  uiSchema: PropTypes.object,
  maxFans: PropTypes.node
};
export default ReservationForm
