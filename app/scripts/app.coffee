'use strict'

angular.module('xoWebApp', [
  # 'ngCookies',
  'ngRoute',
  # 'ngSanitize',
  'ui.bootstrap',
])
  .filter 'bytes', ->
    (size, unit, base) ->
      unit ?= 'B'
      base ?= 1024
      powers = ['', 'K', 'M', 'G', 'T', 'P']

      i = 0
      while size > base
        size /= base
        ++i

      # Maximum 1 decimals.
      size = ((size * 10)|0) / 10

      return "#{size}#{powers[i]}B"

  .config ($routeProvider, $tooltipProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/list',
        templateUrl: 'views/list.html'
        controller: 'ListCtrl'
      .when '/hosts/:uuid',
        templateUrl: 'views/host.html'
        controller: 'HostCtrl'
      .when '/srs/:uuid',
        templateUrl: 'views/sr.html'
        controller: 'SrCtrl'
      .when '/pools/:uuid',
        templateUrl: 'views/pool.html'
        controller: 'PoolCtrl'
      .when '/vms/:uuid',
        templateUrl: 'views/vm.html'
        controller: 'VmCtrl'
      .otherwise
        redirectTo: '/'

    # FIXME: Tooltip incorrect positionning.
    $tooltipProvider.options {
      appendToBody: true
      placement: 'bottom'
    }
