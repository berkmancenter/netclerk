displayStatusBar = function(chartContainer, statuses) {
  var svg = dimple.newSvg(chartContainer, 380, 32);
  var myChart = new dimple.chart(svg, statuses);
  var x = myChart.addPctAxis("x", "frequency");
  var y = myChart.addCategoryAxis("y", "country");

  x.hidden = true;
  y.hidden = true;
  myChart.x = 0;
  myChart.width = "100%";
  myChart.height = "100%";
  myChart.assignColor(0, "#DFF0D8");
  myChart.assignColor(1, "#D9EDF7");
  myChart.assignColor(2, "#FCF8E3");
  myChart.assignColor(3, "#F2DEDE");
  s = myChart.addSeries("status", dimple.plot.bar);
  s.addOrderRule([0, 1, 2, 3]); // always display segments in the same order
  s.addEventHandler("mouseover", function (e){}); // disable tooltips
  myChart.draw();
};

$(".statusBarContainer").each(function() {
  var statuses = $(this).data("statuses");

  if (!$.isEmptyObject(statuses)) {
    displayStatusBar(this, statuses);
  };
});
