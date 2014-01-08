// Generated by CoffeeScript 1.6.3
(function() {
  var $, app;

  $ = jQuery;

  app = {
    baseUrl: window.location.protocol + '//' + window.location.host + '/',
    domainRegex: '',
    subDomain: 'photosite/',
    testDomain: 'http://localhost/photosite/',
    config: {
      foo: 'bar'
    },
    view: {},
    subView: null,
    modules: {},
    init: function() {
      app.DEBUG = true;
      app.$window = $(window);
      app.$document = $(document);
      app.$body = $('body');
      app.$document.on('resize', function(e) {
        return PubSub.trigger('app:resize', e);
      });
      app.$document.on('mousemove', function(e) {
        return PubSub.trigger('app:mousemove', e);
      });
      app.$document.on('keydown', function(e) {
        return PubSub.trigger('app:keydown', e);
      });
      PubSub.trigger('app:rendered');
      return console.log(app);
    },
    isValidUrl: function(href) {
      if (!href) {
        return false;
      } else if (href.indexOf('javascript:') !== -1) {
        return false;
      } else if (href[0] === '#' && href.length === 1) {
        return false;
      } else if (href.indexOf('../') !== -1) {
        console.error('Attempting to load a relative url, bad code monkey! (' + href + ')');
        return false;
      } else if (href[0] !== '/' && href.indexOf('://') === -1) {
        console.error('Attempting to load a relative url, bad code monkey! (' + href + ')');
        return false;
      }
      return true;
    },
    getCurrRout: function() {
      return this.getDefinedRoute(window.location.href);
    },
    getDefinedRoute: function(fragment) {
      var matched;
      if (fragment === '#') {
        return null;
      }
      fragment = fragment.replace(this.domainRegex, '');
      if (!fragment.indexOf(this.baseUrl)) {
        fragment = fragment.substring(this.baseUrl.length);
      } else if (!fragment.indexOf(this.testDomain)) {
        fragment = fragment.substring(this.testDomain.length);
      } else if (fragment.indexOf('://') !== -1) {
        return null;
      }
      fragment = Backbone.history.getFragment(fragment);
      matched = _.any(Backbone.history.handlers, function(handler) {
        return handler.route.test(fragment);
      });
      if (matched) {
        return fragment;
      } else {
        return null;
      }
    },
    loadHtml: function(href) {
      if (!href) {
        return false;
      }
      return $.Deferred(function(deferred) {
        href = app.baseUrl + href;
        return $.ajax(href, {
          type: 'GET',
          dataType: 'html',
          error: function(jqXHR, textStatus, errorThrown) {
            console.log("AJAX Error: " + textStatus);
            return deferred.fail(textStatus);
          },
          success: function(data, textStatus, jqXHR) {
            return deferred.resolve(data);
          }
        });
      }).promise();
    },
    delay: function(time, callback) {
      return setTimeout((function() {
        return callback();
      }), time);
    }
  };

  app.modules.gallery = Backbone.View.extend({
    el: '.portfolio__list',
    unit: null,
    unitSpan: 0,
    numCols: null,
    shuffleOn: false,
    popped: false,
    setArray: null,
    padding: 10,
    initialize: function() {
      this.$el = $(this.el);
      app.$body.addClass('grid').addClass('gallery');
      return this.initGrid(true);
    },
    destroy: function() {
      return app.$body.removeClass('grid').removeClass('gallery');
    },
    initGrid: function(forceReload) {
      var i, newRow, numCols;
      numCols = this.setCols();
      if (this.numCols !== numCols || forceReload) {
        this.numCols = numCols;
        this.unit = $('.portfolio__item');
        this.setArray = [];
        newRow = [];
        i = this.numCols;
        while (i--) {
          newRow[i] = 0;
        }
        this.setArray.push(newRow);
        if (this.numCols >= 3) {
          return this.layout();
        } else {
          return this.clear();
        }
      }
    },
    clear: function() {},
    shuffle: function(units) {
      var i, j, nonShuffled, shuffled, temp;
      shuffled = units.not(".ignore-shuffle");
      nonShuffled = units.filter(".ignore-shuffle");
      shuffled = $.makeArray(shuffled);
      nonShuffled = $.makeArray(nonShuffled);
      i = shuffled.length;
      while (i--) {
        j = Math.floor(Math.random() * (i + 1));
        temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
      }
      shuffled = nonShuffled.concat(shuffled);
      return $(shuffled);
    },
    setCols: function() {
      var itemWidth;
      itemWidth = 320;
      return (this.$el.width() / itemWidth) | 0;
    },
    layout: function() {
      var col, colSpan, freeUnits, gridUnit, height, i, key, newRow, placed, row, rowSpan, takenUnits, width, _i, _len, _ref;
      this.unitSpan = this.$el.innerWidth() / this.numCols;
      this.unit.css("position", "absolute");
      this.unit.find(".portfolio__item__block").css({
        position: "absolute",
        top: this.padding,
        left: this.padding,
        right: this.padding,
        bottom: this.padding,
        minHeight: 0
      });
      if (this.shuffleOn) {
        this.unit = this.shuffle(this.unit);
      }
      gridUnit = {};
      _ref = this.unit;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        gridUnit = $(key);
        rowSpan = parseInt(gridUnit.data("rowspan"), 10);
        colSpan = parseInt(gridUnit.data("colspan"), 10);
        placed = false;
        newRow = [];
        width = this.unitSpan * colSpan;
        height = this.unitSpan * rowSpan;
        gridUnit.css({
          width: width,
          height: height
        });
        for (row in this.setArray) {
          freeUnits = 0;
          takenUnits = 0;
          for (col in this.setArray[row]) {
            if (this.setArray[row][col] === 0) {
              freeUnits++;
            } else {
              freeUnits = 0;
              takenUnits++;
            }
            if (freeUnits === colSpan) {
              gridUnit.css({
                top: row * this.unitSpan,
                left: (col - (colSpan - 1)) * this.unitSpan
              });
              i = colSpan + (col - (colSpan - 1)) - 1;
              while (i >= (col - (colSpan - 1))) {
                this.setArray[row][i] = 1;
                i--;
              }
              if (rowSpan > 1) {
                newRow = [];
                i = this.numCols;
                while (i--) {
                  newRow[i] = 0;
                }
                this.setArray.push(newRow);
                i = colSpan + (col - (colSpan - 1)) - 1;
                while (i >= (col - (colSpan - 1))) {
                  this.setArray[parseInt(row, 10) + 1][i] = 1;
                  i--;
                }
              }
              placed = true;
              break;
            }
          }
          if (!placed) {
            if (this.setArray[row + 1] != null) {
              newRow = [];
              i = this.numCols;
              while (i--) {
                newRow[i] = 0;
              }
              this.setArray.push(newRow);
            }
          } else {
            break;
          }
        }
      }
      return this.$el.height(this.setArray.length * this.unitSpan);
    }
  });

  app.modules.galleryItem = Backbone.View.extend({
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
      console.log('destroy');
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

  app.router = new (Backbone.Router.extend({
    initialize: function() {},
    routes: {
      '*path': 'parseHash'
    },
    parseHash: function(hash) {
      var ajaxPromise;
      console.log(hash);
      ajaxPromise = app.loadHtml(hash);
      ajaxPromise.done(function(html) {
        return PubSub.trigger('app:loaded', html);
      });
      return ajaxPromise.fail(function(error) {
        return console.log(error);
      });
    }
  }));

  Backbone.history.start({
    pushState: true,
    hashChange: false,
    silent: true
  });

  app.view = new (Backbone.View.extend({
    el: 'body',
    $container: {},
    events: {
      'click': 'triggerRoute'
    },
    initialize: function() {
      this.pubSub = {
        'app:loaded': this.render,
        'app:rendered': this.onAfterRender
      };
      PubSub.attach(this.pubSub, this);
      this.$el = $(this.el);
      this.$container = this.$el.find('#main');
      return this.$welcome = this.$el.find('#welcome');
    },
    triggerRoute: function(e) {
      var $targetLink, href, _ref, _ref1;
      $targetLink = $(e.target).closest('a');
      href = $.trim($targetLink.attr('href'));
      if (!Modernizr.history) {
        if (app.getDefinedRoute(href) && window.chromeless) {
          href = $.trim($targetLink.attr('href'));
          href += ((_ref = href.indexOf('?') === -1) != null ? _ref : {
            '?': '&'
          }) + 'chromeless=true';
          return $targetLink.attr('href', href);
        }
      } else {
        if (!app.isValidUrl(href)) {
          return e.preventDefault();
        } else {
          href = app.getDefinedRoute(href);
          if (href !== null) {
            if (window.chromeless) {
              href += ((_ref1 = href.indexOf('?') === -1) != null ? _ref1 : {
                '?': '&'
              }) + 'chromeless=true';
            }
            Backbone.history.navigate(href, {
              trigger: true
            });
            return e.preventDefault();
          }
        }
      }
    },
    render: function(html) {
      var $html;
      if (html !== null) {
        $html = $('<div/>').html(html).find('#main-content');
        this.$container.html($html);
        return PubSub.trigger('app:rendered');
      }
    },
    onAfterRender: function() {
      this.$welcome.hide();
      return this.revealApp();
    },
    revealApp: function() {
      var ex;
      this.moduleName = this.$el.find('#main-content').data('module') || 'text';
      console.log(this.moduleName, app.subView);
      if (app.modules.hasOwnProperty(this.moduleName)) {
        if (app.subView != null) {
          app.$window.off('.' + app.subView.cid);
          app.$document.off('.' + app.subView.cid);
          try {
            app.subView.destroy();
          } catch (_error) {
            ex = _error;
            console.error('View threw an exception on destroy: ', ex.stack || ex.stacktrace || ex.message);
            app.subView.$el.remove();
          }
        }
        return app.subView = new app.modules[this.moduleName];
      }
    }
  }));

  app.loader = new (Backbone.View.extend({
    el: '#loader',
    initialize: function() {
      this.$el = $(this.el);
      this.$progress = this.$el.children();
      this.pubSub = {
        'app:rendered': this.start
      };
      return PubSub.attach(this.pubSub, this);
    },
    start: function() {
      var $els, imageCount, l, total, _results;
      this.$progress.html('0');
      this.$el.show();
      $els = app.view.$el.find('img');
      total = $els.length;
      imageCount = 0;
      l = total;
      if (l > 0) {
        _results = [];
        while (l--) {
          $($els[l]).on('load', function() {});
          ++imageCount;
          this.$progress.html((total / imageCount) * 100);
          if (total === imageCount) {
            _results.push(this.done());
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      } else {
        return this.done();
      }
    },
    done: function() {
      return this.$el.hide();
    }
  }));

  $(document).ready(function() {
    return app.init();
  });

}).call(this);
