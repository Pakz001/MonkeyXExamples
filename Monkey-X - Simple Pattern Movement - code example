Import mojo

' x : -1 = left , 1 = right
' y : -1 = up , 1 = down
Global path1x:Int[] = [1,1,0,0,-1,-1,0,0]
Global path1y:Int[] = [0,0,1,1,0,0,-1,-1]
Global tilewidth:Int=32
Global tileheight:Int=32

Class ai
    Field x:Int,y:Int
    Field cpathpos:Int=0
    Field delay
    Field delay2:Int
    Method New(x:Int,y:Int,delay:Int)
        Self.x = x
        Self.y = y
        Self.delay2 = delay
        Self.delay = 0
    End Method
    Method update()
        delay-=1
        If delay>0 Then Return
        delay = delay2
        Select path1x[cpathpos]
            Case 1;x+=1
            Case -1;x-=1
        End Select
        Select path1y[cpathpos]
            Case 1;y+=1
            Case -1;y-=1
        End Select
        cpathpos+=1
        If cpathpos >= path1x.Length Then
            cpathpos=0
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval     x*tilewidth,y*tileheight,
                    tilewidth,tileheight
    End Method
End Class

Global myai:List<ai> = New List<ai>

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        Local cnt:Int=10
        For Local y=0 Until 5
        For Local x=0 Until 5
            cnt+=1
            myai.AddLast(New ai(x*5,y*5,cnt))
        Next
        Next
    End Method

    Method OnUpdate()
        For Local i:= Eachin myai
            i.update
        Next
    End Method
    
    Method OnRender()
        Cls 0,0,0        
        For Local i:=Eachin myai
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Monkey-X Pattern Movement example.",10,10
    End Method
    
End Class


Function Main()
    New MyApp
End Function
