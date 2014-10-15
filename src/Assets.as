package
{
    import starling.core.Starling;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class Assets
    {
        [Embed(source="../assets/textures/atlas.xml", mimeType="application/octet-stream")]
        private static const atlas_xml:Class;
        
        [Embed(source="../assets/textures/atlas.png")]
        private static const atlas:Class;
        
        private static var _atlas:TextureAtlas;
        
        public static function getTexture(name:String):Texture
        {
            init();
            return _atlas.getTexture(name);
        }
        
        public static function getTextures(prefix:String):Vector.<Texture>
        {
            init();
            return _atlas.getTextures(prefix);
        }
        
        private static function init():void
        {
            if (Starling.current == null)
                throw new Error("Initialize Starling before accessing textures.");
            
            if (_atlas == null)
            {
                var atlasTexture:Texture = Texture.fromEmbeddedAsset(atlas, false);
                var atlasXml:XML = XML(new atlas_xml());
                
                _atlas = new TextureAtlas(atlasTexture, atlasXml);
            }
        }
    }
}