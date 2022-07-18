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


fibrous.run () ->
  pubsub = new PubSubAdapter process.env.topicName, process.env.subscriptionName, process.env.projectId
  pubsub.publishMessage data
  pubsub.sync.listenForMessages 10
, (err, result) ->
  console.log err
  console.log result
  