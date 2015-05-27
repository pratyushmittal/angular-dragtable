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

## Contribute

1. Create issues.
2. Fork the repository and make pull requests.

## LICENSE

The MIT License (MIT)

Copyright (c) 2013-2015 Pratyush Mittal

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
