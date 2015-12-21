import DS from 'ember-data';

export default Practice = DS.Model.extend({
  locations: DS.attr(),
  name: DS.attr("string"),
  uid: DS.attr("string")
});
