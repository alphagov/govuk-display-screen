import React from 'react';
import ReactDOM from 'react-dom';
import EuExitScreen from './EuExitScreen';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<EuExitScreen />, div);
  ReactDOM.unmountComponentAtNode(div);
});
