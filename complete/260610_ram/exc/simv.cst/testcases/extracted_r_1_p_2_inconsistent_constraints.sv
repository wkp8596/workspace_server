class c_1_2;
    int num = 0;

    constraint c_num_this    // (constraint_mode = ON) (../tb/ram_sequence.sv:32)
    {
       (num inside {[10:30]});
    }
endclass

program p_1_2;
    c_1_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0xzz001xzzx100x11z0x1zzx1zxz0zz0zxzxxzzxxzxzzxzxzxzxxzxxxzxzzzzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
