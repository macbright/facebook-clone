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
      $("#chat-box").append(chat_div(data.message));
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
var chat_div;

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

chat_div = function(data){

	return `
		<div class="message-row">
				<p class="message-body">${data.body}</p>
					<span> <a href="/users/show.${data.user_id}">
					<img src="${data.avatar}">
					</a><small> <a href="/users/show.${data.user_id}">${data.name}</a></small>
			</span> 
		</div>
		<hr/>
		<br />
	`;
}



