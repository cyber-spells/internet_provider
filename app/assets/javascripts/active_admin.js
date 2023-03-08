//= require arctic_admin/base
//= require chartkick
//= require Chart.bundle
//= require "@rails/ujs"

// add event listener onclick for button with id btn_id

let last_opened_info_window = null;

window.onload = function () {
    const current_url = window.location.href.toString();

    if (document.getElementById("consumer_map")) {
        let consumerMap = new google.maps.Map(document.getElementById("consumer_map"), {
            zoom: 14,
            center: {
                lat: 48.6208,
                lng: 22.2879
            },
        });
        let marker = null;
        // handle click on map
        google.maps.event.addListener(consumerMap, "click", (event) => {
            // get latitude and longitude
            let latitude = event.latLng.lat();
            let longitude = event.latLng.lng();

            // set latitude and longitude to input fields and create marker
            document.getElementById("consumer_latitude").value = latitude;
            document.getElementById("consumer_longitude").value = longitude;

            // Perform a reverse geocoding lookup
            let geocoder = new google.maps.Geocoder();
            geocoder.geocode({'location': event.latLng}, function (results, status) {
                if (status === 'OK') {
                    // Get the formatted address from the first result
                    document.querySelector("#consumer_address").value = results[0].formatted_address;
                } else {
                    console.log('Geocoder failed due to: ' + status);
                }
            });

            if (marker != null) {
                let latLng = new google.maps.LatLng(latitude, longitude);
                marker.setPosition(latLng);
            } else marker = new google.maps.Marker({
                position: {
                    lat: latitude,
                    lng: longitude
                }
            });

            marker.setMap(consumerMap);
        });
    }

    if (document.getElementById("current_consumer_map")) {
        let currentConsumerMap = new google.maps.Map(document.getElementById("current_consumer_map"), {
            zoom: 14,
            center: {
                lat: 48.6208,
                lng: 22.2879
            },
        });

        let marker = null;

        let latitude = document.getElementById("consumer_latitude").innerText;
        let longitude = document.getElementById("consumer_longitude").innerText;
        console.log(latitude, longitude)
        marker = new google.maps.Marker({
            position: {
                lat: parseFloat(latitude),
                lng: parseFloat(longitude)
            }
        });

        // focus map on marker
        currentConsumerMap.setCenter(marker.getPosition());

        marker.setMap(currentConsumerMap);
    }

    // if current url has / in the end, clear it
    if (current_url[current_url.length - 1] === "/") {
        window.location.href = current_url.substring(0, window.location.href.toString().length - 1);
    }

    // if current page is /admin or /admin/dashboard
    let currentPath = current_url.split("/");

    if (currentPath[currentPath.length - 1] === "admin" || currentPath[currentPath.length - 1] === "dashboard") {
        // log hello world
        if (document.getElementById("consumers_map")) {
            let consumersMap = new google.maps.Map(document.getElementById("consumers_map"), {
                zoom: 14,
                center: {
                    lat: 48.6208,
                    lng: 22.2879
                },
            });
            initConsumersMap(consumersMap);
        }
    }
}


function initConsumersMap(map) {
    const elementImage = new google.maps.MarkerImage('/builded.png',
        new google.maps.Size(64, 64),
    );


    // get all consumers from database
    Rails.ajax({
        type: "GET",
        url: "/admin/consumers/get_all_consumers",
        success: function (response) {
            response["consumers"].forEach((consumer) => {
                let marker = null;

                let infoWindow = null;

                // generate new marker
                marker = new google.maps.Marker({
                    position: {
                        lat: consumer["latitude"],
                        lng: consumer["longitude"]
                    },
                    map: map,
                    icon: elementImage
                });

                infoWindow = new google.maps.InfoWindow({
                    content: `<div>Адреса: ${consumer.address} </div>
                              <div>Тариф: ${consumer.tariff}</div>
                              <a href="/admin/consumers/${consumer.id}">Переглянути</a>`,
                });

                google.maps.event.addListener(marker, "click", () => {
                    if (last_opened_info_window != null) last_opened_info_window.close();
                    infoWindow.open(map, marker);
                    last_opened_info_window = infoWindow;
                })
            })
        },
        error: function (response) {
            console.log("error")
        }
    })
}