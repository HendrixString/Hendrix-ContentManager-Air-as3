package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  
  import flash.utils.ByteArray;
  
  public class BinaryContent extends BaseContent
  {
    private var _data:ByteArray = null;
    
    public function BinaryContent($id:String, $content:ByteArray)
    {
      super($id, $content);
      
      _type                     = LocalResource.TYPE_BINARY;
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete);
      
      _data                     = new ByteArray();
      _data.writeObject(_contentBinary);
      _data.position            = 0;
      
      _contentBinary.clear();
      _contentBinary = null;
      
      notifyComplete();
    }
    
    override public function dispose():void
    {
      super.dispose();
      _data.clear();
      _data = null;
    }
    
    public function get data():ByteArray
    {
      _data.position = 0;
      return _data.readObject();
    }
    
    override public function get content():Object
    {
      return data;
    }
    
  }
}