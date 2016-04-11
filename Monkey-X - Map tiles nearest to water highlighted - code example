Import mojo

Const mapwidth:Int=640/8
Const mapheight:Int=480/8
Const tilewidth:Int=8
Const tileheight:Int=8
Global map:Int[mapwidth][]
Global seabordermap[mapwidth][]
Global numland:Int = 0
Global percland:Float = 1.7
Global showborder:Bool = False
Global makecnt:Int=0
Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(10)
        Seed = Rnd(1000)
        'Set up the map array to be multi dimensional
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
            seabordermap[i] = New Int[mapheight]
        Next
        ' make the map the first time
        makemap
        makeseaborders()
    End Method
    Method OnUpdate()
        makecnt+=1
        If makecnt > 50 Then
            ' how much land must it have numoflandtiles </mapsize/percland
            percland = Rnd(1.5,2.0)
            makemap
            makeseaborders
            makecnt = 0
        End If
        If KeyDown(KEY_SPACE) Then showborder = True Else showborder = False
    End Method
    Method OnRender()
        Cls 0,0,0 
        drawmap(showborder)
        SetColor 255,255,255
        DrawText "Area near sea highlighted - for patrolling ai.",0,0
        DrawText "Press space to highlight sea border area.",0,15
    End Method
End Class

Function makeseaborders:Void()
    ' erase any old data
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        seabordermap[x][y] = 0
    Next
    Next
    ' first line near to the sea tiles
    For Local y1=0 Until mapheight
    For Local x1=0 Until mapwidth
        Local cnt:Int=0
        If map[x1][y1] >= 5
        For Local y2=-1 To 1
        For Local x2=-1 To 1
            Local x3=x1+x2
            Local y3=y1+y2
            If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
                If map[x3][y3] < 5
                    cnt+=1
                End If
            End If
        Next
        Next
        If cnt>0 Then 
            seabordermap[x1][y1] = 1
        End If
        End If
    Next
    Next
    ' make temp array
    Local tmap:Int[mapwidth][]
    For Local i=0 Until mapwidth
        tmap[i] = New Int[mapheight]
    Next
    ' make land tile next to sea border tile a seaborder tile
    For Local y1=0 Until mapheight
    For Local x1=0 Until mapwidth
        If seabordermap[x1][y1] = 1
        For Local y2=-1 To 1
        For Local x2=-1 To 1
        Local x3 = x1+x2
        Local y3 = y1+y2
        If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
            If map[x3][y3] >= 5
                tmap[x3][y3] = 1
            End If
        End If
        Next
        Next
        End If
    Next
    Next
    'put the temp array into the seaborderarray
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If tmap[x][y] > 0 Then seabordermap[x][y] = 1
    Next
    Next
End Function

Function drawmap:Void(showborder:Bool=True)
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Local val:Int=map[x][y]
        ' tile 1,2,3,4 is sea
        If val<5 Then SetColor 0,0,val*10+100
        ' tile 5 6 7 8 is grasslands/trees
        If val>=5 And val <9 Then SetColor 0,val*15,0
        'tiles 9 10 11 12 13 is mountains
        If val>=9 Then SetColor val*15,val*4,0
        ' draw the tile
        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
    Next
    Next
    If showborder = True 
        SetColor 255,255,255
        SetAlpha 0.35
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If seabordermap[x][y] = 1
                DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
            End If
        Next
        Next
        SetAlpha 1
    End If
End Function

Function makemap:Void()
    numland=0
    ' exit loop if conditions on land percentage is good
       While numland<(mapwidth*mapheight/percland)
        ' erase the old data
        For Local y=0 Until mapheight
           For Local x=0 Until mapwidth
               map[x][y] = 0
        Next
        Next
        'lowest hold the highest tile value
        Local lowest = 0
        ' while land height is below 13
        While lowest < 13
            Local x1 = Rnd(mapwidth)
               Local y1 = Rnd(mapheight)
               ' create a radius for draw oval
            Local radius = Rnd(3,6)
            ' loop and create oval
            For Local y2=-radius To radius
            For Local x2=-radius To radius
                If ((x2*x2)+(y2*y2)) <= radius*radius+radius*0.8
                    Local x3 = x1+x2
                    Local y3 = y1+y2
                    If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
                        ' add current position with added older tile value 
                        map[x3][y3]=map[x3][y3]+1
                        ' if current value is higher then lowest loop value
                        ' then store it in the loop exit variable
                        If map[x3][y3] > lowest Then lowest = map[x3][y3]
                    End If
                End If
            Next
            Next
        Wend
        'Count the number of land tiles
        numland=0
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            ' if the value is above 4 then add landtile counter
            If map[x][y] >= 5 Then numland+=1
        Next
        Next
    Wend
End Function

Function Main()
    New MyGame()
End Function
