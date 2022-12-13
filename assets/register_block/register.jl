# This file was generated, do not modify it. # hide
max_health = ["max_health", "this", "4", "4", "WO", "0", "4'hf", "1", "1", "0"]
current_health = ["current_health", "this", "4", "0", "WO", "0", "0", "1", "1", "0"]

life = [max_health, current_health]

for field in life
    println("```verilog")
    println("$(field[1]).configure(")
    println("   .parent($(field[2])),")
    println("   .size($(field[3])),")
    println("   .lsb_pos($(field[4])),")
    println("   .access($(field[5])),")
    println("   .volatile($(field[6])),")
    println("   .reset($(field[7])),")
    println("   .has_reset($(field[8])),")
    println("   .is_rand($(field[9])),")
    println("   .individually_accessible($(field[10]))")
    println(");")
    println("```")
end