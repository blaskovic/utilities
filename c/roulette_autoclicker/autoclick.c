#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <X11/Xlib.h>

typedef struct object_coord {
	int x;
	int y;
} TCoord;

enum COLORS
{
	GREEN,
	RED,
	BLACK,
};

enum STATES
{
	ST_START,
	ST_CASCADE,
};

// Simulate mouse click
void click (Display *display, int button)
{
	// Create and setting up the event
	XEvent event;
	memset (&event, 0, sizeof (event));
	event.xbutton.button = button;
	event.xbutton.same_screen = True;
	event.xbutton.subwindow = DefaultRootWindow (display);

	while (event.xbutton.subwindow)
	{
		event.xbutton.window = event.xbutton.subwindow;
		XQueryPointer (display, event.xbutton.window,
						&event.xbutton.root, &event.xbutton.subwindow,
						&event.xbutton.x_root, &event.xbutton.y_root,
						&event.xbutton.x, &event.xbutton.y,
						&event.xbutton.state);
	}

	// Press
	event.type = ButtonPress;

	if (XSendEvent (display, PointerWindow, True, ButtonPressMask, &event) == 0)
		fprintf (stderr, "Error to send the event!\n");

	XFlush (display);
	usleep (1);

	// Release
	event.type = ButtonRelease;
	if (XSendEvent (display, PointerWindow, True, ButtonReleaseMask, &event) == 0)
		fprintf (stderr, "Error to send the event!\n");

	XFlush (display);
	usleep (1);
}

// Move mouse pointer
void move (Display *display, int x, int y)
{
	XWarpPointer (display, None, None, 0,0,0,0, x, y);
	XFlush (display);
	usleep (1);
}

// Get mouse coordinates
void coords (Display *display, int *x, int *y)
{
	XEvent event;
	XQueryPointer (display, DefaultRootWindow (display),
					&event.xbutton.root, &event.xbutton.window,
					&event.xbutton.x_root, &event.xbutton.y_root,
					&event.xbutton.x, &event.xbutton.y,
					&event.xbutton.state);
	*x = event.xbutton.x;
	*y = event.xbutton.y;
}

void moveReset(Display *display) {
	int xTmp=0,yTmp=0;
	coords(display, &xTmp, &yTmp);
	move(display, -xTmp, -yTmp);
}

void moveTo(Display *display, int x, int y) {
	int xTmp=0,yTmp=0;
	coords(display, &xTmp, &yTmp);
	XWarpPointer(display, None, None, 0, 0, 0, 0, -xTmp, -yTmp);
	XWarpPointer(display, None, None, 0, 0, 0, 0, x, y);
	XFlush(display);
	usleep(1);
}

// Get pixel color at coordinates x,y
void pixel_color (Display *display, int x, int y, XColor *color)
{
	XImage *image;
	image = XGetImage (display, DefaultRootWindow (display), x, y, 1, 1, AllPlanes, XYPixmap);
	color->pixel = XGetPixel (image, 0, 0);
	XFree (image);
	XQueryColor (display, DefaultColormap(display, DefaultScreen (display)), color);
}

int get_color(Display *display, int x, int y)
{
	XColor color;

	pixel_color(display, x, y, &color);

	if(color.red > 50000) return RED;
	if(color.green > 50000) return GREEN;

	return BLACK;
}

void count(int c)
{
	while (c > 0)
	{
		printf ("\b\b\b %d...", c);
		fflush (stdout);
		sleep (1);
		c--;
	}
	printf ("\n");
}

void ask_for(char *what, int c)
{
	printf ("%s   ", what);
	fflush (stdout);
	count(c);
}

void print_coords(char *what, TCoord coords)
{
	printf("%s x: %d  y: %d\n", what, coords.x, coords.y);
}

void clickXY(Display *display, int x, int y)
{
	srand(time(NULL));
	int xi = rand() % 4;
	int yi = rand() % 4;

	moveTo(display, x + xi, y + yi);
	click(display, Button1);
}

void my_sleep()
{
	srand(time(NULL));
	int random = (500 + (rand() % 2000)) * 1000;
	usleep(random);
}

// START HERE
int main (int argc, char *argv[])
{ 
	int starting = 3;
	int x = 0;
	int y = 0;

	// Open X display
	Display *display = XOpenDisplay (NULL);
	if (display == NULL)
	{
		fprintf (stderr, "Can't open display!\n");
		return -1;
	}

	// Cakame na start
	ask_for("Startujeme za", 3);

	// co potrebujeme
	TCoord spin, check_color, bet_red, bet_black, clear_all;

	// nacitavanie
	ask_for("SPIN", 5);
	coords(display, &spin.x, &spin.y);
	ask_for("Ziskaj farbu", 5);
	coords(display, &check_color.x, &check_color.y);
	ask_for("Vsad cervena", 5);
	coords(display, &bet_red.x, &bet_red.y);
	ask_for("Vsad cierna", 5);
	coords(display, &bet_black.x, &bet_black.y);
	ask_for("Clear all", 5);
	coords(display, &clear_all.x, &clear_all.y);

	print_coords("Spin: ", spin);
	print_coords("Ziskaj farbu: ", check_color);
	print_coords("Vsad cervenu: ", bet_red);
	print_coords("Vsad ciernu: ", bet_black);
	print_coords("Clear all: ", clear_all);
	
	// End-state machine
	int num_of_same = 15; // THIIIIS
	int was_same = 1;
	int last_color = -1;
	int actual_color = -1;

	
	int cascade_arr[15] = {1, 2, 4, 3, 4, 8, 7, 8, 16, 15, 16, 32, 31, 32, 64};
	int cascade_index = 0;
	int cascade_level = 0;
	int cash = 0;

	int num_of_bets = 0;
	
	int state = ST_START;

	int a = 0;

	while(1)
	{
		switch(state)
		{
			case ST_START:
		
				clickXY(display, spin.x, spin.y);
				my_sleep();
				actual_color = get_color(display, check_color.x, check_color.y);
				my_sleep();
				
				if(actual_color == last_color)
				{
					was_same++;
				}
				else
				{
					was_same = 1;
					if(actual_color != GREEN)
						last_color = actual_color;
				}

				// Have enough
				if(was_same == (num_of_same + cascade_level * 3))
				{
					state = ST_CASCADE;
				}
		
			break;

			case ST_CASCADE:
				
				num_of_bets = cascade_arr[cascade_level * 3 + cascade_index];

				// Bet different
				if(last_color == RED)
				{
					for(a = 1; a <= num_of_bets; a++)
					{
						clickXY(display, bet_black.x, bet_black.y);
						my_sleep();
						cash--;
					}
				}
				else
				{
					for(a = 1; a <= num_of_bets; a++)
					{
						clickXY(display, bet_red.x, bet_red.y);
						my_sleep();
						cash--;
					}
				}

				// Spin
				clickXY(display, spin.x, spin.y);
				my_sleep();

				actual_color = get_color(display, check_color.x, check_color.y);
				
				// Loose
				if(actual_color == last_color)
				{
					cascade_index++;
					if(cascade_index > 2)
					{
						cascade_index = 0;
						cascade_level++;

						// You are doomed
						if(cascade_level > 4)
						{
							printf("Poor guy ;( \n");
							XCloseDisplay (display);
							return 0;
						}
					}
				}
				// Win
				else
				{
					cascade_index = 0;
					
					if(cascade_level == 0)
					{
						clickXY(display, bet_red.x, bet_red.y);
						my_sleep();
						clickXY(display, clear_all.x, clear_all.y);
						my_sleep();
						state = ST_START;
						cash = 0;
						printf("WIIIIIIIIIIIN!\n");
					}
					else
					{
						cash += num_of_bets * 2;

						if(cash >= 0)
						{
							cash = 0;
							cascade_level = 0;
							cascade_index = 0;
							state = ST_START;
							printf("WIIIIIIIIIIIN!\n");
						}

						clickXY(display, bet_red.x, bet_red.y);
						my_sleep();
						clickXY(display, clear_all.x, clear_all.y);
						my_sleep();
						state = ST_START;
					}
				}



			break;
		}
	}
	
	
	// Close X display and exit
	XCloseDisplay (display);
	return 0;
}
