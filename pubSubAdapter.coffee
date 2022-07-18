{ PubSub } = require "@google-cloud/pubsub"
{ grpc } = require "grpc"
fibrous = require "fibrous"
require("dotenv").config()

class PubSubAdapter
  constructor: (topicName, subscriptionName) ->
    topicName = process.env.topicName
    subscriptionName = process.env.subscriptionName
    @pubsub = new PubSub grpc, projectId: process.env.projectId
  
  publishMessage: (data) =>
    dataBuffer = Buffer.from(JSON.stringify data)
    try
      fibrous.run () =>
        pubSubClient = @pubsub.topic process.env.topicName
        message = pubSubClient.publishMessage {data: dataBuffer}
      , (err, rs) ->
        console.log "Message #{messageId} published with data ${data}"
    catch err
      console.error "Received error while publishing: #{error.message}"
      process.exitCode = 1
    
    listenForMessages: (timeout) =>
      messageCount = 0
      messageHandler = message ->
        console.log "Received message #{message.id}: "
        console.log "Data: #{message.data}"
        console.log "Attributes: #{message.attributes}"
        console.log "Received message:", JSON.parse message.data.toString()
        messageCount+=1
        # "Ack" (acknowledge receipt of) the message
        message.ack()
      
      subcription = @pubsub.subcription process.env.subscriptionName
      
      setTimeout () ->
        subcription.removeListener "message", messageHandler
        console.log "#{messageCount} message(s) received."
      , timeout * 1000
      

  
    