import React, { Component } from 'react';
import TypeIt from 'typeit';
import 'whatwg-fetch';
import './LiveSearch.scss';
import top_eu_exit_search_terms from './top-eu-exit-search-terms.json';

class LiveSearch extends Component {
  constructor(props) {
    super(props);

    this.state = { 
      GaProfileID: process.env.REACT_APP_GA_PROFILE_ID ? process.env.REACT_APP_GA_PROFILE_ID : "53872948",
      GaFilters: [
        "ga:pagePath==/search"
      ],
      GaMetrics: "ga:activeVisitors",
      GaDimensions: "ga:pageTitle,ga:pagePath",
      GaSort: "-ga:activeVisitors",
      maxResults: 100,
      results: [],
      ignoreList: [
        "Find EU Exit guidance for your organisation"
      ],
      euWordHighlightList: top_eu_exit_search_terms
    }
  }

  componentDidMount() {
    this.updateContent();
    this.interval = setInterval(() => this.updateContent(), 1000 * 120);
  }

  componentWillUnmount() {
    clearInterval(this.interval);
  }

  updateContent() {
    fetch(this.getEndpoint())
    .then(res => res.json())
    .then(
      (result) => {
        var formattedResults = this.formatSearchResults(result);
        this.setState({
          results: formattedResults
        });
        this.initTyped(formattedResults);
      },
      (err) => {
        console.log(err);
      }
    );
  }

  getEndpoint() {
    return `/realtime?ids=ga:${this.state.GaProfileID}&metrics=${this.state.GaMetrics}&dimensions=${this.state.GaDimensions}&filters=${encodeURIComponent(this.state.GaFilters.join(';'))}&sort=${this.state.GaSort}&max-results=${this.state.maxResults}`;
  }

  shouldDisplaySearch(searchTerm) {
    // Nothing that looks like an email address
    if(searchTerm.indexOf('@') > -1){
      return false;
    }

    // Nothing that is just a number
    if(searchTerm.match(/^[0-9\s]+$/)){
      return false;
    }

    // Nothing that is like a NI number
    if(searchTerm.match(/^[A-Za-z]{2}\s+?[0-9]{2}\s+?[0-9]{2}\s+?[0-9]{2}\s+?[A-Za-z]$/)){
      return false;
    }

    // No 503 requests
    if(searchTerm === "Sorry, we are experiencing technical difficulties (503 error)"){
      return false;
    }

    // Nothing with script tags
    if(searchTerm.match(/<script[\s\S]*?>[\s\S]*?<\/script>/)){
      return false;
    }

    // if term is in the ignore list
    if(this.state.ignoreList.includes(searchTerm)) {
      return false;
    }

    return true;
  }

  formatSearchResults(data) {

    var listItems = [];

    if (!data.rows) return listItems;

    data.rows.forEach( (item, i) => {
      var searchTerm = item[0].split(' - ')[0];

      if (!this.shouldDisplaySearch(searchTerm)){
        return;
      }

      if(new RegExp(this.state.euWordHighlightList.join("|")).test(searchTerm.toLowerCase())) {
        searchTerm = `<span class="LiveSearch-saerch-list-item--eu-exit-related">${searchTerm}</span>`;
      }

      listItems.push(searchTerm);
    });

    return listItems;
  }

  initTyped(formattedResults = []) {
    var count = 0;
    var typeit = new TypeIt(".LiveSeach-search-list-scroller", {
      strings: formattedResults,
      speed: 50,
      waitUntilVisible: true,
      beforeString: () => {
        if (count > 20 && typeit && typeit.instances[0]) {
          document.querySelector((`[data-typeit-id="${typeit.instances[0].id}"] .ti-container`)).innerHTML = '';
          count = 0;
        }
        count++;
      }
    }).go();
  }

  render() {
    return (
      <div className="LiveSearch">
        <h2 className="govuk-heading-l">Live searches</h2>
        <div className="LiveSearch-search-list">
          <div className="LiveSeach-search-list-scroller">
          </div>
        </div>
      </div>
    );
  }
}

export default LiveSearch;
