angular.module('angular-dragtable-page', [
    'ui.router',
    
    'angular-dragtable-page.home',
    'angular-dragtable-page.docs',
    'angular-dragtable-page.examples'
]);

angular.module('angular-dragtable-page').config([
    '$urlRouterProvider',
    function($urlRouterProvider) {
        $urlRouterProvider.otherwise('/')
    }
]);