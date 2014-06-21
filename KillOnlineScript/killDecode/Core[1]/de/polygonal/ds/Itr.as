package de.polygonal.ds
{

    public interface Itr
    {

        public function Itr() : void;

        function reset() : Itr;

        function next() : Object;

        function hasNext() : Boolean;

    }
}
