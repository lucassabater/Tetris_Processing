import mqtt.*;

public static final String MQTT_BROKER = "mqtt://localhost";
public static final String MQTT_CLIENT_ID = "tetris_processing";

private MQTTClient client;

void initializeMQTT() {
  client = new MQTTClient(this); //<>//
  client.connect(MQTT_BROKER, MQTT_CLIENT_ID); //<>//
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
    if (payload.length != 16) return;

    loadPieceData(0, payload, activePiece.currentPositions);
    
  // NEXT PIECE  
  } else if (topic.equals("tetris/newPiece")) {
    for (int i = 0; i < activePiece.currentPositions.length; i++) {
      PVector pos = activePiece.currentPositions[i];
      grid[(int)pos.x][(int)pos.y] = activePiece.type;
    }

    activePiece = new ActivePiece(nextPieceType);
    loadPieceData(1, payload, activePiece.currentPositions);
    nextPieceType = payload[0];
  }
  
  // SCORE
  else if (topic.equals("tetris/score")) {
    score = (int(payload[0]) & 0xFF << 8) | int(payload[1]) & 0xFF;
  }

  // GAME OVER
  else if (topic.equals("tetris/loose")) {
    gameOver = true;

  // GAME START
  } else if (topic.equals("tetris/startUp")) {
    onStartUp(payload);

  // HOLD PIECE
  } else if (topic.equals("tetris/hold")) {
    activePiece.type = holdPieceType;
    holdPieceType = int(payload[0]);
  }
}

void mqttReset() {
  client.publish("tetris/cmd", "RESET");
}

private void loadPieceData(int index, byte[] payload, PVector[] positions) {
  for (int i = 0; i < 4; i++) {
    int x = ((payload[index] & 0xFF) << 8) | (payload[index + 1] & 0xFF);
    int y = ((payload[index + 2] & 0xFF) << 8) | (payload[index + 3] & 0xFF);
    positions[i] = new PVector(x, y);
    index += 4;
  }
}
