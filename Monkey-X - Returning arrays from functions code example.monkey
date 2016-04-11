Import mojo

Global a:Int[5]

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        ' Fill the array with values
        a = filla()
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i=0 Until 5
            DrawText "Value of array : a["+i+"] = "+a[i],10,i*20+100
        Next
    End
End

' Function that fill the array with values
Function filla:Int[]()
    Local aa:Int[5]
    For Local i=0 Until 5
        aa[i] = i
    Next
    Return aa
End Function

Function Main()
    New MyGame()
End
