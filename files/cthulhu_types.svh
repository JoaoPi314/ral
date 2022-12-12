typedef struct packed{
    logic [3:0] max_health;
    logic [3:0] current_health;
} life_st;

typedef struct packed{
    logic [3:0] max_sanity;
    logic [3:0] current_sanity;
} sanity_st;

typedef struct packed{
    logic [1:0] reserved;
    logic       is_sane;
    logic       is_going_mad;
    logic       is_mad;
    logic       is_healthy;
    logic       is_wounded;
    logic       is_dead;

} status_st;
