var chat_window = document.getElementById('chat');
var btn_start = document.getElementById('btn_start');
var searching_text = document.getElementById('searching_text');
var btn_submit = document.getElementById('btn_submit');
var input_message = document.getElementById('input_message');

var messages = document.getElementById('messages');
var message_template = document.getElementById('message_template');

var host = window.location.host;
var ws;
var room_id = null;

var translations = [];

// example: printMessage("left", "someText", false)
// right: who send
function printMessage(side, text, is_leave) {
    var node = message_template.cloneNode(true);
    node.removeAttribute("id");
    node.style.display = "block";

    node.children[0].classList.add(side); //img
    node.children[1].classList.add(side); //text wrapper
    node.children[1].children[0].textContent = text; // text

    if(side == "left" && !is_leave) {
      node.children[1].children[1].style.display = "inline-block"; // btn_translate
      node.children[1].children[2].style.display = "inline-block"; // langs
      node.children[1].children[1].onclick = function() {
          this.style.display = "none";
          this.parentElement.children[2].style.display = "none";
          translations.push(this.parentElement.children[3]); // translated
          sendMessage(
            this.parentElement.children[0].textContent,
            true,
            this.parentElement.children[2].value 
          );
      };
    }

    if(is_leave) {
        node.children[1].children[0].style.textShadow = "0px 0px 5px rgb(0, 0, 0)";
        node.children[1].children[0].style.color = "white";
    }

    messages.appendChild(node);
    messages.scrollTop = messages.scrollHeight;
}

btn_start.onclick = function() {

    btn_start.style.display = 'none';
    searching_text.style.display = 'block';

    var wsType = "";
    if(host != "0.0.0.0:8080")
      wsType = "wss";
    else
      wsType = "ws";

    ws = new WebSocket(wsType + "://" + host + "/ws");

    ws.onmessage = function(event) {
        var msg = JSON.parse(event.data);

        if(room_id == null) {
            room_id = msg.roomId;
            searching_text.style.display = 'none';
            chat.style.filter = 'blur(0px)';
            btn_submit.classList.remove("disabled");
            input_message.classList.remove("disabled");
        } else {
            if(msg.translate) {
                var t = translations.pop();
                t.textContent = msg.text;
                t.style.display = "inline-block";
            } else {
                if(msg.isSender)
                    printMessage("right", msg.text, false);
                else
                    printMessage("left", msg.text, msg.isLeave);
            }
        }
    }

    ws.onopen = function(event) {
        console.log("Connected");
    }

    ws.onclose = function(event) {
      console.log("disconnected");
      if(roomId != null)
          ws = new WebSocket(wsType + "://" + host + "/ws");
    }
};

// sendMessage("someText", false)
function sendMessage(text, isForTranslate = false, transTo = "en") {
    var msg = {
        roomId: room_id,
        msg: text,
        translate: isForTranslate,
        lang: transTo
    }

    ws.send(JSON.stringify(msg));
}

btn_submit.onclick = function() {
    sendMessage(input_message.value);
    input_message.value = "";
};

input_message.onkeypress = function (e) {
    if(e.which == 13) {
        sendMessage(input_message.value);
        input_message.value = "";
    }
};
