var centerLatitude = 52.523404; 
var centerLongitude = 13.41139952; 
var startZoom = 2;
var map;
var marker

function init() { 
	if (GBrowserIsCompatible()) {
		map = new GMap2(document.getElementById("map"));
		map.setUIToDefault();
		map.enableGoogleBar(); 
		var location = new GLatLng(centerLatitude, centerLongitude); 
		map.setCenter(location, startZoom);
		
			GEvent.addListener(map, "click", function(overlay,latlng) {
				if (latlng) {   
					document.getElementById("tandem_lat").value = latlng.lat();
					document.getElementById("tandem_lng").value = latlng.lng();

					if (!marker){
						marker = new GMarker(latlng);
						map.addOverlay(marker);	  
					}
					else
			         marker.setLatLng(latlng);  
				 }
			});
	}
}

window.onload = init;
window.onunload = GUnload;


