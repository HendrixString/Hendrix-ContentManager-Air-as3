package com.hendrix.contentManager.core.types
{ 
  import com.hendrix.processManager.core.types.BaseProcess;
  
  import flash.utils.ByteArray;
  
  public class BaseContent extends BaseProcess
  {
    protected var _type:                    String    = null;
    
    protected var _contentBinary:           ByteArray = null;
    
    /**
     * a simple Content that extends <code>BaseProcess</code> 
     * @see com.mreshet.mrProcessManager.core.interfaces.IProcess
     * @see com.mreshet.mrProcessManager.core.types.BaseProcess
     * @author Tomer Shalev
     */
    public function BaseContent($id:String, $content:ByteArray, $priorityKey:Object = null)
    {
      super($id, $priorityKey);
      
      _contentBinary = $content;
    }
    
    /**
     * @inheritDoc 
     */
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete);
    }
    
    /**
     * @inheritDoc 
     */
    override public function dispose():void
    {
      if(_contentBinary) {
        _contentBinary.clear();
        _contentBinary = null;
      }
      _onComplete = null;
    }
    
    /**
     * get the required content, please override 
     */
    public function get content():Object
    {
      return null;
    }
  }
}