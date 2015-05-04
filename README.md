# Hendrix-ContentManager-Air-as3
content manager for Adobe AIR/Flex application.

## How to use
simply fork or download the project, you can also download the binary itself and link it
to your project, or import to your IDE of choice such as `Flash Builder 4.7`.

## Features
- supports multi packages asynchronous loadin of assets from local or remote host.
- assets supported:
  - `Bitmaps`
  - `Xmls`
  - `Raw Binaries`
  - `Swf MovieClip`
  - `Mp3`
- each asset types has it's own dedicated parser/loader.

## Guide
1 Single pack loading:

* use simple queries to the `Package` in string format by id:
`pack.getContentById("content_id")`

```

public function loadSinglePack():void
{      
  var newBatch:Package    = new Package("initBatch1");
  
  newBatch.enqueue("assets/data.xml",             "appConfig1");
  newBatch.enqueue("assets/bitmaps/action.png",   "action");
  newBatch.enqueue("assets/sounds/whistle.mp3",   "whistle");
  newBatch.enqueue("assets/swfs/mc.swf",          "movieclip");
  
  newBatch.process(pack_onFinished);
}

private function pack_onFinished(pack:Package):void
{
  var xml:  XMLContent    = pack.getContentById("appConfig1", LocalResource.TYPE_XML) as XMLContent;
  var bmp:  BitmapContent = pack.getContentById("action",     LocalResource.TYPE_BITMAP) as BitmapContent;
  var mp3:  SoundContent  = pack.getContentById("whistle",    LocalResource.TYPE_SOUND) as SoundContent;
  var mc:   SWFContent    = pack.getContentById("movieclip",  LocalResource.TYPE_SWF) as SWFContent;      
}

```

2 Multi Pack loading: using the `ContentManager` instance

* get or add package with `contentManager.addOrGetContentPackage("pack_id")`
* load multiple registered packages with elegant command `contentManager.loadPackages("pak1_id,pak2_id", cm_onComplete);`
* load all registered packages with elegant command `contentManager.loadPackages("*", cm_onComplete);`
* use simple queries to the `ContentManager` in string format by id:
`contentManager.getContentById("pack_id::content_id")`

```
private var cm:ContentManager = new ContentManager();

public function loadMultiPacks():void
{      
  var pack1:Package     = cm.addOrGetContentPackage("pack1");
  var pack2:Package     = cm.addOrGetContentPackage("pack2");
  
  pack1.enqueue("assets/data.xml",                  "appConfig1");
  pack1.enqueue("assets/bitmaps/action.png",        "action");
  pack1.enqueue("assets/sounds/whistle.mp3",        "whistle");
  pack1.enqueue("assets/swfs/mc.swf",               "movieclip");
  
  pack2.enqueue("assets/bitmaps/bmp_btn_up.png",    "bmp_btn_up");
  pack2.enqueue("assets/bitmaps/bmp_btn_down.png",  "bmp_btn_down");
  
  cm.loadPackages("*", cm_onComplete);
}

private function cm_onComplete(pm:ProcessManager):void
{
  var txml: XMLContent    = cm.getContentById("pack1::appConfig1",  LocalResource.TYPE_XML) as XMLContent;
  var bmp:  BitmapContent = cm.getContentById("pack2::action",      LocalResource.TYPE_BITMAP) as BitmapContent;
}
```

### Dependencies
* [`Hendrix Collection library`](https://github.com/HendrixString/Hendrix-Collection-Air)
* [`Hendrix Process Manager library`](https://github.com/HendrixString/Hendrix-ProcessManager-AIR)

### Terms
* completely free source code. [Apache License, Version 2.0.](http://www.apache.org/licenses/LICENSE-2.0)
* if you like it -> star or share it with others

### Contact Author
* [tomer.shalev@gmail.com](tomer.shalev@gmail.com)
* [Google+ TomershalevMan](https://plus.google.com/+TomershalevMan/about)
* [Facebook - HendrixString](https://www.facebook.com/HendrixString)
