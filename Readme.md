# Kafka Admin Rest API

Provides REST interface for admin operations with Kafka.

## Get Started

This project uses [Eta](http://eta-lang.org): Haskell compiled to JVM so it is possible
to use both Java and Haskell libraries.

To get up and running locally:

### Installing Eta
Install `eta`. Use your preferred method from [here](http://eta-lang.org/docs/html/getting-started.html#installing-eta)

### Building the project
Clone this project and run:
```
$ etlas update
$ etlas install --dependencies-only
$ etlas build
```

### Running the project locally
```
$ etlas run -- --bootstrap-broker="localhost:9092" --api-port=8080
```

Alternatively
```
$ ./run.sh
```

## Queries examples

### Create topics
```
curl -X POST http://localhost:9099/topics \
  -d '[
	{
		"topicName": "post-topic-1",
		"partitionsCount": 2,
		"replicationFactor": 1,
		"topicConfig": {}
	},
	{
		"topicName": "post-topic-2",
		"partitionsCount": 2,
		"replicationFactor": 1,
		"topicConfig": {}
	}
]'
```

### List topics
```
curl -X GET http://localhost:9099/topics
```

### Describe topics
```
curl -X GET 'http://localhost:9099/topics/describe?topics=post-topic-1&topics=post-topic-2'
```

### Delete topics
```
curl -X DELETE http://localhost:9099/topics
  -d '["post-topic-1", "post-topic-2"]'
```
