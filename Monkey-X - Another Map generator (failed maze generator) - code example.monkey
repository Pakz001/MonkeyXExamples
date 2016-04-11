Import mojo


Class maze
    Field map:Bool[][]
    Field w:Int,h:Int
    Field dirx:Int[] = [0,1,0,-1]
    Field diry:Int[] = [-1,0,1,0]
    Field rd:Int
    Field ds:int
    Method New(w:Int,h:Int,rd:Int,ds:Int)
        Self.w = w
        Self.h = h
        map = New Bool[w][]
        For Local i = 0 Until w
            map[i] = New Bool[h]
        Next
        Self.rd=rd
        Self.ds=ds
        makemaze
    End Method
    Method makemaze()
        Local count:Int=0
        For Local i=0 Until (w*h)/ds
            Local x = 2 + (Int(((w - 2) * Rnd) / 2) * 2)
            Local y = 2 + (Int(((h - 2) * Rnd) / 2) * 2)            
            If count=0 Then map[x][y] = True
            Local dir:Int=Rnd(0,4)            
               While spacetaken(x+(dirx[dir]*2),y+(diry[dir]*2)) = False
                   If Rnd(rd)<10 Then dir=Rnd(0,4)
                While spacetaken(x+(dirx[dir]*2),y+(diry[dir]*2)) = True
                       dir=Rnd(0,4)
                   Wend
                   map[x][y] = True
                   map[x+dirx[dir]][y+diry[dir]] = True
                   x+=dirx[dir]
                   y+=diry[dir]
            Wend
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
            If map[x][y] = True
                SetColor 255,255,255
                DrawRect x*tw,y*th,tw+1,th+1
            End If
        Next
        Next
    End Method
End Class

Global mymaze:maze = New maze(    Rnd(15,60),
                                Rnd(15,60),
                                Rnd(0,100),
                                Rnd(1,20))

Class MyGame Extends App
    Field time:Int=0
    Field w:Int,h:Int
    Field rd:Int
    Field ds:Int
    Method OnCreate()
        SetUpdateRate(10)
        Local date := GetDate()
        ' set the random seed to
        ' current second
        Seed = date[5]        
    End Method
    Method OnUpdate()        
        time+=1
        If time>10
            w = Rnd(15,60)
            h = Rnd(15,60)
            rd = Rnd(0,100)
            ds = Rnd(1,20)
            mymaze = New maze(w,h,rd,ds)
            time=0
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymaze.draw
        SetColor 0,0,0
        DrawRect 0,0,DeviceWidth(),15
        SetColor 255,255,255
        DrawText     "Maze width :"+w+
                    " height "+h+
                    " and rdness "+
                    rd+" and ds "+ds,10,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
