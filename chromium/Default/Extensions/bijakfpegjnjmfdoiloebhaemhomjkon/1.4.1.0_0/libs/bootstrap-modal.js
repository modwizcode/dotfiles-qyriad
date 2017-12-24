!function(e){"use strict";var t=function(e,t){this.init(e,t)};t.prototype={constructor:t,init:function(t,n){this.options=n,this.$element=e(t).delegate('[data-dismiss="modal"]',"click.dismiss.modal",e.proxy(this.hide,this)),this.options.remote&&this.$element.find(".modal-body").load(this.options.remote);var r=typeof this.options.manager=="function"?this.options.manager.call(this):this.options.manager;r=r.appendModal?r:e(r).modalmanager().data("modalmanager"),r.appendModal(this)},toggle:function(){return this[this.isShown?"hide":"show"]()},show:function(){var t=this,n=e.Event("show");if(this.isShown)return;this.$element.triggerHandler(n);if(n.isDefaultPrevented())return;if(this.options.width){this.$element.css("width",this.options.width);var t=this;this.$element.css("margin-left",function(){return/%/ig.test(t.options.width)?-(parseInt(t.options.width)/2)+"%":-(e(this).width()/2)+"px"})}var r=this.options.height?"height":"max-height",i=this.options.height||this.options.maxHeight;i&&this.$element.find(".modal-body").css("overflow","auto").css(r,i),this.escape(),this.tab(),this.options.loading&&this.loading()},hide:function(t){t&&t.preventDefault(),t=e.Event("hide"),this.$element.triggerHandler(t);if(!this.isShown||t.isDefaultPrevented())return this.isShown=!1;this.isShown=!1,this.escape(),this.tab(),this.isLoading&&this.loading(),e(document).off("focusin.modal"),this.$element.removeClass("in").removeClass("animated").removeClass(this.options.attentionAnimation).removeClass("modal-overflow").attr("aria-hidden",!0),e.support.transition&&this.$element.hasClass("fade")?this.hideWithTransition():this.hideModal()},tab:function(){var t=this;this.isShown&&this.options.consumeTab?this.$element.on("keydown.tabindex.modal","[data-tabindex]",function(n){if(n.keyCode&&n.keyCode==9){var r=e(this),i=e(this);t.$element.find("[data-tabindex]:enabled:not([readonly])").each(function(t){t.shiftKey?r=r.data("tabindex")>e(this).data("tabindex")?r=e(this):i=e(this):r=r.data("tabindex")<e(this).data("tabindex")?r=e(this):i=e(this)}),r[0]!==e(this)[0]?r.focus():i.focus(),n.preventDefault()}}):this.isShown||this.$element.off("keydown.tabindex.modal")},escape:function(){var e=this;this.isShown&&this.options.keyboard?(this.$element.attr("tabindex")||this.$element.attr("tabindex",-1),this.$element.on("keyup.dismiss.modal",function(t){t.which==27&&e.hide()})):this.isShown||this.$element.off("keyup.dismiss.modal")},hideWithTransition:function(){var t=this,n=setTimeout(function(){t.$element.off(e.support.transition.end),t.hideModal()},500);this.$element.one(e.support.transition.end,function(){clearTimeout(n),t.hideModal()})},hideModal:function(){this.$element.hide().triggerHandler("hidden");var e=this.options.height?"height":"max-height",t=this.options.height||this.options.maxHeight;t&&this.$element.find(".modal-body").css("overflow","").css(e,"")},removeLoading:function(){this.$loading.remove(),this.$loading=null,this.isLoading=!1},loading:function(t){t=t||function(){};var n=this.$element.hasClass("fade")?"fade":"";if(!this.isLoading){var r=e.support.transition&&n;this.$loading=e('<div class="loading-mask '+n+'">').append(this.options.spinner).appendTo(this.$element),r&&this.$loading[0].offsetWidth,this.$loading.addClass("in"),this.isLoading=!0,r?this.$loading.one(e.support.transition.end,t):t()}else if(this.isLoading&&this.$loading){this.$loading.removeClass("in");var i=this;e.support.transition&&this.$element.hasClass("fade")?this.$loading.one(e.support.transition.end,function(){i.removeLoading()}):i.removeLoading()}else t&&t(this.isLoading)},focus:function(){var e=this.$element.find(this.options.focusOn);e=e.length?e:this.$element,e.focus()},attention:function(){if(this.options.attentionAnimation){this.$element.removeClass("animated").removeClass(this.options.attentionAnimation);var e=this;setTimeout(function(){e.$element.addClass("animated").addClass(e.options.attentionAnimation)},0)}this.focus()},destroy:function(){var t=e.Event("destroy");this.$element.triggerHandler(t);if(t.isDefaultPrevented())return;this.teardown()},teardown:function(){if(!this.$parent.length){this.$element.remove(),this.$element=null;return}this.$parent!==this.$element.parent()&&this.$element.appendTo(this.$parent),this.$element.off(".modal"),this.$element.removeData("modal"),this.$element.removeClass("in").attr("aria-hidden",!0)}},e.fn.modal=function(n){return this.each(function(){var r=e(this),i=r.data("modal"),s=e.extend({},e.fn.modal.defaults,r.data(),typeof n=="object"&&n);i||r.data("modal",i=new t(this,s)),typeof n=="string"?i[n]():s.show&&i.show()})},e.fn.modal.defaults={keyboard:!0,backdrop:!0,loading:!1,show:!0,width:null,height:null,maxHeight:null,modalOverflow:!1,consumeTab:!0,focusOn:null,attentionAnimation:"shake",manager:"body",spinner:'<div class="loading-spinner" style="width: 200px; margin-left: -100px;"><div class="progress progress-striped active"><div class="bar" style="width: 100%;"></div></div></div>'},e.fn.modal.Constructor=t,e(function(){e(document).off(".modal").on("click.modal.data-api",'[data-toggle="modal"]',function(t){var n=e(this),r=n.attr("href"),i=e(n.attr("data-target")||r&&r.replace(/.*(?=#[^\s]+$)/,"")),s=i.data("modal")?"toggle":e.extend({remote:!/#/.test(r)&&r},i.data(),n.data());t.preventDefault(),i.modal(s).one("hide",function(){n.focus()})})})}(window.jQuery);