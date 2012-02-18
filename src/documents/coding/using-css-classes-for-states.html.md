---
layout: post
title: Using CSS Classes with JavaScript to Control Visual State
category: Strategy
ignore: true
---

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.


```javascript
// Define a special initializer for our dialog
var contactDialog = (function () {
	var dfd;
	return function () {
		if ( !dfd ) {
			dfd = $.Deferred( function ( d ) {
				$.ajax({
					url: "/parts",
					success: d.resolve,
					error: d.reject
				});
			}).promise();
		}
		return dfd;
	}
}());

// Invoke it
console.log( "This is a test" );
contactDialog();
```

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum! 

## Understanding the Problem

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis `.nostrud()`, `.exercitation()` and `.ullamco()` laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 

```html
<div id="container">
	<h2>My Title</h2>
	<p>My content</p>
</div>
```


```css
#container { margin-bottom: 10px; }
#container p { font-size: 1em; }
```

Laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
