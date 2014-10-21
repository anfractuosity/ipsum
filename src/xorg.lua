
ffi = require("ffi")


ffi.cdef[[

typedef unsigned long VisualID;
typedef char *XPointer;
typedef unsigned long XID;                                                              
typedef XID Window;
typedef XID GContext;
typedef XID Colormap;
typedef int Bool;
typedef XID Drawable;
typedef XID Font;
typedef XID Pixmap;
typedef XID Cursor;
typedef XID Colormap;
typedef XID GContext;
typedef XID KeySym;
typedef unsigned long Atom;		/* Also in Xdefs.h */

typedef unsigned long Time;

/*
 * Extensions need a way to hang private data on some structures.
 */
typedef struct _XExtData {
        int number;             /* number returned by XRegisterExtension */
        struct _XExtData *next; /* next item on list of data for structure */
        int (*free_private)(    /* called to free private storage */
        struct _XExtData *extension
        );
        XPointer private_data;  /* data private to this extension. */
} XExtData;



typedef struct _XGC
{
    XExtData *ext_data;	/* hook for extension to hang data */
    GContext gid;	/* protocol ID for graphics context */
    /* there is more to this structure, but it is private to Xlib */
} *GC;




/*
 * Visual structure; contains information about colormapping possible.
 */
typedef struct {
	XExtData *ext_data;	/* hook for extension to hang data */
	VisualID visualid;	/* visual id of this visual */
	int class;		/* class of screen (monochrome, etc.) */
	unsigned long red_mask, green_mask, blue_mask;	/* mask values */
	int bits_per_rgb;	/* log base 2 of distinct color values */
	int map_entries;	/* color map entries */
} Visual;








/*
 * Depth structure; contains information for each possible depth.
 */
typedef struct {
	int depth;		/* this depth (Z) of the depth */
	int nvisuals;		/* number of Visual types at this depth */
	Visual *visuals;	/* list of visuals possible at this depth */
} Depth;










typedef struct {
        XExtData *ext_data;     /* hook for extension to hang data */
        struct _XDisplay *display;/* back pointer to display structure */
        Window root;            /* Root window id. */
        int width, height;      /* width and height of screen */
        int mwidth, mheight;    /* width and height of  in millimeters */
        int ndepths;            /* number of depths possible */
        Depth *depths;          /* list of allowable depths on the screen */
        int root_depth;         /* bits per pixel */
        Visual *root_visual;    /* root visual */
        GC default_gc;          /* GC for the root root visual */
        Colormap cmap;          /* default color map */
        unsigned long white_pixel;
        unsigned long black_pixel;      /* White and Black pixel values */
        int max_maps, min_maps; /* max and min color maps */
        int backing_store;      /* Never, WhenMapped, Always */
        Bool save_unders;
        long root_input_mask;   /* initial root input mask */
} Screen;



/*
 * Format structure; describes ZFormat data the screen will understand.     
 */                                                                         
typedef struct {                                                          
        XExtData *ext_data;     /* hook for extension to hang data */
        int depth;              /* depth of this image format */
        int bits_per_pixel;     /* bits/pixel at this depth */
        int scanline_pad;       /* scanline must padded to this multiple */
} ScreenFormat;
                  

typedef struct { 
     	XExtData *ext_data;     /* hook for extension to hang data */
        struct _XPrivate *private1;
        int fd;                 /* Network socket. */
        int private2;
        int proto_major_version;/* major version of server's X protocol */
        int proto_minor_version;/* minor version of servers X protocol */
        char *vendor;           /* vendor of the server hardware */
        XID private3;
        XID private4;
        XID private5;
        int private6;
        XID (*resource_alloc)(  /* allocator function */
                struct _XDisplay*
        );
        int byte_order;         /* screen byte order, LSBFirst, MSBFirst */
        int bitmap_unit;        /* padding and data requirements */
        int bitmap_pad;         /* padding requirements on bitmaps */
        int bitmap_bit_order;   /* LeastSignificant or MostSignificant */
        int nformats;           /* number of pixmap formats in list */
        ScreenFormat *pixmap_format;    /* pixmap format list */
        int private8;
        int release;            /* release of the server */
        struct _XPrivate *private9, *private10;
        int qlen;               /* Length of input event queue */
        unsigned long last_request_read; /* seq number of last event read */
        unsigned long request;  /* sequence number of last request. */
        XPointer private11;
        XPointer private12;
        XPointer private13;
        XPointer private14;
        unsigned max_request_size; /* maximum number 32 bit words in request*/
        struct _XrmHashBucketRec *db;
        int (*private15)(
                struct _XDisplay*
                );
        char *display_name;     /* "host:display" string used on this connect*/
        int default_screen;     /* default screen for operations */
        int nscreens;           /* number of screens on this server*/
        Screen *screens;        /* pointer to list of screens */
        unsigned long motion_buffer;    /* size of motion buffer */
        unsigned long private16;
        int min_keycode;        /* minimum defined keycode */
        int max_keycode;        /* maximum defined keycode */
        XPointer private17;
        XPointer private18;
        int private19;
        char *xdefaults;        /* contents of defaults from server */
} Display, *_XPrivDisplay;

/*
 * Definitions of specific events.
 */
typedef struct {
	int type;		/* of event */
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;	        /* "event" window it is reported relative to */
	Window root;	        /* root window that the event occurred on */
	Window subwindow;	/* child window */
	Time time;		/* milliseconds */
	int x, y;		/* pointer x, y coordinates in event window */
	int x_root, y_root;	/* coordinates relative to root */
	unsigned int state;	/* key or button mask */
	unsigned int keycode;	/* detail */
	Bool same_screen;	/* same screen flag */
} XKeyEvent;
typedef XKeyEvent XKeyPressedEvent;
typedef XKeyEvent XKeyReleasedEvent;

typedef struct {
	int type;		/* of event */
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;	        /* "event" window it is reported relative to */
	Window root;	        /* root window that the event occurred on */
	Window subwindow;	/* child window */
	Time time;		/* milliseconds */
	int x, y;		/* pointer x, y coordinates in event window */
	int x_root, y_root;	/* coordinates relative to root */
	unsigned int state;	/* key or button mask */
	unsigned int button;	/* detail */
	Bool same_screen;	/* same screen flag */
} XButtonEvent;
typedef XButtonEvent XButtonPressedEvent;
typedef XButtonEvent XButtonReleasedEvent;

typedef struct {
	int type;		/* of event */
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;	        /* "event" window reported relative to */
	Window root;	        /* root window that the event occurred on */
	Window subwindow;	/* child window */
	Time time;		/* milliseconds */
	int x, y;		/* pointer x, y coordinates in event window */
	int x_root, y_root;	/* coordinates relative to root */
	unsigned int state;	/* key or button mask */
	char is_hint;		/* detail */
	Bool same_screen;	/* same screen flag */
} XMotionEvent;
typedef XMotionEvent XPointerMovedEvent;

typedef struct {
	int type;		/* of event */
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;	        /* "event" window reported relative to */
	Window root;	        /* root window that the event occurred on */
	Window subwindow;	/* child window */
	Time time;		/* milliseconds */
	int x, y;		/* pointer x, y coordinates in event window */
	int x_root, y_root;	/* coordinates relative to root */
	int mode;		/* NotifyNormal, NotifyGrab, NotifyUngrab */
	int detail;
	/*
	 * NotifyAncestor, NotifyVirtual, NotifyInferior,
	 * NotifyNonlinear,NotifyNonlinearVirtual
	 */
	Bool same_screen;	/* same screen flag */
	Bool focus;		/* boolean focus */
	unsigned int state;	/* key or button mask */
} XCrossingEvent;
typedef XCrossingEvent XEnterWindowEvent;
typedef XCrossingEvent XLeaveWindowEvent;

typedef struct {
	int type;		/* FocusIn or FocusOut */
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;		/* window of event */
	int mode;		/* NotifyNormal, NotifyWhileGrabbed,
				   NotifyGrab, NotifyUngrab */
	int detail;
	/*
	 * NotifyAncestor, NotifyVirtual, NotifyInferior,
	 * NotifyNonlinear,NotifyNonlinearVirtual, NotifyPointer,
	 * NotifyPointerRoot, NotifyDetailNone
	 */
} XFocusChangeEvent;
typedef XFocusChangeEvent XFocusInEvent;
typedef XFocusChangeEvent XFocusOutEvent;

/* generated on EnterWindow and FocusIn  when KeyMapState selected */
typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	char key_vector[32];
} XKeymapEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	int x, y;
	int width, height;
	int count;		/* if non-zero, at least this many more */
} XExposeEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Drawable drawable;
	int x, y;
	int width, height;
	int count;		/* if non-zero, at least this many more */
	int major_code;		/* core is CopyArea or CopyPlane */
	int minor_code;		/* not defined in the core */
} XGraphicsExposeEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Drawable drawable;
	int major_code;		/* core is CopyArea or CopyPlane */
	int minor_code;		/* not defined in the core */
} XNoExposeEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	int state;		/* Visibility state */
} XVisibilityEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window parent;		/* parent of the window */
	Window window;		/* window id of window created */
	int x, y;		/* window location */
	int width, height;	/* size of window */
	int border_width;	/* border width */
	Bool override_redirect;	/* creation should be overridden */
} XCreateWindowEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
} XDestroyWindowEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
	Bool from_configure;
} XUnmapEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
	Bool override_redirect;	/* boolean, is override set... */
} XMapEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window parent;
	Window window;
} XMapRequestEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
	Window parent;
	int x, y;
	Bool override_redirect;
} XReparentEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
	int x, y;
	int width, height;
	int border_width;
	Window above;
	Bool override_redirect;
} XConfigureEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
	int x, y;
} XGravityEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	int width, height;
} XResizeRequestEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window parent;
	Window window;
	int x, y;
	int width, height;
	int border_width;
	Window above;
	int detail;		/* Above, Below, TopIf, BottomIf, Opposite */
	unsigned long value_mask;
} XConfigureRequestEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window event;
	Window window;
	int place;		/* PlaceOnTop, PlaceOnBottom */
} XCirculateEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window parent;
	Window window;
	int place;		/* PlaceOnTop, PlaceOnBottom */
} XCirculateRequestEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	Atom atom;
	Time time;
	int state;		/* NewValue, Deleted */
} XPropertyEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	Atom selection;
	Time time;
} XSelectionClearEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window owner;
	Window requestor;
	Atom selection;
	Atom target;
	Atom property;
	Time time;
} XSelectionRequestEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window requestor;
	Atom selection;
	Atom target;
	Atom property;		/* ATOM or None */
	Time time;
} XSelectionEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	Colormap colormap;	/* COLORMAP or None */
	Bool new;
	int state;		/* ColormapInstalled, ColormapUninstalled */
} XColormapEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;
	Atom message_type;
	int format;
	union {
		char b[20];
		short s[10];
		long l[5];
		} data;
} XClientMessageEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window window;		/* unused */
	int request;		/* one of MappingModifier, MappingKeyboard,
				   MappingPointer */
	int first_keycode;	/* first keycode */
	int count;		/* defines range of change w. first_keycode*/
} XMappingEvent;

typedef struct {
	int type;
	Display *display;	/* Display the event was read from */
	XID resourceid;		/* resource id */
	unsigned long serial;	/* serial number of failed request */
	unsigned char error_code;	/* error code of failed request */
	unsigned char request_code;	/* Major op-code of failed request */
	unsigned char minor_code;	/* Minor op-code of failed request */
} XErrorEvent;

typedef struct {
	int type;
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;/* Display the event was read from */
	Window window;	/* window on which event was requested in event mask */
} XAnyEvent;


/***************************************************************
 *
 * GenericEvent.  This event is the standard event for all newer extensions.
 */

typedef struct
    {
    int            type;         /* of event. Always GenericEvent */
    unsigned long  serial;       /* # of last request processed */
    Bool           send_event;   /* true if from SendEvent request */
    Display        *display;     /* Display the event was read from */
    int            extension;    /* major opcode of extension that caused the event */
    int            evtype;       /* actual event type. */
    } XGenericEvent;

typedef struct {
    int            type;         /* of event. Always GenericEvent */
    unsigned long  serial;       /* # of last request processed */
    Bool           send_event;   /* true if from SendEvent request */
    Display        *display;     /* Display the event was read from */
    int            extension;    /* major opcode of extension that caused the event */
    int            evtype;       /* actual event type. */
    unsigned int   cookie;
    void           *data;
} XGenericEventCookie;

/*
 * this union is defined so Xlib can always use the same sized
 * event structure internally, to avoid memory fragmentation.
 */
typedef union _XEvent {
        int type;		/* must not be changed; first element */
	XAnyEvent xany;
	XKeyEvent xkey;
	XButtonEvent xbutton;
	XMotionEvent xmotion;
	XCrossingEvent xcrossing;
	XFocusChangeEvent xfocus;
	XExposeEvent xexpose;
	XGraphicsExposeEvent xgraphicsexpose;
	XNoExposeEvent xnoexpose;
	XVisibilityEvent xvisibility;
	XCreateWindowEvent xcreatewindow;
	XDestroyWindowEvent xdestroywindow;
	XUnmapEvent xunmap;
	XMapEvent xmap;
	XMapRequestEvent xmaprequest;
	XReparentEvent xreparent;
	XConfigureEvent xconfigure;
	XGravityEvent xgravity;
	XResizeRequestEvent xresizerequest;
	XConfigureRequestEvent xconfigurerequest;
	XCirculateEvent xcirculate;
	XCirculateRequestEvent xcirculaterequest;
	XPropertyEvent xproperty;
	XSelectionClearEvent xselectionclear;
	XSelectionRequestEvent xselectionrequest;
	XSelectionEvent xselection;
	XColormapEvent xcolormap;
	XClientMessageEvent xclient;
	XMappingEvent xmapping;
	XErrorEvent xerror;
	XKeymapEvent xkeymap;
	XGenericEvent xgeneric;
	XGenericEventCookie xcookie;
	long pad[24];
} XEvent;

	
extern int XNextEvent(            
    Display*            /* display */,                                   
    XEvent*             /* event_return */                              
);                                                                           
 
/*
 * X function declarations.
 */
extern Display *XOpenDisplay(
    char*	/* display_name */
);


extern char *XSetLocaleModifiers(
    const char*		/* modifier_list */
);

extern int XOpenIM(
    Display*			/* dpy */,
    void *	/* rdb */,
    char*			/* res_name */,
    char*			/* res_class */
);

extern int XSelectInput(
    Display*		/* display */,
    Window		/* w */,
    long		/* event_mask */
);
 
extern int XDefaultScreen(
    Display*		/* display */
);

extern int XGetWindowProperty(
    Display*		/* display */,
    Window		/* w */,
    Atom		/* property */,
    long		/* long_offset */,
    long		/* long_length */,
    Bool		/* delete */,
    Atom		/* req_type */,
    Atom*		/* actual_type_return */,
    int*		/* actual_format_return */,
    unsigned long*	/* nitems_return */,
    unsigned long*	/* bytes_after_return */,
    unsigned char**	/* prop_return */
);

extern Atom XInternAtom(
    Display*		/* display */,
    char*	/* atom_name */,
    Bool		/* only_if_exists */
);

typedef struct {
	int type;
	Display *display;	/* Display the event was read from */
	XID resourceid;		/* resource id */
	unsigned long serial;	/* serial number of failed request */
	unsigned char error_code;	/* error code of failed request */
	unsigned char request_code;	/* Major op-code of failed request */
	unsigned char minor_code;	/* Minor op-code of failed request */
} XErrorEvent;

typedef int (*XErrorHandler) (	    /* WARNING, this type not in Xlib spec */
    Display*	   	/* display */,
    XErrorEvent*   	/* error_event */
);


extern XErrorHandler XSetErrorHandler (
    XErrorHandler	/* handler */
);

]]



--[[

#define NoEventMask			0L
#define KeyPressMask			(1L<<0)  
#define KeyReleaseMask			(1L<<1)  
#define ButtonPressMask			(1L<<2)  
#define ButtonReleaseMask		(1L<<3)  
#define EnterWindowMask			(1L<<4)  
#define LeaveWindowMask			(1L<<5)  
#define PointerMotionMask		(1L<<6)  
#define PointerMotionHintMask		(1L<<7)  
#define Button1MotionMask		(1L<<8)  
#define Button2MotionMask		(1L<<9)  
#define Button3MotionMask		(1L<<10) 
#define Button4MotionMask		(1L<<11) 
#define Button5MotionMask		(1L<<12) 
#define ButtonMotionMask		(1L<<13) 
#define KeymapStateMask			(1L<<14)
#define ExposureMask			(1L<<15) 
#define VisibilityChangeMask		(1L<<16) 
#define StructureNotifyMask		(1L<<17) 
#define ResizeRedirectMask		(1L<<18) 
#define SubstructureNotifyMask		(1L<<19) 
#define SubstructureRedirectMask	(1L<<20) 
#define FocusChangeMask			(1L<<21) 
#define PropertyChangeMask		(1L<<22) 
#define ColormapChangeMask		(1L<<23) 
#define OwnerGrabButtonMask		(1L<<24) 

]]--


--- #define ScreenOfDisplay(dpy, scr)(&((_XPrivDisplay)dpy)->screens[scr])
-- #define RootWindow(dpy, scr) 	(ScreenOfDisplay(dpy,scr)->root)







local x11 = ffi.load("/usr/lib/x86_64-linux-gnu/libX11.so.6")
s = ":0.0"

dst = ffi.new("char[?]",#s,s)
evt = ffi.new("XEvent")

display = x11.XOpenDisplay(nil)
--modifiers = x11.XSetLocaleModifiers ("@im=none");                                                                                                                                                               
if(x11.XOpenIM(display,nil,nil,nil)==nil) then
	print("failed")
end

dscreen = x11.XDefaultScreen(display)
rwindow = display.screens[dscreen].root

--window = x11.RootWindow(display,screen)

x11.XSelectInput(display,rwindow,4194304)

while true do
	x11.XNextEvent(display,evt)
	--print("WINDOWID ",evt.xproperty.window)

	nitems = ffi.new("unsigned long")
	nbytes = ffi.new("unsigned long")
	data = ffi.new("unsigned char*")
	
	atom = "_NET_ACTIVE_WINDOW"
	at = ffi.new("char[?]",#atom,atom)
	act = ffi.new("unsigned long") 
	fmt = ffi.new("int")

        netactivewindow_atm = x11.XInternAtom(display,at,false)

	nitemsptr = ffi.new("unsigned long[1]",nitems)
	dataptr = ffi.new("unsigned char*[1]",data)
	actptr = ffi.new("unsigned long[1]",act)
	fmtptr = ffi.new("int[1]",fmt)
	nbytesptr = ffi.new("unsigned long[1]",nbytes)

	if netactivewindow_atm == nil then
		print("BadATM")
	end

	eflag = 0

	x11.XSetErrorHandler( function(display,xerror) 			
			
				--print("error",xerror.error_code)
				eflag = 1
			end );
	
	stat = x11.XGetWindowProperty(display,rwindow,netactivewindow_atm,0,2147483647,false,0,actptr,fmtptr,nitemsptr,nbytesptr,dataptr)

	if(stat ~= 0) then
		print("error")
		os.exit(1)
	end


	if actptr[0] > 0 then 
	        window = ffi.cast("unsigned long*",dataptr[0])[0]                                               
		if window == 0 then
		else 
		--	print("about to get stuff from ",window)
	 stat = x11.XGetWindowProperty(display,window,39,0,2147483647,false,0,actptr,fmtptr,nitemsptr,nbytesptr,dataptr)
		
		if stat == 0 then 
			print("On window ",ffi.string(dataptr[0]))
		end
		end
	end
	x11.XSetErrorHandler(nil)	

end
