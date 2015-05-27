angular.module('angular-dragtable-page.docs', [
    'ui.router'
]);

angular.module('angular-dragtable-page.docs').config([
    '$stateProvider',
    function($stateProvider) {
        $stateProvider.state('docs', {
            url: "/docs",
            templateUrl: "partials/docs.html"
        });
    }
]);