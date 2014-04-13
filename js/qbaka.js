window.qbaka || (function (window, document) {
    var _ = [];
    var qbaka = window.qbaka = function () {
    _.push(arguments);
    };
window.__qbaka_eh = window.onerror;
window.onerror = function () {
    qbaka('onerror', arguments);
    if (window.__qbaka_eh) try {
    window.__qbaka_eh.apply(window, arguments)
    } catch (b) {
    }
};
window.onerror.qbaka = 1;
qbaka.sv = 2;
qbaka._ = _;
qbaka.log = function () {
    qbaka('log', arguments);
    };
qbaka.report = function () {
    qbaka('report', arguments, new Error());
    };
var script = document.createElement("script"), thisScript = document.getElementsByTagName("script")[0], appendScript = function () {
    thisScript.parentNode.insertBefore(script, thisScript)
    };
script.type = "text/javascript";
script.async = !0;
script.src = ('https:' == document.location.protocol ? 'https:' : 'http:') + '//cdn.qbaka.net/reporting.js';
typeof script.async == 'undefined' && document.addEventListener ? document.addEventListener("DOMContentLoaded", appendScript) : appendScript();
qbaka.key = "56011231c24dd9e2b69533009e84177f";
})(window, document);

qbaka.options = {
    autoStacktrace: true,
    trackEvents: true
    };
