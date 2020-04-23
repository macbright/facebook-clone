import consumer from "./consumer"


consumer.subscriptions.create("MessagesChannel", {
  
	connected() {
      var roomId;
      roomId = $("#chat-box").data("room-id");
      this.checkIn(roomId);
    },
    disconnected() {},
    received(data) {
			console.log(data)
      const posts = $(".message-row").length;
			console.log(posts)
      if (posts === 10) {
        $(".message-row").first().remove();
      }
      $("#chat-box").append(data);
      $("#message-field").val('');
    },
    checkIn(roomId) {
      if (roomId) {
        this.perform('checkIn', {
          room_id: roomId
        });
      } else {
        this.perform('checkOut');
      }
    }

});
