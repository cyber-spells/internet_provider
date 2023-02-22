// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import anime from 'animejs/lib/anime.es.js'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import * as bootstrap from "bootstrap"

import "../stylesheets/application"

import "./consumers"

window.Rails = Rails;

document.addEventListener("turbolinks:load", ()=>{
    randomValues();
    
})

function randomValues() {
    anime({
      targets: '.square, .circle, .triangle',
      translateX: function() {
        return anime.random(-500, 500);
      },
          translateY: function() {
        return anime.random(-300, 300);
      },
          rotate: function() {
              return anime.random(0, 360);
          },
          scale: function() {
              return anime.random(.2, 2);
          },
      duration: 1000,
          easing: 'easeInOutQuad',
      complete: randomValues,
      });
  }

  