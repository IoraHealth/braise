import DS from 'ember-data';

export default State_of_health = DS.Model.extend({
  created_at: DS.attr("date"),
  value: DS.attr("number")
});
