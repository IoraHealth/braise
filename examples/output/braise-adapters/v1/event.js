// DO NOT EDIT - this file was autogenerated by Braise
import DS from 'ember-data';
import Ember from 'ember';

const { RESTAdapter } = DS;
const { computed, String: EmberString } = Ember; // eslint-disable-line no-unused-vars

export default RESTAdapter.extend({
  host: "https://production.icisapp.com",
  namespace: "api/v1",
  token: computed.alias('accessTokenWrapper.token'),

  // Prevent CORS preflight requests for GET requests
  headersForRequest(params) {
    const headers = this._super(params);
    const method = this.methodForRequest(params);

    if (method !== 'GET') {
      headers['Authorization'] = `Bearer ${this.get('token')}`; // eslint-disable-line dot-notation
    }
    return headers;
  },

  dataForRequest(params) {
    const data = this._super(params);
    const method = this.methodForRequest(params);

    if (method === 'GET') {
      data.access_token = data.access_token || this.get('token'); // eslint-disable-line camelcase
    }

    return data;
  },

  cancel(modelName, id, snapshot) {
    const url = `${this.buildURL(modelName, id)}/cancel`;
    return this.ajax(url, 'PUT', { data: snapshot });
  }
});
