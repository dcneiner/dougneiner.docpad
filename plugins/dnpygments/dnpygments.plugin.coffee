module.exports = (BasePlugin) ->
	rFormatBlocks = /(```([a-z]+)\n([\S\s]+?)\n```)/gi
	rFormatBlocksDiv = /(<p>ZZZBLOCKZZZ<\/p>)/gi
	util = require('util')
	_ = require( 'underscore' )
	{spawn,exec} = require('child_process')
	fs   = require( 'fs' )
	
	escapeshell = (cmd) ->
		'"' + cmd.replace(/(["\$`])/g,'\\$1') + '"'
	
	class PygmentsPlugin extends BasePlugin
		# Plugin Name
		name: 'pygments'

		priority: 100

		generateBefore: ({}, next) ->
			return next()
		
		renderBefore: ({documents, templateData},next) ->
			to_process = [];
			for document in documents
				if document.extensions[ document.extensions.length - 1] in [ "md", "markdown" ]
					to_process.push( document )
			
			queue = () =>
				doc = to_process.shift()
				if ( doc )
					@_renderCode doc, queue
				else
					next()
				
			queue()

		# Ammend our Template Data
		_renderCode: (document, next) ->
			to_process = []
			processed = []
			
			document.body.replace rFormatBlocks, (a, b, lang, html) ->
				to_process.push { lang: lang, html: html, lines: html.split( "\n" ).length }
				return a
			
			finalize = () ->
				document.body = document.body.replace rFormatBlocks, (a, b, lang, html) ->
					console.log( processed[ 0 ] )
					processed.shift()
				next()
	
			next_format = () ->
				processing = to_process.shift()
				if processing
					exec "echo #{escapeshell(processing.html)} | /usr/local/bin/pygmentize -f html -l #{processing.lang}", ( err, stdout ) ->
						lines = (num for num in [1..processing.lines])
						lines = lines.join( "\n" )
						
						code_block = "<div class='code-block code-lang-" + processing.lang + "'><div class='code-lines' style='display: none'><pre>#{lines}</pre></div>"
						code_block = code_block + stdout + "</div>"
						
						processed.push code_block
						next_format()
				else
					finalize()
			
			next_format()
