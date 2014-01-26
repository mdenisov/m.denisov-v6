// Generated by CoffeeScript 1.6.3
define(function(require, exports, module) {
  "use strict";
  var $, Backbone, PubSub, app, _;
  _ = require("underscore");
  $ = require("jquery");
  Backbone = require("backbone");
  app = require("app");
  PubSub = require("pubsub");
  return Backbone.View.extend({
    el: '.portfolio__item',
    slider: {
      curr: 1,
      count: 0,
      $el: {},
      $slides: {},
      nav: {
        $el: {},
        $prev: {},
        $curr: {},
        $next: {}
      }
    },
    $sidebar: {},
    $comments: {},
    imgStretch: false,
    timer1: null,
    timer2: null,
    startCoords: {},
    endCoords: {},
    events: {
      'click .portfolio__nav': 'onSliderNavClick',
      'click .portfolio__social__item': 'onSocialLinkClick',
      'click #submit': 'onCommentPost',
      'click .comment-reply-link': 'onCommentReplyClick',
      'click #cancel-comment-reply-link': 'onCommentReplyClick',
      'submit form.comment-form': 'onCommentPost',
      'click .portfolio__info': 'showSidebar',
      'click .portfolio__sidebar__close': 'hideSidebar',
      'mousemove .portfolio__slider': 'onMouseMove',
      'touchstart .portfolio__slider': 'onTouchStart',
      'touchmove .portfolio__slider': 'onTouchMove',
      'touchend .portfolio__slider': 'onTouchEnd'
    },
    initialize: function() {
      var _this = this;
      this.pubSub = {
        'app:preloaded': this.resize,
        'app:keydown': this.onKeyDown,
        'app:resize': this.resize
      };
      PubSub.attach(this.pubSub, this);
      this.$el = $(this.el);
      this.slider.$el = this.$el.find('.portfolio__slider');
      this.$sidebar = this.$el.find('.portfolio__sidebar');
      this.slider.nav.$el = this.$el.find('.portfolio__nav');
      this.$comments = this.$el.find('.portfolio__comments');
      this.$info = this.$el.find('.portfolio__info');
      this.$close = this.$sidebar.find('.portfolio__sidebar__close');
      this.$comments.find('form').prepend('<div class="portfolio__comment-status" ></div>');
      this.commentStatus = this.$comments.find('.portfolio__comment-status');
      this.postId = this.$el.data('post-id');
      app.$body.addClass('fixed');
      this.doSlider();
      this.doNav();
      this.showSidebar();
      this.timer1 = setTimeout(function() {
        clearTimeout(_this.timer1);
        app.$body.addClass('hidden');
        return _this.hideSidebar();
      }, 3000);
      return this;
    },
    destroy: function() {
      clearTimeout(this.timer1);
      clearTimeout(this.timer2);
      app.$body.removeClass('hidden').removeClass('fixed');
      PubSub.unattach(this.pubSub, this);
      this.stopListening();
      this.undelegateEvents();
      this.$el.removeData().unbind();
      return Backbone.View.prototype.remove.call(this);
    },
    doSlider: function() {
      this.slider.$slides = this.slider.$el.find('.portfolio__slider__item');
      this.slider.count = this.slider.$slides.length;
      return this.updateSlider();
    },
    updateSlider: function() {
      return this.slider.$slides.removeClass('portfolio__slider__item--curr').eq(this.slider.curr - 1).addClass('portfolio__slider__item--curr');
    },
    doNav: function() {
      this.slider.nav.$prev = this.slider.nav.$el.filter('.portfolio__nav--prev');
      this.slider.nav.$next = this.slider.nav.$el.filter('.portfolio__nav--next');
      return this.updateNav();
    },
    updateNav: function() {
      if (this.slider.curr === 1) {
        this.slider.nav.$prev.addClass('portfolio__nav--hidden');
      } else {
        this.slider.nav.$prev.removeClass('portfolio__nav--hidden');
      }
      if (this.slider.curr === this.slider.count) {
        return this.slider.nav.$next.addClass('portfolio__nav--hidden');
      } else {
        return this.slider.nav.$next.removeClass('portfolio__nav--hidden');
      }
    },
    resize: function() {
      var $img, $slide, $slides, imgH, imgLeft, imgRatio, imgTop, imgW, item, winH, winRatio, winW, _i, _len, _results;
      $slides = this.slider.$slides;
      winW = app.$window.width();
      winH = app.$window.height() - 140;
      winRatio = winW / winH;
      if ($slides.length > 0) {
        _results = [];
        for (_i = 0, _len = $slides.length; _i < _len; _i++) {
          item = $slides[_i];
          $slide = $(item);
          $img = $slide.children('img');
          imgW = $img.width();
          imgH = $img.height();
          imgRatio = imgW / imgH;
          imgLeft = 0;
          imgTop = 0;
          if (this.imgStretch === true) {
            if (winRatio > imgRatio) {
              imgW = parseInt(winW, 10);
              imgH = parseInt(imgW / imgRatio, 10);
            } else {
              imgH = winH;
              imgW = parseInt(imgH * imgRatio, 10);
            }
          } else {
            if (winRatio > imgRatio) {
              imgH = parseInt(winH, 10);
              imgW = parseInt(imgH * imgRatio, 10);
            } else {
              imgW = winW;
              imgH = parseInt(imgW / imgRatio, 10);
            }
          }
          imgLeft = parseInt((winW - imgW) / 2, 10);
          imgTop = parseInt((winH - imgH) / 2, 10);
          _results.push($slide.css({
            width: imgW + 'px',
            height: imgH + 'px',
            left: imgLeft + 'px',
            top: imgTop + 'px'
          }));
        }
        return _results;
      }
    },
    showSidebar: function() {
      this.$info.addClass('hide');
      this.$close.removeClass('hide');
      return this.$sidebar.addClass('portfolio__sidebar--shown');
    },
    hideSidebar: function() {
      this.$info.removeClass('hide');
      this.$close.addClass('hide');
      return this.$sidebar.removeClass('portfolio__sidebar--shown');
    },
    onKeyDown: function(e) {
      switch (e.keyCode) {
        case 37:
          return this.navPrev();
        case 39:
          return this.navNext();
      }
    },
    onMouseMove: function(e) {
      var _this = this;
      clearTimeout(this.timer2);
      app.$body.removeClass('hidden').addClass('mousemove');
      return this.timer2 = setTimeout(function() {
        clearTimeout(_this.timer2);
        return app.$body.removeClass('mousemove').addClass('hidden');
      }, 3000);
    },
    onTouchStart: function(e) {
      return this.startCoords = this.endCoords = e.originalEvent.targetTouches[0];
    },
    onTouchMove: function(e) {
      return this.endCoords = e.originalEvent.targetTouches[0];
    },
    onTouchEnd: function(e) {
      if (Math.abs(this.startCoords.pageX - this.endCoords.pageX) > 0) {
        return this.navNext();
      } else {
        return this.navPrev();
      }
    },
    onSliderNavClick: function(e) {
      var $target, direction;
      $target = $(e.currentTarget);
      direction = $target.data('direction');
      if (direction !== null) {
        if (direction === 'prev') {
          this.navPrev();
        }
        if (direction === 'next') {
          return this.navNext();
        }
      }
    },
    onSocialLinkClick: function(e) {
      var $target, type;
      $target = $(e.currentTarget);
      type = $target.data('type');
      e.preventDefault();
      e.stopPropagation();
      switch (type) {
        case 'fave':
          return this.doFave(e);
        case 'comment':
          return this.toggleCommentsBlock(e);
        case 'share':
          return this.toggleShareBlock(e);
      }
    },
    onCommentPost: function(e) {
      var data, form, url,
        _this = this;
      form = $(e.currentTarget).parents('form');
      url = form.attr('action');
      data = form.serializeArray();
      $.post(url, data, function() {}).done(function(data, textStatus) {
        if (textStatus === "success") {
          _this.commentStatus.html('<div class="alert alert--success" >Thanks for your comment. We appreciate your response.</div>');
        } else {
          _this.commentStatus.html('<div class="alert alert--error" >Please wait a while before posting your next comment</div>');
        }
        return form.find('textarea[name=comment]').val('');
      }).fail(function(data, textStatus) {
        return _this.commentStatus.html('<div class="alert alert--error" >You might have left one of the fields blank, or be posting too quickly</div>');
      });
      e.preventDefault();
      return e.stopPropagation();
    },
    onCommentReplyClick: function(e) {
      e.preventDefault();
      return e.stopPropagation();
    },
    navPrev: function() {
      if (this.slider.curr > 1) {
        this.slider.curr--;
        this.updateNav();
        return this.updateSlider();
      }
    },
    navNext: function() {
      if (this.slider.curr < this.slider.count) {
        this.slider.curr++;
        this.updateNav();
        return this.updateSlider();
      }
    },
    doFave: function(e) {
      var counter, data, url,
        _this = this;
      counter = $(e.currentTarget).children('.portfolio__social__count');
      url = app.ajaxUrl;
      data = {
        action: 'fave',
        id: this.postId
      };
      return $.post(url, data, function() {}).done(function(data, textStatus) {
        return counter.html(data);
      }).fail(function(data, textStatus) {
        return console.log(data);
      });
    },
    toggleCommentsBlock: function() {
      return this.$comments.toggleClass('portfolio__comments--shown');
    },
    toggleShareBlock: function() {}
  });
});
