var centerLatitude = 52.523404; 
var centerLongitude = 13.41139952; 
var startZoom = 2;
var map;
var marker

function init() { 
	if (GBrowserIsCompatible()) {
		map = new GMap2(document.getElementById("map"));
		map.setUIToDefault();
		 
		var location = new GLatLng(centerLatitude, centerLongitude); 
		map.setCenter(location, startZoom);
		
			GEvent.addListener(map, "click", function(overlay,latlng) {
				if (latlng) {   
					document.getElementById("lat").value = latlng.lat();
					document.getElementById("lng").value = latlng.lng();

					if (!marker){
						marker = new GMarker(latlng, {draggable: true});
						map.addOverlay(marker);	  
					}
					else
			         marker.setLatLng(latlng);  
				 }
			});
			
			GEvent.addListener(map, "move", function() {
				if (!marker){
					document.getElementById("lat").value = map.getCenter().lat();
					document.getElementById("lng").value = map.getCenter().lng();
				}
			});		
	}
}

window.onload = init;
window.onunload = GUnload;


