#define STR(X) #X
#define ASSTR(X) STR(X)
#define QSTR(X) " '" STR(X) "' "

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Ubuntu Mono:size=14" };
static const char dmenufont[]       = "Ubuntu Mono:size=14";

#define DMENUFONT Ubuntu Mono:size=14
#define COL_BASE #191724
#define COL_SURFACE #1f1d2e
#define COL_OVERLAY #26233a
#define COL_MUTED #6e6a86
#define COL_SUBTLE #908caa
#define COL_TEXT #e0def4
#define COL_LOVE #eb6f92
#define COL_GOLD #f6c177
#define COL_ROSE #ebbcba
#define COL_PINE #31748f
#define COL_FOAM #9ccfd8
#define COL_IRIS #c4a7e7
static const char col_base[] = ASSTR(COL_BASE);
static const char col_surface[] = ASSTR(COL_SURFACE);
static const char col_overlay[] = ASSTR(COL_OVERLAY);
static const char col_muted[] = ASSTR(COL_MUTED);
static const char col_subtle[] = ASSTR(COL_SUBTLE);
static const char col_text[] = ASSTR(COL_TEXT);
static const char col_love[] = ASSTR(COL_LOVE);
static const char col_gold[] = ASSTR(COL_GOLD);
static const char col_rose[] = ASSTR(COL_ROSE);
static const char col_pine[] = ASSTR(COL_PINE);
static const char col_foam[] = ASSTR(COL_FOAM);
static const char col_iris[] = ASSTR(COL_IRIS);

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_foam, col_base, col_overlay },
	[SchemeSel]  = { col_text, col_pine,  col_pine  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
// static const char *dmenucmd[] = {"dmenu_run", "-fn", dmenufont, "-nb", col_base, "-nf", col_muted, "-sb", col_pine, "-sf", col_text, NULL };
static const char *dmenucmd[] = {"j4-dmenu-desktop", "--dmenu", "dmenu -i -fn" QSTR(DMENUFONT) "-nb" QSTR(COL_BASE) "-nf" QSTR(COL_FOAM) "-sb" QSTR(COL_PINE) "-sf" QSTR(COL_TEXT), NULL };
static const char *termcmd[]  = { "alacritty", NULL };
static const char *runchrome[]  = { "google-chrome", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },
	{ Mod4Mask,                     XK_c,      spawn,          {.v = termcmd } },
	{ Mod4Mask,                     XK_s,      spawn,          {.v = runchrome } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ Mod4Mask,                     XK_space,  setlayout,      {0} },
	{ Mod4Mask|ShiftMask,           XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

