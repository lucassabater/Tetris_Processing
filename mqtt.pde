import mqtt.*;

// TODO: Modify mqtt credentials for correct client broker conection
String MQTT_BROKER = "mqtt://tom.uib.es";
String MQTT_CLIENT_ID = "processing_mqtt_id"; // Change

MQTTClient client;

void initializeMQTT() {
  client = new MQTTClient(this);
  client.connect(MQTT_BROKER, MQTT_CLIENT_ID);
  client.subscribe("tetris/newPos");
  client.subscribe("tetris/newPiece");
  client.subscribe("tetris/score");
  client.subscribe("tetris/loose");
  client.subscribe("tetris/startUp");
  client.subscribe("tetris/hold");
}

void messageReceived(String topic, byte[] payload) {

  // Current Piece Movement
  if (topic.equals("tetris/newPos")) {
    if (payload.length == 16) {
      PVector[] nuevosPuntos = new PVector[4];

      int index = 0;
      for (int i = 0; i < 4; i++) {
        int x = ((payload[index] & 0xFF) << 8) | (payload[index+1] & 0xFF);
        int y = ((payload[index+2] & 0xFF) << 8) | (payload[index+3] & 0xFF);

        nuevosPuntos[i] = new PVector(x, y);

        index += 4;
      }
      activePiece.updatePositions(nuevosPuntos);
    }
    
  // NEXT PIECE  
  } else if (topic.equals("tetris/newPiece")) {
    int type = int(payload[0]);
    activePiece.setType(nextPieceType);
    nextPieceType = type;
  }
  
  // SCORE
  else if (topic.equals("tetris/score")) {
    score = (int(payload[0]) & 0xFF << 8) | int(payload[1]) & 0xFF;
  }

  // GAME OVER
  else if (topic.equals("tetris/loose")) {
    gameOver = true;

  // GAME START
  } else if (topic.equals("tetris/startup")) {
    onStartUp(payload);

  // HOLD PIECE
  } else if (topic.equals("tetris/hold")) {
    int type = int(payload[0]);
    activePiece.setType(holdPieceType);
    holdPieceType = type;
  }
}

void mqttReset() {
  client.publish("tetris/cmd", "RESET");
}
