// Generated by CoffeeScript 1.6.3
define(["app"], function(app) {
  "use strict";
  var GalleryItem;
  GalleryItem = app.module();
  GalleryItem.View = Backbone.View.extend({
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
    timer: null,
    events: {
      'click .portfolio__nav__item': 'onSliderNavClick',
      'mousemove .portfolio__slider': 'onMouseMove',
      'mouseenter .portfolio__sidebar': 'onSidebarOver',
      'mouseleave .portfolio__sidebar': 'onSidebarLeave'
    },
    initialize: function() {
      var _this = this;
      this.pubSub = {
        'app:keydown': this.onKeyDown
      };
      PubSub.attach(this.pubSub, this);
      this.$el = $(this.el);
      this.slider.$el = this.$el.find('.portfolio__slider');
      this.$sidebar = this.$el.find('.portfolio__sidebar');
      this.slider.nav.$el = this.$el.find('.portfolio__nav');
      app.$body.addClass('fixed');
      this.doSlider();
      this.doNav();
      this.timer = app.delay(3000, function() {
        app.$body.addClass('hidden');
        return _this.$sidebar.removeClass('fadeIn').addClass('fadeOut');
      });
      return this;
    },
    destroy: function() {
      clearTimeout(this.timer);
      app.$body.removeClass('hidden').removeClass('fixed');
      return PubSub.unattach(this.pubSub, this);
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
      this.slider.nav.$prev = this.slider.nav.$el.find('.portfolio__nav__item--prev');
      this.slider.nav.$curr = this.slider.nav.$el.find('.portfolio__nav__item--curr');
      this.slider.nav.$next = this.slider.nav.$el.find('.portfolio__nav__item--next');
      return this.updateNav();
    },
    updateNav: function() {
      var next, prev;
      prev = this.slider.curr - 1;
      next = this.slider.curr + 1;
      if (this.slider.curr === 1) {
        this.slider.nav.$prev.addClass('portfolio__nav__item--hidden');
      } else {
        this.slider.nav.$prev.removeClass('portfolio__nav__item--hidden');
      }
      if (this.slider.curr === this.slider.count) {
        this.slider.nav.$next.addClass('portfolio__nav__item--hidden');
      } else {
        this.slider.nav.$next.removeClass('portfolio__nav__item--hidden');
      }
      this.slider.nav.$prev.children('.portfolio__nav__item__pos').html('0' + prev);
      this.slider.nav.$curr.children('.portfolio__nav__item__pos').html('0' + this.slider.curr);
      return this.slider.nav.$next.children('.portfolio__nav__item__pos').html('0' + next);
    },
    onSidebarOver: function() {
      return this.$sidebar.removeClass('fadeOut').addClass('fadeIn');
    },
    onSidebarLeave: function() {
      var _this = this;
      return app.delay(3000, function() {
        return _this.$sidebar.removeClass('fadeIn').addClass('fadeOut');
      });
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
      app.$body.removeClass('hidden').addClass('mousemove');
      this.slider.nav.$el.show().removeClass('fadeOut').addClass('fadeIn');
      return this.timer = setTimeout((function() {
        app.$body.removeClass('mousemove').addClass('hidden');
        _this.slider.nav.$el.removeClass('fadeIn').addClass('fadeOut');
        app.delay(300, function() {
          return _this.slider.nav.$el.hide();
        });
        return clearTimeout(_this.timer);
      }), 3000);
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
    }
  });
  return GalleryItem;
});
