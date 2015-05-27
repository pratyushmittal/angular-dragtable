angular.module('angular-dragtable-page.home', [
    'ui.router'
]);

angular.module('angular-dragtable-page.home').config([
    '$stateProvider',
    function($stateProvider) {
        $stateProvider.state('home', {
            url: "/",
            templateUrl: "partials/home.html"
        });
    }
]);