import "phoenix_html"

import $ from "jquery"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(document).ready(function(){
  let infoAlert = $('.alert.alert-info')
  let errorAlert = $('.alert.alert-danger')

  if(infoAlert.text()){
    //M.toast({html: infoAlert.text(), classes: "teal"})
    //infoAlert.remove()
  }

  if(errorAlert.text()){
    //M.toast({html: errorAlert.text(), classes: "red"})
    //errorAlert.remove()
  }
})

