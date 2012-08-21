import pyd.pyd;
import std.traits;

class MyClass {
    int _i;

    this(int i) {
        _i = i;
    }
    auto opBinary(string op, T)(T rhs) if(isIntegral!T) {
        static if(op == "+") {
            return ~_i + rhs;
        }else static if(op == "-") {
            return ~_i - rhs;
        }else static if(op == "*") {
            return -(_i * ~rhs);
        }else static assert(0);
    }

    int i() { return _i; }
    void i(int a) { _i = a; }


    int z(double d) {
        return cast(int)(_i * d);
    }

    string z(string s) {
        import std.string;
        return format("%s(%s)",s,_i);
    }

    int __radd__(int j) {
        return _i+j;
    }

}

extern(C) void PydMain() {
    module_init();
    wrap_class!(
            MyClass,
            Def!(MyClass.z, string function(string)),
            Property!(MyClass.i),
            Def!(MyClass.__radd__),
            //BinaryOperator!("+", int),
            //BinaryOperator!("-", int),
            //BinaryOperator!("*", int),
            Init!(void function(int)),
            )();
}
