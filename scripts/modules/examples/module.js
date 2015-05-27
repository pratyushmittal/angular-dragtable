angular.module('angular-dragtable-page.examples', [
    'ui.router'
]);

angular.module('angular-dragtable-page.examples').config([
    '$stateProvider',
    function($stateProvider) {
        $stateProvider.state('examples', {
            url: "/examples",
            templateUrl: "partials/examples.html"
        });
    }
]);