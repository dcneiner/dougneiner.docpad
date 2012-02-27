---
layout: post
title: Using CSS Classes with jQuery to Control Visual State
category: Strategy
ignore: false
---

We tend to look at web applications and web sites as a progression of user input and system response. We view their interaction more as a river of information flowing from process to process. Never quite sure what the user will do next, our system attempts to provide the appropriate responses to their input.

If we take a closer look, instead of a constant dynamic stream of responses, we will see various static states on both the component and the page level. Except in games and edge cases, no part of our interface is in a constant state of flux. For example, a complex web application may start in a `loading` state, and then move to a `ready` state after the application is ready for user interaction. Later in the interaction cycle, it might transition to a `saving` state in which most buttons are disabled until the system returns to a `ready` state. 

The temptation is for developers to keep all of the changes associated with these states in the JavaScript code itself. In the case of our `loading` and `ready` states, their code might looks something like this:

```javascript
var loadingMessage = $( "#loadingMessage" ),
	header         = $( "#header" ),
    content        = $( "#content" );

loadingMessage.show();
header.hide();
content.hide();

// Lots of setup and async code here

function someReadyCallback () {
	// The app is loaded!
	loadingMessage.hide();
	header.show();
	content.show();
}
```

The important thing to notice about this example, is that each component is being interacted with directly through jQuery methods. This requires a reference to the elements via direct selection or traversal. It also puts the heavy lifting on jQuery to properly show and hide these elements appropriately.

As we add different states to the application ( `saving`, `data entry`, `fullscreen text entry` ), the need for code like this multiplies.

## Thinking Differently

In order to cut down on this type of jQuery code, we need to widen the focus of our thinking. As soon as we start changing the visual state of multiple items at the same time, we should start to think of a different way of adjusting visual state.

### The Document Object Model

The Document Object Model is often represented as an inverse tree. We start at the root `<html>` element and quickly branch to `<head>` and `<body>`. As we step into the rest of our page structure, we see many branches forming our inverted tree. 

When you cut a branch off a real tree, you are also removing any other branches, twigs and leaves attached to it. In short, modifying a parent branch affects the child limbs. The DOM works the same way, and we can use that to our advantage when we seek to make sweeping changes with minimal effort.

### jQuery's `show` and `hide`

Behind the scenes, jQuery's `show` and `hide` methods are (after a bit of legwork to ensure the proper changes) adjusting `.style.display` on each element. Since that change is made on the element level, it has the same effect as applying `style="display: none"` or `style="display: block"` inline in the HTML. It increases the specificity of the styling, overriding any other `display` setting in the CSS except those with an `!important` designation.


## A New Approach

Now that we realize that we are actually adjusting a single CSS property with JavaScript, lets try optimizing this adjustment. The first thing we want to do, is write CSS to fully describe the two states we are looking for. Since a `ready` state is how our application should look most of the time, we will use that as the default state.

When thinking about states, we should seek to change some aspect of shared parent to affect the children. This can be simply adding a class name, or changing some other attribute of the element that we can respond to in CSS. Lets use a `loading` class applied to the `<body>` element to signify when our application is in a loading state.

Since elements default to being visible, we don't need to do anything special to `#content` and `#header` for our ready state. We do want the `#loadingMessage` to be hidden while in a `ready` state, so we set its default state to `display: none;`. During loading, the `#loadingMessage` should be visible, and both `#content` and `#header` should be hidden. Here is the finished CSS:

```css
#loadingMessage { display: none; }
.loading #loadingMessage { display: block; }

.loading #content,
.loading #header { display: none; }
```

Since the page will always start in a loading state, lets add the class of `loading` directly to the `<body>` element:

```html
<body class="loading">
```

Given the added CSS and class name applied in HTML, our complete solution needed to replace the previous code is as follows:

```javascript
var $body = $( document.body ); // Store a reference

// Lots of setup and async code here

function someReadyCallback () {
	// The app is loaded!
	$body.removeClass( "loading" );
} 
```

We have replaced the selection of three elements with a single reference to `document.body`. And we replaced six separate interactions with the DOM with a single removal of a `loading` class from the `<body>` element.

## Reacting To Specific States

You can combine these state classes with delegated events to write state specific code. Take the following code examples:

```javascript
$( document )
	.on( 
		"click", "body:not(.loading, .saving) button.save", function () {
		// perform the save, but not if we are still
		// loading or in the middle of a save
	})
	.on( "submit", "body.saving", function ( e ) {
		// prevent forms from submitting
		// if a save is in progress
		e.preventDefault();
	});
```

## Using Attributes instead of Classes

With Internet Explorer 7+, you can also use attribute changes to control flow. For certain changes that are atomic, you could use a HTML5 data attribute.

```html
<body data-state="loading">
```

Use a different selector in the CSS:

```css
body[data-state="loading"] #loadingMessage,
body[data-state="saving"] #savingMessage { display: block; }
```

And then change that state with jQuery:

```javascript
$body.attr( "state", "ready" ); // From loading to ready
// ... other code ...
$body.attr( "state", "saving" ); // Switch to saving
```