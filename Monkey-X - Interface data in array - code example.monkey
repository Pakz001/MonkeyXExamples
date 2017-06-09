'
' When building an interface on the screen it might
' be useful to put the data of it and store it elsewhere.
' Sometimes you might use the coordinates more then once
' and for other things like collision(mouse click) 
'
  
Import mojo

' Here we create 1 array with the coordinates 
' and width and height and 1 string for the
' text. Ends with c and s.
Global label1c:Int[] = [10,10,50,15] ' coordinates x,y,w,h
Global label1s:String = "Label1" ' text
Global label2c:Int[] = [10,30,50,15]
Global label2s:String = "Label2"

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(1)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
		' Here we call the drawlabel function.
		' We put one string and a array in it.
        drawlabel(label1s,label1c)
        drawlabel(label2s,label2c)
    End Method
End Class

' this function takes a string and a int array
' into the function.
Function drawlabel:Void(a:String,b:Int[])
	SetColor 255,55,55
	' draw a rect x,y,w,h
	DrawRect b[0],b[1],b[2],b[3]
	SetColor 255,255,255
	DrawText a,b[0]+b[2]/2,b[1]+b[3]/2,.5,.5
End Function

Function Main()
    New MyGame()
End Function
