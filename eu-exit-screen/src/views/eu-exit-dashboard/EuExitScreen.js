import React, { Component } from 'react';
import { initAll } from 'govuk-frontend';
import './EuExitScreen.scss';

// components
import Navbar from '../../components/navbar/Navbar';
import VisitorStats from '../../components/visitor-stats/VisitorStats';
import TopContent from '../../components/top-content/TopContent';
import LiveSearch from '../../components/live-search/LiveSearch';

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
              <VisitorStats />
              <hr className="govuk-section-break govuk-section-break--l govuk-section-break--visible" />
              <TopContent />
            </div>
            <div className="govuk-grid-column-two-thirds EuExitScreen-right-view">
              <LiveSearch />
            </div>
          </div>
      </div>
    );
  }
}

export default EuExitScreen;
