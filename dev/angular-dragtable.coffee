angular.module 'dragtable', []
.value 'mode', 'extension'
.value 'version', 'v0.1.0'
.directive 'draggable', [
  ->
    link = (scope, element, attrs) ->
      scope.table = element[0]
      scope.order = []
      scope.dragRadius2 = 100
      
      headers = scope.table.tHead.rows[0].cells
      
      for i in headers.length
        scope.order.push i
        headers[i].onmousedown = dragStart
        
      return
          
    dragStart = ($event) ->
      event = $event
      # Prevent default dragging of selected content
      event.preventDefault()
      # Prepare the drag object
      x = undefined
      y = undefined
      scope.origNode = event.target
      pos = eventPosition(event)
      # Drag the entire table cell, not just the element that was clicked.
      scope.origNode = findUp(scope.origNode, /T[DH]/)
      scope.startCol = findColumn(scope.table, pos.x)
      if scope.startCol == -1
        return
      new_elt = fullCopy(scope.table, false)
      new_elt.style.margin = '0'
      # Copy the entire column

      copySectionColumn = (sec, col) ->
        new_sec = fullCopy(sec, false)
        forEach sec.rows, (row) ->
          cell = row.cells[col]
          new_tr = fullCopy(row, false)
          if row.offsetHeight
            new_tr.style.height = row.offsetHeight + 'px'
          new_td = fullCopy(cell, true)
          if cell.offsetWidth
            new_td.style.width = cell.offsetWidth + 'px'
          new_tr.appendChild new_td
          new_sec.appendChild new_tr
          return
        new_sec

      # First the heading
      if scope.table.tHead
        new_elt.appendChild copySectionColumn(scope.table.tHead, scope.startCol)
      forEach scope.table.tBodies, (tb) ->
        new_elt.appendChild copySectionColumn(tb, scope.startCol)
        return
      if scope.table.tFoot
        new_elt.appendChild copySectionColumn(scope.table.tFoot, scope.startCol)
      obj_pos = absolutePosition(scope.origNode, true)
      new_elt.style.position = 'absolute'
      new_elt.style.left = obj_pos.x + 'px'
      new_elt.style.top = obj_pos.y + 'px'
      new_elt.style.width = scope.origNode.offsetWidth + 'px'
      new_elt.style.height = scope.origNode.offsetHeight + 'px'
      new_elt.style.opacity = 0.7
      # Hold off adding the element until clearly a drag.
      scope.addedNode = false
      scope.tableContainer = scope.table.parentNode or $document.body
      scope.elNode = new_elt
      # Save starting positions of cursor and element.
      scope.cursorStartX = pos.x
      scope.cursorStartY = pos.y
      scope.elStartLeft = parseInt(scope.elNode.style.left, 10)
      scope.elStartTop = parseInt(scope.elNode.style.top, 10)
      if isNaN(scope.elStartLeft)
        scope.elStartLeft = 0
      if isNaN(scope.elStartTop)
        scope.elStartTop = 0
      # Update element's z-index.
      scope.elNode.style.zIndex = ++scope.zIndex
      # Add listeners for movement
      startX = event.screenX - x
      startY = event.screenY - y
      $document.bind 'mousemove', dragMove
      $document.bind 'mouseup', dragEnd
      return

    dragMove = ($event) ->
      event = $event
      # Get cursor position with respect to the page.
      pos = eventPosition(event)
      dx = scope.cursorStartX - (pos.x)
      dy = scope.cursorStartY - (pos.y)
      if !scope.addedNode and dx * dx + dy * dy > scope.dragRadius2
        scope.tableContainer.insertBefore scope.elNode, scope.table
        scope.addedNode = true
      # Move drag element as cursor has moved.
      style = scope.elNode.style
      style.left = scope.elStartLeft + pos.x - (scope.cursorStartX) + 'px'
      style.top = scope.elStartTop + pos.y - (scope.cursorStartY) + 'px'
      return

    dragEnd = ($event) ->
      event = $event
      $document.unbind 'mousemove', dragMove
      $document.unbind 'mouseup', dragEnd
      # If the floating header wasn't added,
      # the mouse didn't move far enough.
      if !scope.addedNode
        return
      scope.tableContainer.removeChild scope.elNode
      # Determine whether the drag ended over the table,
      # and over which column.
      pos = eventPosition(event)
      table_pos = absolutePosition(scope.table)
      if pos.y < table_pos.y or pos.y > table_pos.y + scope.table.offsetHeight
        return
      targetCol = findColumn(scope.table, pos.x)
      if targetCol != -1 and targetCol != scope.startCol
        moveColumn scope.table, scope.startCol, targetCol
        scope.$eval attrs.onDragEnd,
          $start: scope.startCol
          $target: targetCol
        console.log 'This might not work and needs to be fixed.'
      return

    moveColumn = (table, sIdx, fIdx) ->
      row = undefined
      cA = undefined
      i = table.rows.length
      while i--
        row = table.rows[i]
        x = row.removeChild(row.cells[sIdx])
        if fIdx < row.cells.length
          row.insertBefore x, row.cells[fIdx]
        else
          row.appendChild x
      # For whatever reason
      # sorttable tracks column indices this way.
      headrow = table.tHead.rows[0].cells
      j = undefined
      j = 0
      while j < headrow.length
        headrow[j].sorttable_columnindex = j
        j++
      return

    fullCopy = (elt, deep) ->
      new_elt = elt.cloneNode(deep)
      new_elt.className = elt.className
      forEach elt.style, (value, key, object) ->
        if value == null
          return
        if typeof value == 'string' and value.length == 0
          return
        new_elt.style[key] = elt.style[key]
        return
      new_elt

    findColumn = (table, x) ->
      header = table.tHead.rows[0].cells
      i = undefined
      i = 0
      while i < header.length
        pos = absolutePosition(header[i])
        if pos.x <= x and x <= pos.x + header[i].offsetWidth
          return i
        i++
      -1

    eventPosition = (event) ->
      {
        x: event.pageX
        y: event.pageY
      }

    absolutePosition = (elt, stopAtRelative) ->
      ex = 0
      ey = 0
      loop
        curStyle = $window.getComputedStyle(elt, '')
        if stopAtRelative and curStyle.position == 'relative'
          break
        else if curStyle.position == 'fixed'
          # Get the fixed el's offset
          ex += parseInt(curStyle.left, 10)
          ey += parseInt(curStyle.top, 10)
          # Compensate for scrolling
          ex += $document[0].body.scrollLeft
          ey += $document[0].body.scrollTop
          # End the loop
          break
        else
          ex += elt.offsetLeft
          ey += elt.offsetTop
        elt = elt.offsetParent
        unless elt
          break
      {
        x: ex
        y: ey
      }

    findUp = (elt, tag) ->
      loop
        if elt.nodeName and elt.nodeName.search(tag) != -1
          return elt
        elt = elt.parentNode
        unless elt
          break
      return

    fnForEach = (object, block, context) ->
      key = undefined
      for key of object
        `key = key`
        if object.hasOwnProperty(key)
          block.call context, object[key], key, object
      return

    strForEach = (object, block, context) ->
      array = string.split('')
      i = undefined
      i = 0
      while i < array.length
        block.call context, array[i], i, array
        i++
      return

    forEach = (object, block, context) ->
      if object
        resolve = Object
        # default
        isObjectFunction = object instanceof Function
        if !isObjectFunction and object.forEach instanceof Function
          # the object implements a custom forEach method so use that
          object.forEach block, context
          return
        if isObjectFunction
          # functions have a "length" property
          resolve = fnForEach
        else if typeof object == 'string'
          resolve = strForEach
        else if typeof object.length == 'number'
          # the object is array-like
          resolve = arForEach
        resolve object, block, context
      return

    arForEach = (array, block, context) ->
      # array-like enumeration
      i = undefined
      i = 0
      while i < array.length
        block.call context, array[i], i, array
        i++
      return
            
    
    return {
        restrict: 'A'
        link: link
    }
]