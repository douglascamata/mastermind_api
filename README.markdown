# MastermindAPI

AxiomZen challenges for the VanHackathon.

Check https://en.wikipedia.org/wiki/Mastermind_(board_game)#Gameplay_and_rules
to know more about the game itself.

Games are stored in MongoDB.

# Setup instructions

First, setup your `TELEGRAM_BOT_TOKEN` environment var to the correct telegram
bot token using `dotenv`.

Install `docker` and `docker-compose`. Then run `docker-compose up` and be
happy! It will build and start all the necessary images for you.

# Telegram bot

There is a Telegram bot to play the game. The bot's name in production is
`@axiom_mastermind_bot`. This bot destroys the old game when the user starts
another to avoid unintentional database spamming.

Available commands are:
  - /startgame
  - /status
  - /guess <your_guess>

# Endpoints

## Start a new Mastermind game instance.

Endpoint: **POST /v1/game/start**

**Parameters:**

```
{
  "player": {
    "name": player_name
  }
}
```

**Example Response**

```
{
  "status_url": "/v1/game/574225e8c180560001d1695b",
  "play_url": "/v1/game/574225e8c180560001d1695b/player/574225e8c180560001d1695c"
}
```

## Join a Mastermind game instance.  

Endpoint: **POST /v1/game/:game_id/join**

**Parameters:**

```
{
  "player": {
    "name": player_name
  }
}
```

**Example Response**

```
{
  "status_url": "/v1/game/574225e8c180560001d1695b",
  "play_url": "/v1/game/574225e8c180560001d1695b/player/574225e8c180560001d2000a"
}
```

## Make a guess on a game instance

Endpoint: **POST /v1/game/:id/player/:player_id**

**Parameters**

```
{  
  "guess": {
    "guess": ["R", "R", "B", "P", "P", "C", "B", "C"]
  }
}
```

**Example Response**

```
{
  "colors": ["R", "B", "G", "Y", "O", "P", "C", "M"],
  "guess": ["R", "R", "B", "P", "P", "C", "B", "C"],
  "total_guesses": 1,
  "history": [
    {
      "guess": ["R", "R", "B", "P", "P", "C", "B", "C"],
      "exact": 0,
      "near": 0,
      "player": "Ned"
    }
  ],
  "exact": 0,
  "near": 0,
  "solved": false
}
```

## Get game information

Endpoint: **GET /v1/game/:id**

**Example Response**

```
{
  "colors": ["R", "B", "G", "Y", "O", "P", "C", "M"],
  "total_guesses": 1,
  "solved": true,
  "solver": "Ned",
  "guesses": [
    {
      "guess": ["R", "B", "G", "Y", "O", "P", "C", "M"],
      "player": "Ned"
    }
  ]
}
```
