describe 'Module: dragtable', ->
  beforeEach module 'dragtable'
  
  it 'should provide a version', inject (version) ->
    expect(version).toEqual 'v0.1.0'
    
  it 'should provide a mode', inject (mode) ->
    expect(mode).toEqual 'extension'
    
  describe 'Directive: draggable', ->
    $compile = null
    $rootScope = null
    
    html = "<table draggable><thead><tr></tr></thead></table>"
    
    beforeEach inject (_$compile_, _$rootScope_) ->
      $compile = _$compile_
      $rootScope = _$rootScope_
      
    it 'should', ->
      element = $compile(html)($rootScope)
      $rootScope.$digest()
      expect(element.html()).toEqual "<thead><tr></tr></thead>"
      
      