import std.stdio : writeln;
import swap_op;

mixin (SWAP_OP(q{
    void bubblesort(T)(T[] array)
    {
        foreach (base; 0 .. array.length - 1)
        {
            foreach_reverse (i; base .. array.length - 1)
            {
                if (array[i] > array[i + 1])
                {
                    array[i] :=: array[i + 1];
                }
            }
        }
    }

    void main()
    {
        import std.stdio : writeln;

        int[] array = [3, 1, 4, 1, 5, 9, 2];
        array.bubblesort();
        writeln(array);
    }
}));
