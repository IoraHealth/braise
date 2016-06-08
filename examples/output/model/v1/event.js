// DO NOT EDIT - this file was autogenerated by Braise
import DS from 'ember-data';

export default DS.Model.extend({
  attendees: DS.attr(),
  categories: DS.attr(),
  description: DS.attr("string"),
  end_time: DS.attr("date"),
  event_type: DS.attr("string"),
  location: DS.attr(),
  start_time: DS.attr("date"),
  status: DS.attr("string"),
  title: DS.attr("string"),
  uid: DS.attr("string"),

  show: function() {
    throw new Error("'show' is not supported by the api");
  },
  delete: function() {
    throw new Error("'delete' is not supported by the api");
  },

  cancel: function() {
    var _this = this;
    var modelName = this.constructor.modelName;
    var adapter = this.store.adapterFor(modelName);
    return adapter.cancel(modelName, this.get('id'), arguments).then(function(response) {
      var serializer = _this.store.serializerFor(modelName);
      var payloadKey = serializer.payloadKeyFromModelName(modelName);
      var payload = response[payloadKey];
      _this.setProperties(payload);
    });
  },

});
