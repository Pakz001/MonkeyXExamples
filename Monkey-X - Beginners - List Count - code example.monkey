Import mojo

Global mylist:List<Int> = New List<Int>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        mylist.AddLast(10)
        mylist.AddLast(20)
    End Method
    Method OnUpdate()   
        If Rnd(100)<2 Then mylist.AddLast(Rnd(0,100))     
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "List Count example.",0,0
        DrawText "Number of items in list : " + mylist.Count,0,15
    End Method
End Class


Function Main()
    New MyGame()
End Function
