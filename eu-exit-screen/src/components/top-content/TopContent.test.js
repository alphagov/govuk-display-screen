import React from 'react';
import ReactDOM from 'react-dom';
import TopContent from './TopContent';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<TopContent />, div);
  ReactDOM.unmountComponentAtNode(div);
});
