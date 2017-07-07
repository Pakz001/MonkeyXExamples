'import mojo needs to be called so that it recognizes the
'mojo commands.
Import mojo 

Class MyGame Extends App
	Field timedown:Int
	Field mytext:String = "Press the mouse."
    Method OnCreate() 'This method is only run when the program starts
        SetUpdateRate(10) 'how many times should the screen be redrawn per second
    End Method
    Method OnUpdate() ' Run every frame(put keyinput ect. in here)
    	timedown-=1
    	If timedown <= 0 Then
    		timedown = 0
    		mytext = "Press the mouse"
    	End If
    	If MouseHit(MOUSE_LEFT) Then mytext = "The left mouse was last pressed." ; timedown=10
    	' Flash does not recognize middle and right mouse buttons....
    	If MouseHit(MOUSE_RIGHT) Then mytext = "The Right mouse was last pressed."; timedown=10
    	If MouseHit(MOUSE_MIDDLE) Then mytext = "The Middle mouse was last pressed."; timedown=10
    End Method    
    Method OnRender() 'Drawing commands here.
    	' Clear the screen with color 0,0,0
        Cls 0,0,0 
        ' Set the Color of the next drawing commands
        SetColor 255,255,255
        ' Draw text to the screen. txt,x,y
        DrawText mytext,0,0
    End Method
End Class

Function Main()
    New MyGame()
End Function
