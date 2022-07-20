{ PubSub } = require "@google-cloud/pubsub"
grpc = require "grpc"
fibrous = require "fibrous"
require("dotenv").config()

publishMessages = (topic, message, callback) ->
  promise = topic.publishMessage (message)
  promise.then((messageId) -> callback null, messageId).catch((error) ->callback error, null)

class PubSubAdapter
  constructor: (@topicName, @subscriptionName, @projectId) ->
    @pubsub = new PubSub {grpc, projectId: @projectId}
    @topic = @pubsub.topic @topicName
    @subscription = @pubsub.subscription @subscriptionName
    
  
  publishMessage: (data, callback) =>
    #data must be an object
    try
      dataBuffer = Buffer.from(JSON.stringify data)
      fibrous.run () =>
        messageId = publishMessages.sync @topic, {data: dataBuffer}
        return messageId
      , (err, messageId) ->
        if err? then callback err, null
        else
          console.log messageId
          callback null, messageId
    catch err
      console.log "err: ", err
      callback err, null
  
  listenForMessages: (messageHandler) =>
    try
      # subscription = @pubsub.subscription @subscriptionName
      @subscription.on "message", messageHandler
      # callback message
    catch err
      console.log err

  removeListeners: (messageHandler) =>
    try
      @subscription.removeListener "message", messageHandler
    catch err
      console.log err

      
module.exports = PubSubAdapter