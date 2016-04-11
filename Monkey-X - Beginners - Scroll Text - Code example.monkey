Import mojo

Class scrolltext
    Field x:Int,y:Int
    Field stext:String 'the text
    Field lx:Float 'location in the scroll
    Field scrollwidth:Int 'how many characters drawn to the screen
    Method New()
        stext="                    "
        stext+="This is a scrolltext made in Monkey-X. It is made inside a class. "
        stext+="the text will repeat itself after this text has ended.           "
    End Method
    Method update()
        'increase the scroll position
        lx+=.1
        If lx>=stext.Length Then lx=0
    End Method
    Method draw()
        'get the visible string inside dt and draw that
        Local dt:String=""
        Local sp:Int=lx
        For Local i=0 Until scrollwidth
            dt+=String.FromChar(stext[sp])            
            sp+=1
            If sp>=stext.Length Then sp=0
        Next
        SetColor 255,255,255
        DrawText dt,x,y
    End Method
End Class

Global s:scrolltext = New scrolltext

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        s.scrollwidth=20 'character the scrolltext is wide
        s.x=100
        s.y=100
    End Method
    Method OnUpdate()  
        s.update      
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "ScrollText Example..",0,0
        s.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
