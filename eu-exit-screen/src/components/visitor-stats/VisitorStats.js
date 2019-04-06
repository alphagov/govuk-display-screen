import React, { Component } from 'react';
import './VisitorStats.scss';

class VisitorStats extends Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <div className="VisitorStats">
        <h2 className="govuk-heading-m">GOV.UK average user traffic</h2>
        <div className="govuk-grid-row">
          <div className="govuk-grid-column-one-half VisitorStats-stat VisitorStats-stat--today">
            <p className="govuk-body govuk-!-font-size-80 govuk-!-font-weight-bold">10000</p>
            <p className="govuk-body govuk-!-font-size-24">Today</p>
          </div>
          <div className="govuk-grid-column-one-half VisitorStats-stat VisitorStats-stat--last-seven-days">
            <p className="govuk-body govuk-!-font-size-80 govuk-!-font-weight-bold">10000</p>
            <p className="govuk-body govuk-!-font-size-24">Last 7 days</p>
          </div>
        </div>
      </div>
    );
  }
}

export default VisitorStats;
