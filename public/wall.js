
// ui elements
function hideBottomBar() {
	document.getElementById('bottomBar').style.display = 'none'
}


// core wall code
var serverUrl = window.location.href
var values = document.getElementsByClassName('culture-value')
var isPaidWall = '<%= @is_paid_wall %>'

if (serverUrl.indexOf('/walls/demo') > 0) {
	document.getElementById('wallLink').innerHTML = "You are viewing a demo wall. Values you add and votes you make will not be saved."
} else {
	document.getElementById('wallLink').innerHTML = "Copy your unique link to this wall: " + "<a href='" + serverUrl + "'>" + serverUrl + "</a>"
}

// wraps addValue to only run when Enter is pressed
function submitWrapper(e) {
	if (e.keyCode==13){
		addValue()
	}
}

function addValue() {

	// for a free wall, don't add more than three values
	if (!isPaidWall && document.getElementsByClassName('culture-value').length >= 5) {
		alert("You will need to purchase a premium wall to add more than five values.")
		return
	}

	newName = document.getElementById('newValue').value
	if (!newName) { return } // don't add an empty value

	// add value to document
	var newValue = document.createElement('div')
	newValue.appendChild(document.createTextNode(newName))
	newValue.className = 'culture-value'
	newValue.style.fontSize = '15px'
	document.getElementById('values-container').appendChild(newValue)

	// register value with the server
	var payload = JSON.stringify({name: newName})
    fetch(serverUrl + '/values/grow', {
      method: "POST",
      body: payload,
      mode: 'no-cors'
})

  //add a listener
	newValue.addEventListener('click', growValueListener(newValue))

	// clear text box
	document.getElementById('newValue').value = ''
}

function addListeners() {		
	Array.prototype.forEach.call(values, function(value) {
		value.addEventListener('click', growValueListener(value))
		value.addEventListener('contextmenu', shrinkValueListener(value), false)
	})
}

// build a listener function for a value
function growValueListener(value) {
	return function(e) {
			// haha what the fuck
			value.style.fontSize = parseInt(value.style.fontSize.slice(0,-2)) + 5 + 'px'

			var payload = JSON.stringify({name: value.innerText})
	    fetch(serverUrl + '/values/grow', {
	      method: "POST",
	      body: payload,
	      mode: 'no-cors'
	    })
		}
}

function shrinkValueListener(value) {
	return function(e) {
			// haha what the fuck
			e.preventDefault()
			value.style.fontSize = parseInt(value.style.fontSize.slice(0,-2)) - 5 + 'px'

			var payload = JSON.stringify({name: value.innerText})
	    fetch(serverUrl + '/values/shrink', {
	      method: "POST",
	      body: payload,
	      mode: 'no-cors'
	    })
	    return false
		}
}

addListeners()