$( function() {
  //
  // d3 status charts
  //

  d3.bullet = function() {
    var width = 380;
    var height = 32;
    var duration = 0;

    function bullet(g) {
      g.each( function( d, i ) {
        var rangez = d.sort( d3.descending );
        var g = d3.select( this );

        var x1 = d3.scale.linear()
          .domain( [ 0, 3 ] )
          .range( [ 0, width ] );

        var x0 = d3.scale.linear()
          .domain( [ 0, Infinity ] )
          .range( x1.range() );
        
        var w0 = bulletWidth( x0 );
        var w1 = bulletWidth( x1 );

        var range = g.selectAll( 'rect.range' )
          .data( rangez );

        range.enter()
          .append( 'rect' )
            .attr( 'class', function( d, i ) { return 'range sc' + i; } )
            .attr( 'width', w0 )
            .attr( 'height', height )
            .attr( 'x', 0 )
          .transition()
            .duration( duration )
            .attr( 'width', w1 )
            .attr( 'x', 0 );

        range.transition()
          .duration( duration )
          .attr( 'x', 0 )
          .attr( 'width', w1 )
          .attr( 'height', height );
      } );

      d3.timer.flush();
    }

    return bullet;
  };

  function bulletWidth(x) {
    var x0 = x(0);
    return function(d) {
      return Math.abs(x(d) - x0);
    };
  }

  $( '.statuses-chart' ).each( function() {
    var $chart = $( this );
    var todaysStatus = $chart.data( 'todaysStatus' );

    var chart = d3.bullet();

    d3.select( this )
      .data( [ todaysStatus ] )
      .call( chart );
  } );
} );

