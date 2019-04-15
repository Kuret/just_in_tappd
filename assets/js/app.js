import LiveSocket from "phoenix_live_view"
import "phoenix_html"
import "foundation-sites"

$(document).foundation();
$(document).ready(function(){
  let liveSocket = new LiveSocket("/live")
  liveSocket.connect()

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

