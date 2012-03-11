(() ->
	className        = document.body.className
	index            = /^page-(coding|learning)-index/.test className
	comments_enabled = !index and /^page-(coding|learning)/.test className

	# Set global config for Disqus
	window.disqus_developer = 0
	window.disqus_shortname = 'dougneiner'

	unless index
		# Enable comments
		comment_container = document.getElementById( "disqus_thread" )
		return unless comment_container

		# Load Disqus
		dsqLoad = () ->
			dsq = document.createElement('script')
			dsq.type  = 'text/javascript'
			dsq.async = true
			dsq.src   = "http://#{window.disqus_shortname}.disqus.com/embed.js"
			(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq)

		dsqLoad()
)()