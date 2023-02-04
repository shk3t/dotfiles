#define CMDLENGTH 50
#define DELIMITER " | "
// #define CLICKABLE_BLOCKS
// #define BAR_STATUSCMD_PATCH 1
// #define BAR_STATUS_PATCH 0

const Block blocks[] = {
    BLOCK("sb-volume", 0, 2),
    BLOCK("sb-light", 0, 1),
    BLOCK("sb-battery", 5, 3),
    BLOCK("sb-internet", 5, 4),
    BLOCK("sb-layout", 0, 5),
    BLOCK("sb-datetime", 5, 6),
};

// BLOCK("sb-memory",  5,    20),
// BLOCK("sb-loadavg", 5,    21),
// BLOCK("sb-disk",    1800, 19),
// BLOCK("sb-mic",     1,    26),
// BLOCK("sb-mail",    1800, 17),
// BLOCK("sb-music",   0,    18),
// BLOCK("sb-record",  0,    27),
