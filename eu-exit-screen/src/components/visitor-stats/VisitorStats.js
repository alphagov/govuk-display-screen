import React, { Component } from 'react';
import CountUp from 'react-countup';
import 'whatwg-fetch';
import './VisitorStats.scss';

class VisitorStats extends Component {
  constructor(props) {
    super(props);

    this.state = {
      startDate: new Date(),
      today: 0,
      lastSevenDays: 0,
    }
  }

  componentDidMount() {
    this.updateStats();
    this.interval = setInterval(() => this.updateStats(), 1000 * 60);
  }

  componentWillUnmount() {
    clearInterval(this.interval);
  }

  updateStats() {
    this.setTodaysStats();
    this.setLastSevenDayStats();
  }

  getEndpoint(offset = 0) {
    var date = new Date(this.state.startDate);
    date.setDate(date.getDate() - offset);
    var end = this.toPerformanceString(date);
    date.setDate(date.getDate() - 1);
    var start = this.toPerformanceString(date);
    return `https://www.performance.service.gov.uk/data/government/realtime?sort_by=_timestamp%3Adescending&start_at=${start}&end_at=${end}`;
  }

  toPerformanceString(date) {
    function pad(number) {
      if ( number < 10 ) {
        return '0' + number;
      }
      return number;
    }
    return date.getUTCFullYear() +
      '-' + pad( date.getUTCMonth() + 1 ) +
      '-' + pad( date.getUTCDate() ) +
      'T' + pad( date.getUTCHours() ) +
      ':' + pad( date.getUTCMinutes() ) +
      ':' + pad( date.getUTCSeconds() ) +
      'Z';
  };

  formatAverage(average) {
    return parseInt(average.toFixed(0));
  }

  setTodaysStats() {
    fetch(this.getEndpoint())
    .then(res => res.json())
    .then((results) => {
      var sum = 0;
      results.data.forEach(result => {
        sum += result.unique_visitors;
      });
      var average = sum / results.data.length;
      average = this.formatAverage(average);
      this.setState({
        today: this.getCountUp(average),
      });
    });
  }

  setLastSevenDayStats() {
    fetch(this.getEndpoint(7))
    .then(res => res.json())
    .then((results) => {
      var sum = 0;
      results.data.forEach(result => {
        sum += result.unique_visitors;
      });
      var average = sum / results.data.length;
      average = this.formatAverage(average);
      this.setState({
        lastSevenDays: this.getCountUp(average),
      });
    });
  }

  getCountUp(end) {
    return <CountUp 
      start={0} end={end}
      formattingFn={(number) => number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}
    />;
  }

  render() {
    return (
      <div className="VisitorStats">
        <h2 className="govuk-heading-m">GOV.UK average user traffic</h2>
        <div className="govuk-grid-row">
          <div className="govuk-grid-column-one-half VisitorStats-stat VisitorStats-stat--today">
            <p className="govuk-body govuk-!-font-size-80 govuk-!-font-weight-bold">{this.state.today}</p>
            <p className="govuk-body govuk-!-font-size-24">Today</p>
          </div>
          <div className="govuk-grid-column-one-half VisitorStats-stat VisitorStats-stat--last-seven-days">
            <p className="govuk-body govuk-!-font-size-80 govuk-!-font-weight-bold">{this.state.lastSevenDays}</p>
            <p className="govuk-body govuk-!-font-size-24">7 day average</p>
          </div>
        </div>
      </div>
    );
  }
}

export default VisitorStats;
