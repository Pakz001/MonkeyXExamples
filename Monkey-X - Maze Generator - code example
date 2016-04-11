Import mojo

Global maxwidth:Int=60
Global maxheight:Int=40

Class maze
    Field map:Bool[][]
    Field w:Int,h:Int
    Field dirx:Int[] = [0,1,0,-1]
    Field diry:Int[] = [-1,0,1,0]
    Field rd:Int
    Method New(w:Int,h:Int,rd:Int)
        Self.w = w
        Self.h = h
        map = New Bool[w][]
        For Local i = 0 Until w
            map[i] = New Bool[h]
        Next
        Self.rd=rd
        makemaze
    End Method
    Method makemaze()
        Local count:Int=0
        For Local i=0 Until w*h
            Local x = 2 + (Int(((w - 2) * Rnd) / 2) * 2)
            Local y = 2 + (Int(((h - 2) * Rnd) / 2) * 2)            
            If count=0 Then map[x][y] = True
            Local dir:Int=Rnd(0,4)            
               If map[x][y] = True
                While spacetaken(x+(dirx[dir]*2),y+(diry[dir]*2)) = False
                   map[x][y] = True
                   map[x+dirx[dir]][y+diry[dir]] = True
                   x+=dirx[dir]
                   y+=diry[dir]
                   If Rnd(0,rd) < rd/10 Then
                       dir=Rnd(0,4)
                   End If
                   Wend
            End If
        Next
    End Method
    Method spacetaken:Bool(x:Int,y:Int)
        If x>-1 And y>-1 And x<w And y<h
            Return map[x][y]
        End If
        Return True
    End Method
    Method draw()        
        Local tw:Float=DeviceWidth()/Float(w)
        Local th:Float=DeviceHeight()/Float(h)
        For Local y=0 Until h
        For Local x=0 Until w
            If map[x][y] = False
                Local d:Int                
                Local dx:Int=x*tw
                Local dy:Int=y*th                
                d = distance(dx,dy,320,200)
                d=d/2.5
                SetColor 255-d,(255-d)/2,(255-d)/2
                DrawRect dx,dy,tw+1,th+1
            End If
        Next
        Next
    End Method
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function      
End Class

Global mymaze:maze = New maze(    maxwidth,
                                maxheight,
                                Rnd(0,40))
                                
Class MyGame Extends App
    Field w:Int,h:Int
    Field rd:Int
    field cnt:Int
    Method OnCreate()
        SetUpdateRate(10)
        Local date := GetDate()
        ' set the random seed to
        ' current second
        Seed = date[5]        
    End Method
    Method OnUpdate()   
        cnt+=1
           If KeyHit(KEY_RIGHT) Or cnt>30
               cnt=0
            w = Rnd(20,maxwidth)
            h = Rnd(15,maxheight)
            rd = Rnd(0,40)
            If Rnd(0,10) < 3
                w=Rnd(50,200)
                h=Rnd(50,150)
            End If
            mymaze = New maze(w,h,rd)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymaze.draw
        SetColor 0,0,0
        DrawRect 0,0,DeviceWidth()/2,15
        SetColor 255,255,255
        DrawText     "Maze width :"+w+
                    " height "+h+
                    " and rdness "+
                    rd,10,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
