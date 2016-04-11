Import mojo

Global a:List<test>[] = New List<test>[10]

Class test
    Field x:Int,y:Int,m:String
    Method New(x:Int,y:Int,m:String)
        Self.x = x
        Self.y = y
        Self.m = m
    End Method
End Class


Class MyGame Extends App
    Method OnCreate()
        a[0] = New List<test>        
        a[1] = New List<test>
        a[0].AddLast(New test(10,10,"List 1"))
        a[1].AddLast(New test(20,20,"List 2"))
        SetUpdateRate(60)
    End Method    
    Method OnUpdate()
    End Method    
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Lists inside arrays example.",0,0
        For Local i:=Eachin a[0]
            Local m:String=i.x+","+i.y+","+i.m
            DrawText m,0,15
        Next
        For Local i:=Eachin a[1]
            Local m:String=i.x+","+i.y+","+i.m
            DrawText m,0,30
        Next
    End Method    
End Class

Function Main()
    New MyGame()
End Function
