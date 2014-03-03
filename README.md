## Demo

http://fully-faltoo.com/angular-dragtable/

## Dependencies

AngularJS

# Usage

1. Load the module `angular.module('myModule', ['dragtable']);`

2. Add the `draggable` attribute to any table.

Example:

    <table draggable>
        <thead>
            <tr>
                <th id="x">Name</th>
                <th>Favorite Color</th><th>Date</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Dan</td>
                <td>Blue</td><td>1984-07-12</td>
            </tr>
            <tr>
                <td>Alice</td>
                <td>Green</td><td>1980-07-22</td>
            </tr>
        </tbody>
    </table>


## About

This is the AngularJS version of [Dan Vanderkam's DragTable][original]. It **does not require any other dependencies (ie. no jquery required).**.

Differences from the [original DragTable][original]:

- No support for old browsers.
- No cookie handling (instead provides the `on-drag-end` callback function).


[original]: http://www.danvk.org/wp/dragtable/
