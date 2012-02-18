---
layout: post
title: Stop (Mis)Using Return False
category: Practices
date: 1284958800000
---
Probably one of the first topics covered when you get started learning about jQuery events is the concept of canceling the browser’s default behavior. For instance, a beginner click tutorial may include this:

```javascript
$("a.toggle").click(function () {
	$("#mydiv").toggle();
	return false; // Prevent browser from visiting `#`
});
```

This function toggles the hiding and displaying of `#mydiv`, then cancels the browser’s default behavior of visiting the href of the anchor tag.

It is in these very first examples that bad habits are formed as users continue to use `return false;` whenever they want to cancel the default browser action. I am going to cover two very important topics in this article relating to the canceling of browser events.

[Continue reading at Fuel Your Coding…](http://fuelyourcoding.com/jquery-events-stop-misusing-return-false/)

*This article was written for and published at Fuel Your Coding, on September 20, 2010. The material covered still applies to jQuery code written today.*