Import mojo

Class MyGame Extends App
    Method OnCreate() 'This method is only run when the program starts
        SetUpdateRate(10) 'how many times should the screen be redrawn per second
    End Method
    Method OnUpdate() ' Run every frame(put keyinput ect. in here)
    End Method    
    Method OnRender() 'Drawing commands here.
    	' Clear the screen with color 0,0,0
        Cls 0,0,0 
        ' Set the Color of the next drawing commands
        ' red(0..255),green(0..255),blue(0..255)
        SetColor 255,255,255
        DrawText "This is text..",0,0
        ' Set the drawing color for the next drawing commands
        SetColor 0,255,255
        ' Draw a rectangle
        DrawRect 100,100,200,200
    End Method
End Class

Function Main()
    New MyGame()
End Function
