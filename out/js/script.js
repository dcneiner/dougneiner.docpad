/* Author:

*/

var $win = $( window ), 
	$doc = $( document.documentElement ), 
	threshold = 100,
	old = 0;

$win.bind( "scroll", function () {
	var _new = $win.scrollTop();

	if ( _new <= threshold && old > threshold ) {
		$doc.removeClass( "scrolled" );
		old = 0;
		return;
	}
	
	if ( _new > threshold && old <= threshold ) {
		old = _new;
		$doc.addClass( "scrolled" );
		return;
	}
}).trigger( 'scroll' );

$( document ).on( "click", "header > div.highlight", function ( e ) {
	if ( $( e.target ).is( "a" ) ) {
		return;
	}
	if ( old === 0 ) {
		window.location = "/";
	} else {
		$( "html, body" ).animate( { scrollTop: 0 }, 300 );
	}
});