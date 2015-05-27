angular.module('dragtable', []).value('mode', 'extension').value('version', 'v0.1.0').directive('draggable', [
  function() {
    var absolutePosition, arForEach, dragEnd, dragMove, dragStart, eventPosition, findColumn, findUp, fnForEach, forEach, fullCopy, link, moveColumn, strForEach;
    link = function(scope, element, attrs) {
      var headers, i, k, len, ref;
      scope.table = element[0];
      scope.order = [];
      scope.dragRadius2 = 100;
      headers = scope.table.tHead.rows[0].cells;
      ref = headers.length;
      for (k = 0, len = ref.length; k < len; k++) {
        i = ref[k];
        scope.order.push(i);
        headers[i].onmousedown = dragStart;
      }
    };
    dragStart = function($event) {
      var copySectionColumn, event, new_elt, obj_pos, pos, startX, startY, x, y;
      event = $event;
      event.preventDefault();
      x = void 0;
      y = void 0;
      scope.origNode = event.target;
      pos = eventPosition(event);
      scope.origNode = findUp(scope.origNode, /T[DH]/);
      scope.startCol = findColumn(scope.table, pos.x);
      if (scope.startCol === -1) {
        return;
      }
      new_elt = fullCopy(scope.table, false);
      new_elt.style.margin = '0';
      copySectionColumn = function(sec, col) {
        var new_sec;
        new_sec = fullCopy(sec, false);
        forEach(sec.rows, function(row) {
          var cell, new_td, new_tr;
          cell = row.cells[col];
          new_tr = fullCopy(row, false);
          if (row.offsetHeight) {
            new_tr.style.height = row.offsetHeight + 'px';
          }
          new_td = fullCopy(cell, true);
          if (cell.offsetWidth) {
            new_td.style.width = cell.offsetWidth + 'px';
          }
          new_tr.appendChild(new_td);
          new_sec.appendChild(new_tr);
        });
        return new_sec;
      };
      if (scope.table.tHead) {
        new_elt.appendChild(copySectionColumn(scope.table.tHead, scope.startCol));
      }
      forEach(scope.table.tBodies, function(tb) {
        new_elt.appendChild(copySectionColumn(tb, scope.startCol));
      });
      if (scope.table.tFoot) {
        new_elt.appendChild(copySectionColumn(scope.table.tFoot, scope.startCol));
      }
      obj_pos = absolutePosition(scope.origNode, true);
      new_elt.style.position = 'absolute';
      new_elt.style.left = obj_pos.x + 'px';
      new_elt.style.top = obj_pos.y + 'px';
      new_elt.style.width = scope.origNode.offsetWidth + 'px';
      new_elt.style.height = scope.origNode.offsetHeight + 'px';
      new_elt.style.opacity = 0.7;
      scope.addedNode = false;
      scope.tableContainer = scope.table.parentNode || $document.body;
      scope.elNode = new_elt;
      scope.cursorStartX = pos.x;
      scope.cursorStartY = pos.y;
      scope.elStartLeft = parseInt(scope.elNode.style.left, 10);
      scope.elStartTop = parseInt(scope.elNode.style.top, 10);
      if (isNaN(scope.elStartLeft)) {
        scope.elStartLeft = 0;
      }
      if (isNaN(scope.elStartTop)) {
        scope.elStartTop = 0;
      }
      scope.elNode.style.zIndex = ++scope.zIndex;
      startX = event.screenX - x;
      startY = event.screenY - y;
      $document.bind('mousemove', dragMove);
      $document.bind('mouseup', dragEnd);
    };
    dragMove = function($event) {
      var dx, dy, event, pos, style;
      event = $event;
      pos = eventPosition(event);
      dx = scope.cursorStartX - pos.x;
      dy = scope.cursorStartY - pos.y;
      if (!scope.addedNode && dx * dx + dy * dy > scope.dragRadius2) {
        scope.tableContainer.insertBefore(scope.elNode, scope.table);
        scope.addedNode = true;
      }
      style = scope.elNode.style;
      style.left = scope.elStartLeft + pos.x - scope.cursorStartX + 'px';
      style.top = scope.elStartTop + pos.y - scope.cursorStartY + 'px';
    };
    dragEnd = function($event) {
      var event, pos, table_pos, targetCol;
      event = $event;
      $document.unbind('mousemove', dragMove);
      $document.unbind('mouseup', dragEnd);
      if (!scope.addedNode) {
        return;
      }
      scope.tableContainer.removeChild(scope.elNode);
      pos = eventPosition(event);
      table_pos = absolutePosition(scope.table);
      if (pos.y < table_pos.y || pos.y > table_pos.y + scope.table.offsetHeight) {
        return;
      }
      targetCol = findColumn(scope.table, pos.x);
      if (targetCol !== -1 && targetCol !== scope.startCol) {
        moveColumn(scope.table, scope.startCol, targetCol);
        scope.$eval(attrs.onDragEnd, {
          $start: scope.startCol,
          $target: targetCol
        });
        console.log('This might not work and needs to be fixed.');
      }
    };
    moveColumn = function(table, sIdx, fIdx) {
      var cA, headrow, i, j, row, x;
      row = void 0;
      cA = void 0;
      i = table.rows.length;
      while (i--) {
        row = table.rows[i];
        x = row.removeChild(row.cells[sIdx]);
        if (fIdx < row.cells.length) {
          row.insertBefore(x, row.cells[fIdx]);
        } else {
          row.appendChild(x);
        }
      }
      headrow = table.tHead.rows[0].cells;
      j = void 0;
      j = 0;
      while (j < headrow.length) {
        headrow[j].sorttable_columnindex = j;
        j++;
      }
    };
    fullCopy = function(elt, deep) {
      var new_elt;
      new_elt = elt.cloneNode(deep);
      new_elt.className = elt.className;
      forEach(elt.style, function(value, key, object) {
        if (value === null) {
          return;
        }
        if (typeof value === 'string' && value.length === 0) {
          return;
        }
        new_elt.style[key] = elt.style[key];
      });
      return new_elt;
    };
    findColumn = function(table, x) {
      var header, i, pos;
      header = table.tHead.rows[0].cells;
      i = void 0;
      i = 0;
      while (i < header.length) {
        pos = absolutePosition(header[i]);
        if (pos.x <= x && x <= pos.x + header[i].offsetWidth) {
          return i;
        }
        i++;
      }
      return -1;
    };
    eventPosition = function(event) {
      return {
        x: event.pageX,
        y: event.pageY
      };
    };
    absolutePosition = function(elt, stopAtRelative) {
      var curStyle, ex, ey;
      ex = 0;
      ey = 0;
      while (true) {
        curStyle = $window.getComputedStyle(elt, '');
        if (stopAtRelative && curStyle.position === 'relative') {
          break;
        } else if (curStyle.position === 'fixed') {
          ex += parseInt(curStyle.left, 10);
          ey += parseInt(curStyle.top, 10);
          ex += $document[0].body.scrollLeft;
          ey += $document[0].body.scrollTop;
          break;
        } else {
          ex += elt.offsetLeft;
          ey += elt.offsetTop;
        }
        elt = elt.offsetParent;
        if (!elt) {
          break;
        }
      }
      return {
        x: ex,
        y: ey
      };
    };
    findUp = function(elt, tag) {
      while (true) {
        if (elt.nodeName && elt.nodeName.search(tag) !== -1) {
          return elt;
        }
        elt = elt.parentNode;
        if (!elt) {
          break;
        }
      }
    };
    fnForEach = function(object, block, context) {
      var key;
      key = void 0;
      for (key in object) {
        key = key;
        if (object.hasOwnProperty(key)) {
          block.call(context, object[key], key, object);
        }
      }
    };
    strForEach = function(object, block, context) {
      var array, i;
      array = string.split('');
      i = void 0;
      i = 0;
      while (i < array.length) {
        block.call(context, array[i], i, array);
        i++;
      }
    };
    forEach = function(object, block, context) {
      var isObjectFunction, resolve;
      if (object) {
        resolve = Object;
        isObjectFunction = object instanceof Function;
        if (!isObjectFunction && object.forEach instanceof Function) {
          object.forEach(block, context);
          return;
        }
        if (isObjectFunction) {
          resolve = fnForEach;
        } else if (typeof object === 'string') {
          resolve = strForEach;
        } else if (typeof object.length === 'number') {
          resolve = arForEach;
        }
        resolve(object, block, context);
      }
    };
    arForEach = function(array, block, context) {
      var i;
      i = void 0;
      i = 0;
      while (i < array.length) {
        block.call(context, array[i], i, array);
        i++;
      }
    };
    return link;

    /*{restrict: 'A'
        link: link
    }
     */
  }
]);
