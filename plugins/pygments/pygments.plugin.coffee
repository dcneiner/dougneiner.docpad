module.exports = (BasePlugin) ->
	rFormatBlocks = /(```([a-z]+)\n([\S\s]+?)\n```)/gi
	rFormatBlocksDiv = /(<p>ZZZBLOCKZZZ<\/p>)/gi
	util = require('util')
	{spawn,exec} = require('child_process')
	fs   = require( 'fs' )
	
	escapeshell = (cmd) ->
		'"' + cmd.replace(/(["])/g,'\\$1') + '"'
	
	class PygmentsPlugin extends BasePlugin
		# Plugin Name
		name: 'pygments'

		priority: 100
		
		renderBefore: ({templateData},next) ->
			for document in templateData.documents
				if document.extensions[ document.extensions.length - 1] in [ "md", "markdown" ]
					document.extensions.push "pyg"
					document.extension = "pyg"
			
			next()

		# Ammend our Template Data
		render: ({inExtension,outExtension,templateData,file}, next) ->
			if inExtension in ["pyg"] and outExtension in [ "md", "markdown" ]
				to_process = []
				processed = []
				
				file.content = file.content.replace rFormatBlocks, (a, b, lang, html) ->
					to_process.push { lang: lang, html: html, lines: html.split( "\n" ).length }
					return a
				
				finalize = () ->
					file.content = file.content.replace rFormatBlocks, (a, b, lang, html) ->
						processed.shift()
					next()
		
				next_format = () ->
					processing = to_process.shift()
					if processing
						exec "echo #{escapeshell(processing.html)} | /usr/local/bin/pygmentize -f html -l #{processing.lang}", ( err, stdout ) ->
							lines = (num for num in [1..processing.lines])
							lines = lines.join( "\n" )
							
							code_block = "<div class='code-block code-lang-" + processing.lang + "'><div class='code-lines'><pre>#{lines}</pre></div>"
							code_block = code_block + stdout + "</div>"
							
							processed.push code_block
							next_format()
					else
						finalize()
				
				next_format()
			else
				next()
