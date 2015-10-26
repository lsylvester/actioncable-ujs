#= require cable

consumer = null

setupConnection = ->
  consumer = Cable.createConsumer $('meta[name=cable-uri]').attr('value')

setupSubscriptions = ->
  for subscription in consumer.subscriptions.subscriptions
    if subscription.element and !$.contains(document, subscription.element)
      subscription.unsubscribe()

  for element in $('[data-cable-subscribe]')
    element.subscription ||= consumer.subscriptions.create $(element).data('cable-subscribe'),
      element: element,

      received: (data)->
        $(element).trigger("cable:received", data)

      connected: ->
        $(element).trigger("cable:connected")

$(document).ready setupConnection
$(document).on "page:change", setupSubscriptions