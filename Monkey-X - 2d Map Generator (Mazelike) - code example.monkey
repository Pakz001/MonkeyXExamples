Import mojo

' This class holds the map.
' mapmaker selects a random pos in the map
' and then builds a wall there if there is space.
Class maptest
    Field tw:Int,th:Int
    Field w:Int,h:Int
    Field map:Int[][]
    Method New(w:Int,h:Int)
        Self.w = w
        Self.h = h
        tw = DeviceWidth()/w
        th = DeviceHeight()/h
        map = New Int[w][]
        For Local i=0 Until w
            map[i] = New Int[h]
        Next
        makemap        
    End Method
    'make the map
    Method makemap()
        Local exitloop:Bool=False
        Local exitcount:Int=0
        While exitloop = False
            Local x:Int=Rnd(0,w)
            Local y:Int=Rnd(0,h)
            If mappartisfree(x,y) = True
                exitcount=0
                ' dir = direction 1 to 4
                ' dis = distance of wall
                Local dir:Int=Rnd(1,5)
                Local dis:Int=Rnd(4,10)
                makewall(x,y,dir,dis)
            Else
                exitcount+=1
            End If
            If exitcount>200 Then exitloop=True
        Wend
    End Method
    ' this method makes the walls
    Method makewall(x:Int,y:Int,dir:Int,dis:Int)
        ' px and py hold the wall and is drawn
        ' onto the map when the complete wall
        ' fits on the map.
        Local px:Int[dis]
        Local py:Int[dis]
        For Local i=0 Until dis
            px[i] = x
            py[i] = y
            Select dir
                Case 1;y-=1
                Case 2;x+=1
                Case 3;y+=1
                Case 4;x-=1
            End Select
            If Rnd(0,3) < 1 Then dir=Rnd(1,5)
            ' stay inside bounds or exit
            If x<0 Or x>=w Or y<0 Or y>=h Then Return
            ' if map position taken then exit
            If mappartisfree(x,y) = False Then Return
        Next
        ' here the wall is added to the map
        For Local i=0 Until dis
            map[px[i]][py[i]] = 1
        Next
    End Method
    ' check if the area around x,y is no wall
    Method mappartisfree:Bool(x,y)
        For Local y1=-1 To 1
        For Local x1=-1 To 1
            If x+x1>-1 And x+x1<w
            If y+y1>-1 And y+y1<h
                If map[x+x1][y+y1] = 1
                    Return False
                End If
            End If
            End If
        Next
        Next
        Return True
    End Method
    Method draw()
        SetColor 255,255,255
        For Local y=0 Until h
        For Local x=0 Until w
            If map[x][y] = 1
                DrawRect x*tw,y*th,tw,th
            End If
        Next
        Next
    End Method
End Class

Global mymaptest:maptest

Class MyGame Extends App
    Field mytime:Int
    Method OnCreate()
        SetUpdateRate(60)
        mymaptest = New maptest(Rnd(20,50),Rnd(15,30))
    End Method
    Method OnUpdate()  
        mytime+=1
        If KeyHit(KEY_SPACE) Or mytime>180
            mytime=0
            mymaptest = New maptest(Rnd(20,50),Rnd(15,30))
        End If      
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymaptest.draw
        SetColor 255,255,255
        DrawText "Monkey-X - Map generator - mazelike (if space then place)",10,10
    End Method
End Class


Function Main()
    New MyGame()
End Function
