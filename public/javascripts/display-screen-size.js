const dimensionsDiv = document.createElement('div');
dimensionsDiv.style.position = 'fixed';
dimensionsDiv.style.bottom = '10px';
dimensionsDiv.style.left = '10px';
dimensionsDiv.style.backgroundColor = 'black';
dimensionsDiv.style.color = 'black';
dimensionsDiv.style.padding = '5px 10px';
dimensionsDiv.style.fontSize = '12px';
dimensionsDiv.style.borderRadius = '3px';
dimensionsDiv.style.zIndex = '1000';

function updateViewportDimensions() {
    dimensionsDiv.textContent = `${window.innerWidth} x ${window.innerHeight}`;
}

updateViewportDimensions();
window.addEventListener('resize', updateViewportDimensions);

document.body.appendChild(dimensionsDiv);
