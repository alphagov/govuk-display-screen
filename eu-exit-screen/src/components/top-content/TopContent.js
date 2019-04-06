import React, { Component } from 'react';
import 'whatwg-fetch';
import './TopContent.scss';

class TopContent extends Component {
  constructor(props) {
    super(props);

    this.state = {
      limit: 5,
      content: null
    }
  }

  componentDidMount() {
    this.updateContent();
    this.interval = setInterval(() => this.updateContent(), 1000 * 60);
  }

  componentWillUnmount() {
    clearInterval(this.interval);
  }

  updateContent() {
    fetch(this.getEndpoint())
    .then(res => res.json())
    .then((result) => {
      this.setState({
        content: this.formatContent(result.data)
      });
    });
  }

  getEndpoint() {
    return `https://www.performance.service.gov.uk/data/govuk/trending?limit=${this.state.limit}&sort_by=percent_change:descending`;
  }

  formatContent(data) {

    var listItems = [];

    data.forEach( (item, i) => {
      listItems.push(
        <li className="govuk-!-margin-bottom-4 TopContent-content-list-item" key={i}>
          <p className="govuk-body">
            {
              item.pageTitle.indexOf(' - ') > -1 ? 
              item.pageTitle.split(' - ').slice(0,-1).join(' - ') : 
              item.pageTitle.split(' | ').slice(0,-1).join(' - ')
            }
          </p>
          <div className="TopContent-content-list-item-stats">
            <ul class="govuk-list">
              <li>
                Visits: {item.week2}
              </li>
              <li>
                <span class="triangle">▲</span>
                {item.percent_change}%
              </li>
            </ul>
          </div>
        </li>
      );
    });

    return (
      <div className="TopContent-content-list">
        <ol className="govuk-list govuk-list--number">
          {listItems}
        </ol>
      </div>
    );
  }

  render() {
    return (
      <div className="TopContent">
        <h2 className="govuk-heading-l">Top {this.state.limit} EU exit pages</h2>
        {this.state.content}
      </div>
    );
  }
}

export default TopContent;
