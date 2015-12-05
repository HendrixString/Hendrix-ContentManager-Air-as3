package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  
  import flash.utils.ByteArray;
  
  public class TextContent extends BaseContent
  {
    private var _text: String;
    
    public function TextContent($id:String, $content:ByteArray)
    {
      super($id, $content);
      
      _type                     = LocalResource.TYPE_XML;
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete,$onError);

      _text = _contentBinary.toString();
      
      notifyComplete();
      super.dispose();
    }
    
    override public function dispose():void
    {
      _text = null;
      super.dispose();
    }
    
    public function get text():String
    {
      return _text;
    }
    
    override public function get content():Object
    {
      return text;
    }
    
  }
}