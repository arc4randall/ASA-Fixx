/**
 * Cross-platform Webtrends Mobile Application Library
 * Copyright (c) 1996-2013 Webtrends Inc
 * All rights reserved
 *
 */
function WebtrendsMobileLib() {
	var self = this;
	this.onApplicationStart = function(appName, customData) {
		return wrapFunction("onApplicationStart", arguments);
	};

	this.onApplicationError = function(appName, customData) {
		return wrapFunction("onApplicationError", arguments);
	};

	this.onApplicationTerminate = function(appName, customData) {
		return wrapFunction("onApplicationTerminate", arguments);
	};

	this.onActivityStart = function(activityName, customData) {
		return wrapFunction("onActivityStart", arguments);
	};

	this.onActivityEnd = function(activityName, customData) {
		return wrapFunction("onActivityEnd", arguments);
	};

	this.onApplicationBackground = function(appName, customData) {
		return wrapFunction("onApplicationBackground", arguments);
	};

	this.onApplicationForeground = function(appName, customData) {
		return wrapFunction("onApplicationForeground", arguments);
	};

	this.onApplicationNotify = function(appName, customData) {
		return wrapFunction("onApplicationNotify", arguments);
	};

	this.onAdClickEvent = function(eventPath, eventDesc, eventType, customData, adName) {
		return wrapFunction("onAdClickEvent", arguments);
	};

	this.onAdImpressionEvent = function(eventPath, eventDesc, eventType, customData, adNames) {
		return wrapFunction("onAdImpressionEvent", arguments);
	};

	this.onButtonClick = function(eventPath, eventDesc, eventType, customData) {
		return wrapFunction("onButtonClick", arguments);
	};

	this.onConversionEvent = function(eventPath, eventDesc, eventType,
			customData, contentGroup, conversionName) {
		return wrapFunction("onConversionEvent", arguments);
	};

	this.onCustomEvent = function(eventPath, eventDesc, customData) {
		return wrapFunction("onCustomEvent", arguments);
	};

	this.onMediaEvent = function(eventPath, eventDesc, eventType, customData,
            contentGroup, mediaName, mediaType, mediaEventType) {
		return wrapFunction("onMediaEvent", arguments);
	};

	this.onProductView = function(eventPath, eventDesc, eventType, customData,
            contentGroup, productId, productSku) {
		return wrapFunction("onProductView", arguments);
	};

	this.onContentView = function(eventPath, eventDesc, eventType, customData, contentGroup) {
		return wrapFunction("onContentView", arguments);
	};

	this.onScreenView = function(eventPath, eventDesc, eventType, customData, contentGroup) {
		return wrapFunction("onScreenView", arguments);
	};

	this.onSearchEvent = function(eventPath, eventDesc, eventType, customData, searchPhrase, searchResult) {
		return wrapFunction("onSearchEvent", arguments);
	};
    
	function wrapFunction(funcName, args) {
		
		var arr = new Array();
		for ( var i = 0; i < args.length; i++) {
			arr[i] = args[i];
		}
		
		var data = (JSON && JSON.stringify) ? JSON.stringify([funcName, arr]) : stringify([funcName, arr]);
		var WTRequest = "wtdc://" + Math.random() + "?" + data;

		if (typeof window.external != 'undefined' && typeof window.external.Notify != 'undefined') {
		    window.external.Notify(WTRequest);
		}
		else {
			var WTGateway = document.createElement('iframe');
			WTGateway.setAttribute('src', WTRequest);
			WTGateway.setAttribute('style', 'display:none;');
			WTGateway.setAttribute('frameborder', '0');
			WTGateway.setAttribute('height', '0px');
			WTGateway.setAttribute('width', '0px');
			document.getElementsByTagName('body')[0].appendChild(WTGateway);
			WTGateway.parentNode.removeChild(WTGateway);
			WTGateway = null;
		}
	}

	function stringify(args) {
		if (typeof JSON === "undefined") {
			var s = "[";
			var i, type, start, name, nameType, a;
			for (i = 0; i < args.length; i++) {
				if (args[i] !== null) {
					if (i > 0) {
						s = s + ",";
					}
					type = typeof args[i];
					if ((type === "number") || (type === "boolean")) {
						s = s + args[i];
					} else if (args[i] instanceof Array) {
						s = s + "[" + args[i] + "]";
					} else if (args[i] instanceof Object) {
						start = true;
						s = s + '{';
						for (name in args[i]) {
							if (args[i][name] !== null) {
								if (!start) {
									s = s + ',';
								}
								s = s + '"' + name + '":';
								nameType = typeof args[i][name];
								if ((nameType === "number")
										|| (nameType === "boolean")) {
									s = s + args[i][name];
								} else if ((typeof args[i][name]) === 'function') {
									// don't copy the functions
									s = s + '""';
								} else if (args[i][name] instanceof Object) {
									s = s + PhoneGap.stringify(args[i][name]);
								} else {
									s = s + '"' + args[i][name] + '"';
								}
								start = false;
							}
						}
						s = s + '}';
					} else {
						a = args[i].replace(/\\/g, '\\\\');
						a = a.replace(/"/g, '\\"');
						s = s + '"' + a + '"';
					}
				}
			}
			s = s + "]";
			return s;
		} else {
			return JSON.stringify(args);
		}
	}
};

var webtrendsLib = new WebtrendsMobileLib();
