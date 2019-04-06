import React from 'react';
import ReactDOM from 'react-dom';
import VisitorStats from './VisitorStats';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<VisitorStats />, div);
  ReactDOM.unmountComponentAtNode(div);
});
