PubSubAdapter = require "./pubSubAdapter.coffee"
require("dotenv").config()
fibrous = require "fibrous"
grpc = require "grpc"

data =
  product_name: "thịt chó 1",
  image_url: "url",
  landing_page_url: "landing_page_url",
  category: "thit cho",
  price: 10000,
  status: 1,
  product_id: "1000",
  portal_id: 1,

onMessages = (message) ->
  console.log "message.id: ", message.id
  console.log "message.data: ", JSON.parse message.data.toString()
  message.ack()

pubsub = new PubSubAdapter process.env.topicName, process.env.subscriptionName, process.env.projectId

# fibrous.run () ->
#   pubsub.sync.publishMessage data
# , (err, result) ->
#   console.log "err: ", err
#   console.log "result: ", result

pubsub.listenForMessages onMessages

module.exports =
  pubsub: pubsub
  onMessages: onMessages

setTimeout (->
  pubsub.removeListeners onMessages
  return
), 60 * 1000


