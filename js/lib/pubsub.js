/**
 * Created by Maxim Denisov (denisovmax1988@yandex.ru)
 * Date: 9/30/13
 * Time: 7:56 PM
 */

define(function(require, exports, module) {
    "use strict";

    // External dependencies.
    var Backbone = require("backbone");

    var PubSub = _.extend({}, Backbone.Events);

    PubSub.attach = function(events, context) {
        _.each(events, _.bind(function(callback, eventName){
            this.on(eventName, callback, context);
        }, this));
    };

    PubSub.unattach = function(events, context) {
        _.each(events, _.bind(function(callback, eventName){
            this.off(eventName, callback, context);
        }, this));
    };

    var origTrigger = PubSub.trigger;
    PubSub.trigger = function(events) {
        try {
            origTrigger.apply(PubSub, arguments);
        } catch (ex) {
            window.console.error('PubSub trigger "' + events + '" threw exception: ',
                (ex.stack || ex.stacktrace || ex.message));
        }
        return PubSub;
    };

    module.exports = PubSub
});