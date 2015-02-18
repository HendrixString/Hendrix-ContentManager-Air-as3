package com.hendrix.contentManager.core.types
{
  import com.hendrix.contentManager.core.manifest.LocalResource;
  
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.utils.ByteArray;
  
  public class SoundContent extends BaseContent
  {
    private var _sound:           Sound               = null;
    private var _soundChannel:    SoundChannel        = null;
    private var _soundTrans:      SoundTransform      = new SoundTransform(0.5, 0);
    
    public function SoundContent($id:String, $content:ByteArray)
    {
      super($id, $content);
      
      _type = LocalResource.TYPE_SOUND;
    }
    
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete, $onError);
      
      _sound                  = new Sound();
      _contentBinary.position = 0;
      _sound.loadCompressedDataFromByteArray(_contentBinary, _contentBinary.bytesAvailable);
      
      notifyComplete();
    }
    
    override public function dispose():void
    {
      super.dispose();
      
      _sound        = null;
      _soundChannel = null;
      _soundTrans   = null;
    }
    
    public function stopAndplay():void
    {
      soundStop();
      soundPlay();
    }
    
    public function soundPlay():void
    {
      _soundTrans.volume  = 1;
      _soundChannel       = _sound.play(0, 1, _soundTrans);
    }
    
    public function soundStop():void
    {
      if(_soundChannel)
        _soundChannel.stop();
    }
    
    public function get sound():Sound
    {
      return _sound;
    }
    
    override public function get content():Object
    {
      return sound;
    }
    
    
  }
}