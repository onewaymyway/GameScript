package as3reflect
{

    public interface IMember extends IMetaDataContainer
    {

        public function IMember();

        function get declaringType() : Type;

        function get type() : Type;

        function get name() : String;

    }
}
