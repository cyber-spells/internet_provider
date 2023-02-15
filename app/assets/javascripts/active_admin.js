//= require arctic_admin/base
//= require chartkick
//= require Chart.bundle
//= require "@rails/ujs"

// add event listener onclick for button with id btn_id

let last_opened_info_window = null;

window.onload = function () {

    // if current page is /admin or /admin/dashboard
    let currentPath = window.location.href.split("/");
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
        url: "consumers/get_all_consumers",
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