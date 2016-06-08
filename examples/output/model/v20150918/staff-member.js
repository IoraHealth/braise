// DO NOT EDIT - this file was autogenerated by Braise
import DS from 'ember-data';

export default DS.Model.extend({
  default_location: DS.attr(),
  degree: DS.attr("string"),
  first_name: DS.attr("string"),
  last_name: DS.attr("string"),
  photos: DS.attr(),
  role: DS.attr("string"),
  speciality: DS.attr(),
  suffix: DS.attr("string"),
  uid: DS.attr("string"),

  create: function() {
    throw new Error("'create' is not supported by the api");
  },
  update: function() {
    throw new Error("'update' is not supported by the api");
  },
  delete: function() {
    throw new Error("'delete' is not supported by the api");
  },


});
