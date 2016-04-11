Import mojo

Const numhamsters:Int=4
Global tilewidth:Int=20
Global tileheight:Int=20
Global mapwidth:Int=640/tilewidth
Global mapheight:Int=480/tileheight
Global searchmap:Int[][] = New Int[mapwidth][]

Class hamsters
    Field x:Int,y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
    Method update()
        Local x1:Int=0
        Local y1:Int=0
        Local val:Int=searchmap[x][y]
        searchmap[x][y] += 1
        Local exitloop:Bool = False
        Local cnt:Int=0
        While exitloop = False
            cnt+=1
            For Local y2=-1 To 1
            For Local x2=-1 To 1
                Local x3:Int=x+x2
                Local y3:Int=y+y2
                If x3>=0 And y3>= 0 And x3<mapwidth And y3<mapheight
                    If searchmap[x3][y3] <= val Or cnt>10
                        If Rnd(10)<2
                        x1 = x3 ; y1 = y3
                        exitloop = True
                        Exit
                        End If
                    End If
                End If
            Next
            Next
        Wend
        x=x1
        y=y1        
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
    End Method
End Class

Global hamster:List<hamsters> = New List<hamsters>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(20)
        For Local i=0 Until mapwidth
            searchmap[i] = New Int[mapheight]
        Next
        For Local i=0 Until numhamsters
            hamster.AddLast(New hamsters(Rnd(2,mapwidth-4),Rnd(2,mapheight-4)))
        Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin hamster
            i.update
        Next        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Local m:String=searchmap[x][y]
            PushMatrix()
            Scale 0.7,0.7
            DrawText m,(x*tilewidth)*1.4,(y*tileheight)*1.4
            PopMatrix()
        Next
        Next
        For Local i:=Eachin hamster
            i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
