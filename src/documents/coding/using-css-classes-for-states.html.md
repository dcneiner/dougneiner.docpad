---
layout: post
title: Using CSS Classes with jQuery to Control Visual State
category: Strategy
excerpt: Instead of showing, hiding, and otherwise adjusting an HTML element's visual display with jQuery, execute the same level of change by strategically adding and removing classes with jQuery/JavaScript.
---

## Strategy

Instead of adjusting an HTML element's visual style with jQuery, make the same changes by strategically adding and removing classes. The classes can be applied on the component, region, and page level to control any static state of the host element or its decedents.

## Symptoms

You can easily detect when to use this strategy when you discover yourself performing any of the following actions:

* You show, hide, or otherwise visually adjust two or more elements at the same time. The higher the number of elements changed, the greater the need for this strategy.

* You need to run any number of jQuery selections via `$( selector )`, `.find()`, etc, just to adjust the visual display of those elements.

* You use jQuery’s [`.css()`](http://api.jquery.com/css) method to change an element from one visual appearance to another predetermined appearance.


### Problem 1

The following code illustrates the first two of these symptoms:

```javascript
$( document ).ready( function () {
	// Three separate elements are selected
	var loadingMessage = $( "#loadingMessage" ),
		header = $( "#header" ),
	    content = $( "#content" );

	// Three CSS changes are made:
	loadingMessage.show();
	header.hide();
	content.hide();

	// Lots of setup and async code here

	function someReadyCallback () {
		// Three additional CSS changes are made
		loadingMessage.hide();
		header.show();
		content.show();
	}
});
```

### Problem 2

This short example illustrates the third symptom:

```javascript
var $notification = $( ".notification" );
if ( error ) {
	$notification.css( "color", "red" );
} else {
	$notification.css( "color", "green" );
}
```

## Solutions

### Solution 1

To visually adjust **multiple items** at the same time, follow these steps:

1. Find a parent element that is shared by the elements you wish to adjust. Often you can use the `html` or `body` element, but it can be any element that contains all the target elements.
2. Determine a good CSS class name to describe the *combined* visual state of the elements, optionally add that class to the HTML and then manipulate it by using jQuery’s [`addClass`](http://api.jquery.com/addClass), [`removeClass`](http://api.jquery.com/removeClass) and [`toggleClass`](http://api.jquery.com/toggleClass) methods. Prefixing these classes with `state-` is one way to signify their purpose.
3. Write CSS that scopes selections using a combination of the chosen parent element and the new class that is being applied to it.

The CSS to fix our `loadingMessage` code would look like this:

```css
/* Loading message is hidden by default, only shown during loading */
#loadingMessage { display: none; }
.state-loading #loadingMessage { display: block; }

/* Content and Header are hidden during loading */
.state-loading #content,
.state-loading #header { display: none; }
```

Since the page will always start in a loading state, we add the class of `loading` directly to the `<body>` element:

```html
<body class="state-loading">
```

Finally, we delete almost all the code we had before, and just remove the `loading` class when loading is complete:

```javascript
// Lots of setup and async code here

function someReadyCallback () {
	// The app is loaded!
	$( document.body ).removeClass( "state-loading" );
} 
```

### Solution 2

To adjust the visual display of a **single item**, follow these steps:

1. Any aspect of the visual display that will not change should be defined as the element’s default display.
2. Determine a good class name to describe the new visual state of the element, optionally add that class to the HTML for the element and then manipulate it by using jQuery’s class manipulation methods.
3. Write CSS that scopes the new styles to the chosen element with the new class applied. You can also use multiple class syntax if you the element you are styling is already defined by a class: `.notification.ready` (Multiple class syntax is not supported by IE6 and lower).

If we assume the default state of our notification display is `green`, we can use the following CSS:

```css
.notification { color: green; }
.notification.state-error { color: red; }
```

The following code will add the class of `state-error` when our variable `error` is true:

```javascript
var $notification = $( ".notification" );
$notification.toggleClass( "state-error", error );
```


## Strengths 

* **Speed** – By strategically using classes instead of direct manipulation, you remove the need to find, then adjust multiple elements. Very little code is needed to add or remove a class, replaced potentially slow moving code (selectors and traversal) with extremely efficient code. By leaving the bulk of the changes up to the browser, you also capitalize on the speed of the browser’s CSS engine.
* **Separation of functionality and style** – By only manipulating a class name, you leave the bulk of the visual definition in the CSS files – where they belong. In a team setting, this also allows a designer to modify the design without interacting with the JavaScript.
* **Self describing code** – If the class names you choose are descriptive, then where they are added and removed is afforded an immediate increased in clarity (For a caveat to this point, see the note about [Education](#education) at the end of this post)
* **Scoped events with delegation** – You can leverage these class names to automatically filter out unwanted event triggers based on state. Look at the following example for ideas:

```javascript
$( document )

	// perform the save, but not if we are still
	// loading or in the middle of a save
	.on( "click", "body:not(.loading, .saving) button.save", function () {		
		...
	})
	
	// prevent forms from submitting
	// if a save is in progress
	.on( "submit", "body.saving", function ( e ) {
		e.preventDefault();
	})
	
	// only run the setup one time per element
	.on( "click", ".widget:not(.widget-setup)", function () {
		...
		$( this ).addClass( "widget-setup" );
	});
```

## Notes

### Transitions

Often the move from one state to another is accompanied by some sort of animation. Since much of the time these transitions are visual finesse, I suggest using CSS3 transitions and animations to implement the transitions. The fallback in unsupported browsers will simply be an instant change from one state to the next. In situations where the animation is crucial to the interaction, you may not be able to leverage everything covered in this article.

### Using Attributes instead of Classes

You can also use attribute changes to control flow, though I haven't done any speed comparisons between the two methods. Here is an example using a custom HTML5 data attribute named `data-state`:

```html
<body data-state="loading">
```

```css
body[data-state="loading"] #loadingMessage,
body[data-state="saving"] #savingMessage { display: block; }
```

```javascript
$body.attr( "state", "ready" ); // From loading to ready
// ... other code ...
$body.attr( "state", "saving" ); // Switch to saving
```

<h3 id="education">Education</h3>

If you work in a team environment, it would be wise to discuss this strategy with your team before implementing. JavaScript developers who do not work with CSS frequently may not understand the ramifications of the `addClass` and `removeClass` methods throughout your code.