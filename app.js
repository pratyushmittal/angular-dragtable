 var app = angular.module('demo', ['dragtable']);

function CallbackCtrl($scope) {
    $scope.message = "";
    $scope.drag_callback = function($start, $target) {
        $scope.message = "Moved from " + $start + " to " + $target;
    };
}

app.controller('CallbackCtrl', CallbackCtrl);
