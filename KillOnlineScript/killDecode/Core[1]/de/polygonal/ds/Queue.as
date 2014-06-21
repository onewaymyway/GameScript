package de.polygonal.ds
{

    public interface Queue extends Collection
    {

        public function Queue() : void;

        function peek() : Object;

        function enqueue(param1:Object) : void;

        function dequeue() : Object;

        function back() : Object;

    }
}
