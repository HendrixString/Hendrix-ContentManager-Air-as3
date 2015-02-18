package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  
  import flash.utils.ByteArray;
  
  public class XMLContent extends BaseContent
  {
    private var _xml: XML;
    
    public function XMLContent($id:String, $content:ByteArray)
    {
      super($id, $content);
      
      _type                     = LocalResource.TYPE_XML;
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete,$onError);
      var s:String = _contentBinary.toString();
      _xml = new XML(_contentBinary.toString());
      notifyComplete();
      super.dispose();
    }
    
    override public function dispose():void
    {
      _xml = null;
      super.dispose();
    }
    
    public function get xml():XML
    {
      return _xml;
    }
    
    override public function get content():Object
    {
      return xml;
    }
    
  }
}