PubSubAdapter = require "./pubSubAdapter.coffee"
require("dotenv").config()
fibrous = require "fibrous"

pubsub = new PubSubAdapter process.env.topicName, process.env.subscriptionName, process.env.projectId

data =
  product_name: "thịt chó 3",
  image_url: "url",
  landing_page_url: "landing_page_url",
  category: "thit cho",
  price: 10000,
  status: 1,
  product_id: "1000",
  portal_id: 1,


fibrous.run () ->
  pubsub.sync.publishMessage data
, (err, result) ->
  console.log "err: ", err
  console.log "result: ", result
