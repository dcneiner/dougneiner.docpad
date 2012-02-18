module.exports = (BasePlugin) ->
	rFormatBlocks = /(```([a-z]+)\n([^`]+)\n```)/gi
	rFormatBlocksDiv = /(<p>ZZZBLOCKZZZ<\/p>)/gi
	util = require('util')
	exec = require('child_process').exec
	fs   = require( 'fs' )
	
	class PygmentsPlugin extends BasePlugin
		# Plugin Name
		name: 'pygments'

		# Ammend our Template Data
		render: ({inExtension,outExtension,templateData,file}, next) ->
			if inExtension is "md"
				to_process = []
				processed = []
				file.content = file.content.replace rFormatBlocks, (a, b, lang, html) ->
					to_process.push { lang: lang, html: html, lines: html.split( "\n" ).length }
					"<p>ZZZBLOCKZZZ</p>"
				
				finalize = () ->
					file.content = file.content.replace rFormatBlocksDiv, (a, b, lang, html) ->
						processed.shift()
					next()
		
				next_format = () ->
					processing = to_process.shift()
					if processing
						fs.writeFileSync __dirname + "/tmp", processing.html, 'utf8'
						exec "/usr/local/bin/pygmentize -f html -l #{processing.lang} #{__dirname + "/tmp"}", ( err, stdout ) ->
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
