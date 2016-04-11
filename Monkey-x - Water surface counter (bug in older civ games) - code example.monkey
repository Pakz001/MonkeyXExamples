Import mojo

Const mapwidth:Int=640/16
Const mapheight:Int=480/16
Const tilewidth:Int=16
Const tileheight:Int=16
Global map:Int[mapwidth][]
Global watermap:Int[mapwidth][]
Global numland:Int = 0
Global percland:Float = 1.7
Global remakecnt:Int=0

Class Openlist
    Field x:Int, y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(5)
        Seed = Millisecs()
        'Set up the map array to be multi dimensional
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
            watermap[i] = New Int[mapheight]
        Next
        ' make the map the first time
        percland = Rnd(2.0,3.5)
        makemap
        makewatermap
    End Method
    Method OnUpdate()
        ' how much land must it have numoflandtiles </mapsize/percland
        remakecnt+=1
        If remakecnt > 10
            remakecnt=0
               percland = Rnd(2.0,3.5)
            makemap
            makewatermap
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        drawmap        
        Local numwater=getnumberwater()
        SetColor 10,10,10
        SetAlpha 0.6
        DrawRect 0,0,200,numwater*15+15
        SetAlpha 1
        SetColor 255,255,255
        DrawText "Water floodfill to number the water surfaces.",0,0
        DrawText "(bugs) In civ games lots of sea units where put into tiny area's of water.",0,15
        For Local y=1 To numwater
            DrawText "Water mass "+y+" is "+getwatermass(y)+" tiles.",0,y*15+30
        Next
        
    End Method
End Class

Function makewatermap:Void()
    'first clear the array
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        watermap[x][y] = 0
    Next
    Next
    ' create an open list
    Local openlist:List<Openlist> = New List<Openlist>
    Local currentwaternum:Int=0
    ' loop through the array
    For Local y1=0 Until mapheight
    For Local x1=0 Until mapwidth
        ' if land tile and not indexed as island
        If map[x1][y1]<5 And watermap[x1][y1] = 0
            currentwaternum+=1
            openlist.Clear()
            'move this position onto the openlist
            openlist.AddLast(New Openlist(x1,y1))
            Local tx:Int=0, ty:Int=0            
            While openlist.IsEmpty() = False
                ' get a x,y value from the open list
                For Local i:=Eachin openlist
                    tx = i.x
                    ty = i.y
                    openlist.Remove i
                    Exit
                Next
                ' get 8 new positions
                For Local y2=-1 To 1
                For Local x2=-1 To 1
                    Local x3:Int=tx+x2
                    Local y3:Int=ty+y2
                    If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
                    ' if land tile and not assisgned before a island
                    If map[x3][y3]<5
                    If watermap[x3][y3] = 0
                        ' add to open list
                        openlist.AddLast(New Openlist(x3,y3))
                        ' set current connected landmass
                        watermap[x3][y3] = currentwaternum
                    End If
                    End If
                    End If
                Next
                Next
            Wend
        End If
    Next
    Next
End Function

Function drawmap:Void()
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
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        DrawText watermap[x][y],x*tilewidth+tilewidth/2,y*tileheight+tileheight/2,0.5,0.5
    Next
    Next    
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

Function getwatermass:Int(waternumber:Int=1)
    Local totaltiles:Int=0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If watermap[x][y] = waternumber Then totaltiles+=1
    Next
    Next
    Return totaltiles
End Function

Function getnumberwater:Int()
    Local highestnumber:Int=0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If watermap[x][y] > highestnumber Then highestnumber = watermap[x][y]
    Next
    Next
    Return highestnumber
End Function

Function Main()
    New MyGame()
End Function
