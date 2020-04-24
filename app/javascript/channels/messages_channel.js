import consumer from "./consumer"


consumer.subscriptions.create("MessagesChannel", {
  
	connected: function() {
      var roomId;
      roomId = $("#chat-box").data("room-id");
				console.log(roomId)
      return this.checkIn(roomId);
    },
    disconnected: function() {},
    received: function(data) {
			console.log(data)
      var posts;
      posts = $(".message-row").length;
      if (posts === 10) {
        $(".message-row").first().remove();
      }
      $("#chat-box").prepend(data.message);
			console.log($("#chat-box").append( data ))
       $("#message-field").val('');
    },
    checkIn: function(roomId) {
      if (roomId) {
        return this.perform('checkIn', {
          room_id: roomId
        });
      } else {
        return this.perform('checkOut');
      }
    }

});

var submit_messages;

$(document).on('turbolinks:load', function(){

	submit_messages()
	console.log('yes we hitted the enter')
})



submit_messages = function() {
	$('#message-field').on('keydown', function(event){

		if(event.keyCode === 13){
			event.preventDefault()
			$('#post-btn').click()
			event.target.val = ""
			
			console.log('yes we hitted the enter and function called')
		}
	})
}