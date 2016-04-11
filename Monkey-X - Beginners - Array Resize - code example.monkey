Import mojo

Global myarray:Int[10]

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        ' Resize the array from 10 to 20 here
        myarray = myarray.Resize(20)
        'fill the array with numbers
        For Local i=0 Until 20
            myarray[i] = i
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Array Resize example.",0,0
        ' print the array
        For Local y=0 Until 20
            DrawText "myarray value " + y + " = " + myarray[y],20,y*15+30
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
