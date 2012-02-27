(function () {

var className        = document.body.className,
	index            = /^page-(coding|learning)-index/.test( className ),
	comments_enabled = !index && /^page-(coding|learning)/.test( className ),
	comment_container;

// Set global config for Disqus
window.disqus_developer = 0;
window.disqus_shortname = 'dougneiner';

if ( index ) {
	// Show comment count
} else {
	// Enable comments
	comment_container = document.getElementById( "disqus_thread" );

	if ( !comment_container ) {
		return;
	}

	// Load Disqus
	(function() {
		var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
		dsq.src = 'http://' + window.disqus_shortname + '.disqus.com/embed.js';
		(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
	})();
}


}());