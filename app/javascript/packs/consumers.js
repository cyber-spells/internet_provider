let previous_action;
document.addEventListener('turbolinks:load', () => {
    previous_action = document.getElementById('consumer_info');
})

function change_consumer_action(action) {
    previous_action.hidden = true;
    previous_action = document.getElementById(`consumer_${action}`);
    previous_action.hidden = false;
}

window.change_consumer_action = change_consumer_action;