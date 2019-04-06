import React from 'react';
import ReactDOM from 'react-dom';
import LiveSearch from './LiveSearch';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<LiveSearch />, div);
  ReactDOM.unmountComponentAtNode(div);
});
