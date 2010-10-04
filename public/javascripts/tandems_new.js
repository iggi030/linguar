function limitText(limitField, limitCount, limitNum) {
	if (limitField.value.length > limitNum) {
		limitField.value -= 1;
	} else {
		limitCount.value = limitNum - limitField.value.length;
	}
}

function old_init() { 
	if (GBrowserIsCompatible()) {
		map = new GMap2(document.getElementById("map"));
		map.setUIToDefault();
		map.enableGoogleBar(); 
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