{ PubSub } = require "@google-cloud/pubsub"
grpc = require "grpc"
fibrous = require "fibrous"
require("dotenv").config()

class PubSubAdapter
  constructor: (@topicName, @subscriptionName, @projectId) ->
    @pubsub = new PubSub {grpc, projectId: @projectId}
  
  publishMessage: (data, callback) =>
    #data must be an object
    try
      dataBuffer = Buffer.from(JSON.stringify data)
      topic = @pubsub.topic @topicName
      messageId = topic.publishMessage {data: dataBuffer}
      return messageId
    catch err
      console.log err
      callback err, null
    
  listenForMessages: (timeout) =>
    try
      messageHandler = (message) ->
        console.log "Received message #{message.id}:"
        console.log "Data: #{message.data}"
        console.log "Received message: ", JSON.parse message.data.toString()
        message.ack()

      subscription = @pubsub.subscription @subscriptionName
      subscription.on "message", messageHandler
      setTimeout (->
        subscription.removeListener 'message', messageHandler
        return
      ), timeout * 1000
    catch err
      console.log err


      
module.exports = PubSubAdapter
  
    