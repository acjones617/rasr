define(['jquery'], ($) ->
  class Map
    constructor: (@game, @Phaser, @mapId) ->
      @layer = null
      @layers = []
      @oldBorders = null
      @tiles = []
      @borders = 
        upScreen: true
        rightScreen: true
        downScreen: true
        leftScreen: true
      @game.physics.arcade.checkCollision.up = false
      @game.physics.arcade.checkCollision.right = false
      @game.physics.arcade.checkCollision.down = false
      @game.physics.arcade.checkCollision.left = false
      @game.on('changeMap', (direction) =>
        @reload(direction)
      )

    preload: (direction, data, callback) ->
      that = @
      @_loadAssets.call(@, data, callback)

    _loadAssets: (data, loader = @game.load) ->
      @mapId = data._id

      @game.mapId = @mapId

      @mapData = data
      loader.tilemap('map', null, data, @Phaser.Tilemap.TILED_JSON)

      for tileset in data.tilesets
        @tiles[tileset.name] = loader.image(tileset.name, "assets/tilemaps/tiles/" + tileset.image, 32, 32)

      @oldBorders = @borders
      @borders = 
        upScreen: data.upScreen
        rightScreen: data.rightScreen
        downScreen: data.downScreen
        leftScreen: data.leftScreen

      for border, value of @borders
        if !!value != !!@oldBorders[border]
          $(".#{border}").toggleClass('no-bordering-screen')
          @game.physics.arcade.checkCollision[border.split('Screen')[0]] = !value

      loader.start();
      loader.onLoadComplete.add =>
        do @create

    create: ->
      map = @game.add.tilemap('map')

      for tileset in @mapData.tilesets
          map.addTilesetImage(tileset.name)

      for layer in @mapData.layers
        layer = map.createLayer(layer.name)
        @layers.push(layer)
        layer.resizeWorld()

      @trigger 'finishLoad'

    reloadMap: (loader, direction) ->
      that = @
      url = "#{@game.rootUrl}/move/#{direction}/#{@mapId}"
      $.ajax({
        url: url
        success: (data) =>
          that._createCtrls(data)
                
          that._loadAssets.call(that, data, loader)
      })

    reload: (direction) ->
      layer.destroy() for layer in @layers
      @layers = []
      loader = new @Phaser.Loader(@game)
      @reloadMap(loader, direction)

    update: ->

    _createCtrls: (data) ->
      $('#map-id').attr('href', '/edit/' + @mapId);
      $('.creatables > button').remove();

      if(!data.upScreen)
        $up = $("<button class='btn btn-primary'>Up</button>")
        $up.click =>
          @_makeMap('up', data._id)
        $('.creatables').append(up)
      if(!data.rightScreen)
        $right = $("<button class='btn btn-primary'>right</button>")
        $right.click =>
          @_makeMap('right', data._id)
        $('.creatables').append($right)
      if(!data.downScreen)
        $down = $("<button class='btn btn-primary'>down</button>")
        $down.click =>
          @_makeMap('down', data._id)
        $('.creatables').append($down)
      if(!data.leftScreen)
        $left = $("<button class='btn btn-primary'>left</button>")
        $left.click =>
          @_makeMap('left', data._id)
        $('.creatables').append($left)
 

    _makeMap: (direction, mapId) ->
      $.ajax({
        url: "/make/#{direction}/#{mapId}"
        type: "GET",
        success: ->
        error: ->
      });

  return Map
)