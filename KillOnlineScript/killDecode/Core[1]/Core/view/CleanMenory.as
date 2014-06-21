package Core.view
{
    import flash.net.*;
    import flash.system.*;

    public class CleanMenory extends Object
    {

        public function CleanMenory()
        {
            return;
        }// end function

        public static function clean() : void
        {
            trace("Strat_totalMemory-" + System.totalMemory);
            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch (error:Error)
            {
                trace("End_totalMemory-" + System.totalMemory);
            }
            return;
        }// end function

    }
}
