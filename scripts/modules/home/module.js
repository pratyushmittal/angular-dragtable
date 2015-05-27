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

angular.module('angular-dragtable-page.home').controller('CallbackCtrl', [
    '$scope',
    function ($scope) {
        $scope.message = "";
        $scope.drag_callback = function() {
            alert('hi');
        };
    }
]);