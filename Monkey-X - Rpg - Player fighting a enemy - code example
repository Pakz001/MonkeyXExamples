Import mojo

Class battle
    Field state:String="playerturn"
    Field nextstate:String
    Field timeout:Int
    Method update()
        If state="playerturn"
            timeout = Millisecs()+3000
            Local hitval:Int
            hitval=myplayer.attack-myenemy.defence
            If hitval<1 Then hitval = Rnd(1,3)
            myenemy.health-=hitval
            myeffect.AddLast(New effect(hitval,myenemy.x+48/2-4,myenemy.y))
            If myenemy.health < 1
                mybattleinfo.scrollloc = 1
                mybattleinfo.message = "Player killed the enemy. New enemy appears.."
                mybattleinfo.showmessage = ""
                myenemy.attack = Rnd(5,15)
                myenemy.defence = Rnd(5,15)
                myenemy.health = Rnd(5,25)
                state = "wait"
                nextstate = "playerturn"
            Else
                mybattleinfo.scrollloc = 1
                mybattleinfo.message = "Player hit enemy causing "+hitval+" damage to health."
                mybattleinfo.showmessage=""
                state="wait"
                nextstate = "enemyturn"
            End If
        End If
        If state="enemyturn"
            timeout=Millisecs()+3000
            Local hitval:Int
            hitval=myenemy.attack-myplayer.defence
            If hitval<1 Then hitval = Rnd(1,3)
            myplayer.health-=hitval
            myeffect.AddLast(New effect(hitval,myplayer.x+48/2-4,myplayer.y))            
            If myplayer.health < 1
                mybattleinfo.scrollloc = 1
                mybattleinfo.message = "You have been killed in battle. You reappear."
                mybattleinfo.showmessage=""
                myplayer.attack = Rnd(10,25)
                myplayer.defence = Rnd(5,15)
                myplayer.health = Rnd(10,50)
                state="wait"
                nextstate="playerturn"
                Else
                mybattleinfo.scrollloc = 1
                mybattleinfo.message = "Enemy hit player causing "+hitval+" damage to health."
                mybattleinfo.showmessage=""
                state="wait"
                nextstate = "playerturn"
            End If
        End If
        If state="wait"
            If Millisecs() > timeout Then
                state=nextstate
            End If
        End If
    End Method
    Method draw()
    End Method
End Class

Class battleinfo
    Field x:Int=32,y:Int=32
    Field message:String
    Field showmessage:String
    Field scrolldelay:Int
    Field scrollloc:Int
    Method update()
        If Millisecs() > scrolldelay
            scrolldelay = Millisecs()+50
            If showmessage.Length < message.Length
                scrollloc+=1
                    Local dt:String=""
                Local sp:Int=0
                For Local i=0 Until scrollloc
                       dt+=String.FromChar(message[sp])            
                      sp+=1
'                    If sp>=stext.Length Then sp=0
                Next            
                showmessage=dt
            End If
        End If
    End Method
    Method draw()
        SetColor 255,255,255
        DrawText showmessage,x,y
    End Method
End Class

Class player
    Field x:Int=200,y:Int=200
    Field w:Int=48,h:Int=48
    Field attack:Int=10,defence:Int=5,health:Int=42
    Method update()
    End Method
    Method draw()
        SetColor 200,0,0
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawText "A:"+attack,x+2,y+2
        DrawText "D:"+defence,x+2,y+12
        DrawText "H:"+health,x+2,y+22                
    End Method
End Class

Class enemy
    Field x:Int=320,y:Int=200
    Field w:Int=48,h:Int=48
    Field attack:Int=6,defence:Int=4,health:Int=12
    Method update()
    End Method
    Method draw()
        SetColor 200,200,0
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawText "A:"+attack,x+2,y+2
        DrawText "D:"+defence,x+2,y+12
        DrawText "H:"+health,x+2,y+22                    
    End Method
End Class

Class effect
    Field x:Int,y:Float,incy:Float
    Field m:String,delete:Bool=False
    Method New(m:String,x:Int,y:Int)
        Self.m = m
        Self.x = x
        Self.y = y
        incy = 0
    End Method
    Method update()
        y-=incy
        incy+=.05
        If incy > 3 Then delete = True
    End Method
    Method draw()
        SetColor 255,255,255
        DrawText m,x,y
    End Method
End Class

Global myplayer:player = New player()
Global myenemy:enemy = New enemy()
Global mybattle:battle = New battle()
Global mybattleinfo:battleinfo = New battleinfo()
Global myeffect:List<effect> = New List<effect>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        myplayer.update
        myenemy.update
        mybattle.update
        mybattleinfo.update
        For Local i:=Eachin myeffect
            i.update
        Next
        For Local i:=Eachin myeffect
            If i.delete = True Then myeffect.Remove i
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Rpg player and ai fighting.",0,0
        myplayer.draw
        myenemy.draw
        mybattle.draw
        mybattleinfo.draw
        For Local i:=Eachin myeffect
            i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
