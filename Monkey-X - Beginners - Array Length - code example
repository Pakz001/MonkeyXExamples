Import mojo

Global myarray:Int[10]

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        'fill the array with numbers
        For Local i=0 Until myarray.Length
            myarray[i] = i
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Array Length example.",0,0
        DrawText "myarray.Length = "+myarray.Length,0,15
        ' print the array
        For Local y=0 Until myarray.Length
            DrawText "myarray value " + y + " = " + myarray[y],20,y*15+45
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
