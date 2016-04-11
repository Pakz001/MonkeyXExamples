Import mojo

Class test
    Field x:Int,y:Int,message:String
    Method New(x:Int,y:Int,message:String)
        Self.x = x
        Self.y = y
        Self.message = message
    End Method
    Method draw(x:Int,y:Int)
        Local ps:String =     "x:"+Self.x+" y:"+
                            Self.y+" Message :"+Self.message
        SetColor 255,255,255
        DrawText ps,x,y
    End Method
End Class

Global a:List< List< test > > = New List< List< test > >

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        ' create temp lists
         Local b:List<test> = New List<test>
         Local c:List<test> = New List<test>
         ' add the lists to the a list
        a.AddLast(b)
        a.AddLast(c)
        Local cnt:Int=0
        ' Loop through the lists in 'a'
        For Local i:=Eachin a
            'set some data
            Local s:String
            If cnt=0 Then s="First List"
            If cnt=1 Then s="Second List"
            i.AddLast(New test(0,15+cnt*15,s))
            cnt+=1
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        ' loop through all lists in a
        For Local i:=Eachin a
            'loop through the items in list b and c
            For Local ii:=Eachin i
                ii.draw(ii.x,ii.y)
            Next
        Next
        DrawText "Lists in List example..",0,0
    End Method
End Class

Function Main()
    New MyGame()
End Function
