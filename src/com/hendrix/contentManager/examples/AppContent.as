package com.hendrix.contentManager.examples
{
  import com.hendrix.contentManager.ContentManager;
  import com.hendrix.contentManager.Package;
  import com.hendrix.contentManager.core.manifest.LocalResource;
  import com.hendrix.contentManager.core.types.BitmapContent;
  import com.hendrix.contentManager.core.types.XMLContent;
  import com.hendrix.processManager.ProcessManager;
  
  import flash.display.Bitmap;
  
  public class AppContent extends ContentManager
  {
    
    public function AppContent()
    {
      super();
    }
    
    /**
     * here deal with content processing like parsing etc for initial loading..
     */
    public function loadInitialContent():void
    {
      var newBatch: Package = addOrGetContentPackage("initBatch");
      newBatch.enqueue("assets/data.xml", "appConfig");
      newBatch.enqueue("assets/comps/splash/background.png", "splash");
      newBatch.enqueue("assets/fonts/Nehama.ttf", "font");
      
      var newBatch2: Package = addOrGetContentPackage("initBatch_2");
      newBatch.enqueue("assets/data2.xml", "appConfig2");
      newBatch.enqueue("assets/comps/splash/background2.png", "splash2");
      newBatch.enqueue("assets/fonts/Nehama2.ttf", "font2");
      
      var newBatch3: Package = addOrGetContentPackage("initBatch_3");
      newBatch.enqueue("assets/data2.xml", "appConfig3");
      newBatch.enqueue("assets/comps/splash/background2.png", "splash3");
      newBatch.enqueue("assets/fonts/Nehama2.ttf", "font3");
      
      var newBatch4: Package = addOrGetContentPackage("initBatch_4");
      newBatch.enqueue("assets/data2.xml", "appConfig4");
      newBatch.enqueue("assets/comps/splash/background2.png", "splash4");
      newBatch.enqueue("assets/fonts/Nehama2.ttf", "font4");
      
      
      newBatch.process(onInitBatchFinished);
      
      loadPackages("initBatch_3,initBatch_4", onBatchesComplete);
    }
    
    private function onBatchesComplete(pm:ProcessManager):void
    {
      var xml:XML    = (getContentById("initBatch_3::appConfig3", LocalResource.TYPE_XML) as XMLContent).xml;
      
      var pack_4:Package = pm.getFinishedProcess("initBatch_4") as Package;
      
      var bmp:Bitmap = (pack_4.getContentById("splash4", LocalResource.TYPE_BITMAP) as BitmapContent).bitmap;
      
    }
    
    private function onInitBatchFinished(pkg:Package):void
    {
      var xml:XML    = (getContentById("initBatch::appConfig", LocalResource.TYPE_XML) as XMLContent).xml;
      var bmp:Bitmap = (getContentById("initBatch::splash", LocalResource.TYPE_BITMAP) as BitmapContent).bitmap;
    }
    
  }
  
}