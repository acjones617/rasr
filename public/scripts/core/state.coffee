app.config ($stateProvider, $locationProvider, $httpProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/404"
  $locationProvider.html5Mode true
  $stateProvider.state("home",
    url: "/"
    templateUrl: "/js/core/templates/home.tpl.html"
    controller: "AppCtrl"
  ).state("404",
    url: "/404"
    template: "/js/core/templates/404.tpl.html"
  ).state("login",
    url: "/login"
    templateUrl: "/js/core/templates/login.tpl.html"
    controller: "LoginCtrl"
  ).state("signup",
    url: "/signup"
    templateUrl: "/js/core/templates/signup.tpl.html"
    controller: "SignupCtrl"
  ).state "settings",
    url: "/settings"
    templateUrl: "/js/core/templates/settings.tpl.html"
    controller: "SettingsCtrl"
    authenticate: true



# .state('edit', {
#   url: '/edit/:mapId',
#   templateUrl: '/js/core/templates/edit',
#   authenticate: true
# })
