#Carga una imagen en memoria y luego la ajusta al contenedor del objeto img pasado.
#Tambien la centra horizontal o verticalmente

ImageLoader =
  #spinner      : "assets/loading.gif"
  #defaultImage : "assets/vesvi_logo.png" #Si la url de la imagen pasada no se
  #                                       #puede cargar. Se usa esta imagen en su lugar

#  putSpinner: ($img) ->    #Se coloca el spinner de carga
#    onLoad= ->
#      imgHeight       = @height #el "this" en estos casos se corresponde con el objeto "img" creado
#      imgWidth        = @width
#      containerHeight = $img.parent().height()
#      containerWidth  = $img.parent().width()
#
#      $img.attr("src", ImageLoader.spinner);
#      $img.css("top",(containerHeight - imgHeight) / 2)
#      $img.css("left",(containerWidth - imgWidth) / 2)
#    $("<img/>").load(onLoad).attr("src", ImageLoader.spinner)

  loadImage: (url, $img, options) ->
    #console.log url
    #console.log $img
    onLoad = ->
      imgWidth  = @width  #el "this" en estos casos se corresponde con el objeto "img" creado
      imgHeight = @height

      containerHeight = $img.parent().height()
      containerWidth  = $img.parent().width()

      cssValues = {}

      if (imgWidth / imgHeight < containerWidth / containerHeight)
        cssValues =
          "width" : "100%"
          "height": "auto"
          "top"   : ((containerHeight - (containerWidth / imgWidth * imgHeight)) / 2)  + "px"
          "left"  : "0px"
      else
        cssValues=
          "width" : "auto"
          "height": "100%"
          "top"   : "0px"
          "left"  : ((containerWidth - (containerHeight / imgHeight * imgWidth )) / 2) + "px"

      $img.attr("src", url)

      $img.css(cssValues);

    #ImageLoader.putSpinner $img unless options?.noSpinner
    #$("<img/>").load(onLoad).error(-> ImageLoader.loadImage ImageLoader.defaultImage, $img).attr("src",url)

    $("<img/>").load(onLoad).attr("src",url)
        
        
#EXPORTS:
window.ImageLoader = ImageLoader
