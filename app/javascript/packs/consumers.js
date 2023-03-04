import jsSHA from "jssha";
import {Base64} from "js-base64";

let previous_action;
document.addEventListener('turbolinks:load', () => {
    previous_action = document.getElementById('consumer_info');
})

function change_consumer_action(action) {
    if (previous_action === document.getElementById(`consumer_liqpay_checkout`)) {
        document.getElementById(`consumer_liqpay_checkout`).innerHTML = "";
    }
    previous_action.hidden = true;
    previous_action = document.getElementById(`consumer_${action}`);
    previous_action.hidden = false;
}

function onPay(consumer_id, amount) {
    document.getElementById("consumer_liqpay_checkout").innerHTML = "";
    const publicKey = "sandbox_i64952272431";

    const privateKey = "sandbox_6vEFcIc5kXG0pTWoIuYS2AoETCoywVzAqGAJOLdc";

    var data_liq = {
        action: 'pay',
        public_key: publicKey,
        amount: amount,
        currency: 'UAH',
        description: `Поповнення рахунку користувача №${consumer_id}`,
        order_id: consumer_id + JSON.stringify(Date.now()),
        version: '3',
    }
    data_liq = Base64.encode(JSON.stringify(data_liq));
    var sha = new jsSHA("SHA-1", "TEXT");
    sha.update(privateKey + data_liq + privateKey);
    var signature = sha.getHash("B64");
    window.LiqPayCheckoutCallback = function () {
        let callbackFunction = function (data) {
            if (data.status === 'success') {
                Rails.ajax({
                    type: "POST",
                    url: "consumers/" + consumer_id + "/update_balance",
                    data: `status=success&amount=${amount}`,
                    success: function (response) {
                        window.scroll(0, 0);
                        document.querySelector("#consumer_balance").innerHTML = parseFloat(response["new_balance"]).toFixed(2);
                        document.querySelector("#consumer_remaining_days").innerHTML = response["remaining_days"];
                    },
                    error: function (response) {
                        console.log("error")
                    }
                })
                // Remove the event listener for liqpay.callback
                LiqPayCheckout.off("liqpay.callback", callbackFunction);
            }
        };

        LiqPayCheckout.init({
            data: data_liq,
            signature: signature,
            embedTo: "#consumer_liqpay_checkout",
            language: "uk",
            mode: "embed" // embed || popup
        }).on("liqpay.callback", callbackFunction);
    };

    LiqPayCheckoutCallback.call()
}


window.change_consumer_action = change_consumer_action;
window.onPay = onPay;