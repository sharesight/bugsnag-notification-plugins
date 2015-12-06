NotificationPlugin = require "../../notification-plugin"

class Obeya extends NotificationPlugin
  BASE_URL = "https://beta.getobeya.com/rest/1"

  @openIssue: (config, event, callback) ->

    data =
      "name":          "#{event.error.exceptionClass} in #{event.error.context}"
      "bin_id":        "#{config?.binId}"
      "ticketType_id": "#{config?.ticketTypeId}"
      "description":   "#{event.error.message}. Stacktrace: #{event.error.stacktrace}. Url: #{event.error.url}"


    @request
      .get("#{BASE_URL}/#{config?.orgId}/ids?amount=1")
      .auth(config.username, config.password)
      .send(data)
      .timeout(4000)
      .on("error", callback)
      .end (res) =>

        return callback(res.error) if res.error
        ticketId = res.body[0]

        @request
          .post("#{BASE_URL}/#{config?.orgId}/tickets/#{ticketId}")
          .auth(config.username, config.password)
          .send(data)
          .timeout(4000)
          .on("error", callback)
          .end (r) ->
            return callback(r.error) if r.error
            callback null, r.body

  @receiveEvent: (config, event, callback) ->

    if event?.trigger?.type == "linkExistingIssue"
      return callback(null, null)

    @openIssue(config, event, callback)

module.exports = Obeya