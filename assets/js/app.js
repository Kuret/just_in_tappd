// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import 'materialize-css'

import $ from "jquery"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

$(document).ready(function(){
  let infoAlert = $('.alert.alert-info')
  let errorAlert = $('.alert.alert-danger')

  if(infoAlert.text()){
    M.toast({html: infoAlert.text(), classes: "teal"})
    infoAlert.remove()
  }

  if(errorAlert.text()){
    M.toast({html: errorAlert.text(), classes: "red"})
    errorAlert.remove()
  }
})

