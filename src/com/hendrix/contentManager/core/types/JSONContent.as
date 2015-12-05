package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  
  import flash.utils.ByteArray;
  
  public class JSONContent extends BaseContent
  {
    private var _json_parsed: Object;
    
    public function JSONContent($id:String, $content:ByteArray)
    {
      super($id, $content);
      
      _type                     = LocalResource.TYPE_XML;
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete,$onError);

      _json_parsed = JSON.parse(_contentBinary.toString());
      
      notifyComplete();
      super.dispose();
    }
    
    override public function dispose():void
    {
      _json_parsed = null;
      super.dispose();
    }
    
    public function get json_parsed():Object
    {
      return _json_parsed;
    }
    
    override public function get content():Object
    {
      return json_parsed;
    }
    
  }
}