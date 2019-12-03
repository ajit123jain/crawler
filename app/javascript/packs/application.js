require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap/dist/js/bootstrap")
require("jquery") // Don't really need to require this...
require('jquery-validation');
global.$ = $;
global.jQuery = jQuery;
//= require jquery.validate