NotificationPlugin = require "../../notification-plugin"

class Obeya extends NotificationPlugin
  @getListId: (config, callback) ->
    @request
      .get("https://obeya.co/rest/1/#{config?.orgId}/")

module.exports = Obeya
