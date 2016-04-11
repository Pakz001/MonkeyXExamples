Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Const tilewidth:Int=16
Const tileheight:Int=16
Const mapwidth=100
Const mapheight=100
Global numland:Int = 0
Global percland:Float = 1.7
Global map:Int[mapwidth][]
Global mapx:Int=0
Global mapy:Int=0

Class minimap
    Field image:Image
    Field pixels:Int[100*100]
    Method makeminimap()
        For Local y=0 Until 100
        For Local x=0 Until 100
            'Local pc = y*mapheight+x
            Local val = map[x][y]
            Local val2:Int
             ' tile 1,2,3,4 is sea
            If val<5 Then val2 = argb(0,0,val*10+100)
               ' tile 5 6 7 8 is grasslands/trees
               If val>=5 And val <9 Then val2 = argb(0,val*15,0)
            'tiles 9 10 11 12 13 is mountains
            If val>=9 Then val2 = argb(val*15,val*4,0)
            drawr(x,y,1,1,val2)
        Next
        Next
        image.WritePixels(mm.pixels, 0, 0, 100, 100, 0)
    End Method
    Method drawr(x1,y1,w1,h1,col)
        For Local y2=y1 Until y1+h1
        For Local x2=x1 Until x1+w1
            Local pc = y2*100+x2
            If pc >= 0 And pc < 100*100
                pixels[pc] = col
            End If
        Next
        Next
    End Method 
    Method draw(_x:Int,_y:Int)
        DrawImage image,_x,_y
    End Method
End Class    

Global mm:minimap = New minimap


Class MyGame Extends App

    Method OnCreate()
        'make the map array
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next        
        makemap
        'create the minimap image
        mm.image = CreateImage(100, 100)        
        'draw the minimap image
        mm.makeminimap        
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        'here we move the map from the minimap
        If MouseDown(MOUSE_LEFT)
            If MouseX()>screenwidth-105
            If MouseY()>5
            If MouseX()<screenwidth-5
            If MouseY()<110
                mapx = 100-(screenwidth-MouseX())+5
                mapy = MouseY()-5
                mapx = mapx - (screenwidth/tilewidth)/2
                mapy = mapy - (screenheight/tileheight)/2
                'Print "mapx:"+mapx+"mapy:"+mapy
                If mapx<0 Then mapx=0
                If mapy<0 Then mapy=0
                If mapx+screenwidth/tilewidth>mapwidth Then mapx=mapwidth-screenwidth/tilewidth
                If mapy+screenheight/tileheight>mapheight Then mapy=mapheight-screenheight/tileheight
            End If
            End If
            End If
            End If
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        SetColor 0,0,0
        DrawRect screenwidth-110,0,110,110
        SetColor 255,255,255
        'here we draw the minimap image
        mm.draw(screenwidth-105,5)
        'here we draw the white box in the minimap
        drawboxedrect(mapx+screenwidth-105,5+mapy,screenwidth/tilewidth,screenheight/tileheight)
        DrawText "Press the mouse in the minimap to move the big map",0,0
'        drawminimap
    End Method
End Class

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

Function drawmap:Void()
    For Local y=0 Until screenheight/tileheight
    For Local x=0 Until screenwidth/tilewidth
        Local val:Int=map[x+mapx][y+mapy]
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
End Function

Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function

Function drawboxedrect:Void(x:Int,y:Int,w:Int,h:Int)
    DrawLine x,y,x+w,y
    DrawLine x,y,x,y+h
    DrawLine x,y+h,x+w,y+h
    DrawLine x+w,y,x+w,y+h
End Function

Function Main()
    New MyGame()
End Function
