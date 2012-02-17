---
layout: post
title: Using CSS Classes with JavaScript to Control Visual State
category: Strategy
---

The magic that we need is to somehow interrupt the queue system. Thankfully, there is an API just for that and in the next section we will show how to use it.


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

If you played with the example above you'll have noticed that if you interact with the menu really quickly side-to-side then the animations continue over and over and over again, even after you've moved off the menu completely! 

## Understanding the Problem

At the root of the problem is an animation queue that has gotten out of hand. jQuery keeps an internal queue to help it know what animation to run next. When you take an element and call one of the animation methods (`.animate()` , `.slideDown()`, `.slideUp()`, `.slideToggle()`, etc... ) what really happens is that effect gets added to the default "fx" animation queue that is attached to the element. As each effects completes jQuery will move on to the next effect in the queue until all animations are complete. 

The magic that we need is to somehow interrupt the queue system. Thankfully, there is an API just for that and in the next section we will show how to use it.


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

At the root of the problem is an animation queue that has gotten out of hand. jQuery keeps an internal queue to help it know what animation to run next. When you take an element and call one of the animation methods (`.animate()` , `.slideDown()`, `.slideUp()`, `.slideToggle()`, etc... ) what really happens is that effect gets added to the default "fx" animation queue that is attached to the element. As each effects completes jQuery will move on to the next effect in the queue until all animations are complete. 

The magic that we need is to somehow interrupt the queue system. Thankfully, there is an API just for that and in the next section we will show how to use it.
