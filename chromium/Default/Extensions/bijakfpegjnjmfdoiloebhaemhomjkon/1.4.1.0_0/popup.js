(function(){chrome.extension.sendMessage({name:"get-background-states"},function(e){if(e.isCapturingFullPage===!0){$("#captureModes").hide(),$("#progress").show();return}var t=$("#captureVisiblePart"),n=$("#captureFullPage"),r=$("#captureFullPageContainer"),i=$("#captureVisiblePartHotkey"),s=$("#captureFullPageHotkey"),o=function(e){var t=[];return t.push(navigator.platform.indexOf("Mac")!==-1?"Cmd":"Ctrl"),e.altKey&&t.push("Alt"),e.shiftKey&&t.push("Shift"),t.push(String.fromCharCode(e.keyCode)),t.join(" + ")};i.text(o(e.captureVisiblePartKeyboardShortcut)),s.text(o(e.captureFullPageKeyboardShortcut)),t.on("click",function(e){e.preventDefault(),chrome.extension.sendMessage({name:"capture-visible-part"},function(e){})}),n.on("click",function(e){e.preventDefault(),$("#captureModes").hide(),$("#progress").show(),chrome.extension.sendMessage({name:"capture-full-page"},function(e){})}),e.canCaptureFullPage||r.hide()})})();