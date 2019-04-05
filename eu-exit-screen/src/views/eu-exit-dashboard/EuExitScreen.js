import React, { Component } from 'react';
import { initAll } from 'govuk-frontend';
import Navbar from '../../components/navbar/Navbar';
import './EuExitScreen.scss';

class EuExitScreen extends Component {
  componentDidMount() {
    initAll();
  }

  render() {
    return (
      <div className="EuExitScreen">
        <Navbar />
          <div className="govuk-grid-row">
            <div className="govuk-grid-column-one-third EuExitScreen-left-view">
              <h2 className="govuk-heading-m">One-third column</h2>
              <p className="govuk-body">This is a paragraph inside a one-third wide column</p>
            </div>
            <div className="govuk-grid-column-two-thirds EuExitScreen-right-view">
              <h1 className="govuk-heading-xl">Two-thirds column</h1>
              <p className="govuk-body">This is a paragraph inside a two-thirds wide column</p>
            </div>
          </div>

      </div>
    );
  }
}

export default EuExitScreen;
