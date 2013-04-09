-- Implementar o EXIT

bg = canvas:new("../res/bg.jpg")
canvas:compose(0, 0, bg)
canvas:attrFont("vera", 20)

canais =   {{"Globo"  , "http://meuguia.tv/programacao/canal/GRD"     },
            {"SBT"    , "http://meuguia.tv/programacao/canal/SBT"     },
            {"Record" , "http://meuguia.tv/programacao/canal/REC"     },
            {"Band"   , "http://meuguia.tv/programacao/canal/BAN"     },
            {"MTV"    , "http://meuguia.tv/programacao/canal/MTV"     },
            {"Rede TV", "http://meuguia.tv/programacao/canal/RTV"     },
            {"Gazeta" , "http://meuguia.tv/programacao/canal/GAZ"     }}
            
pos = 0

link = ""

function boxes(canais)

canvas:attrColor("white")
canvas:drawRect ("fill", 200, 100, 90, 20)

canvas:attrColor("red")
canvas:drawText(200,100,"CANAIS")

for i=1, #canais do

canvas:attrColor("white")
canvas:drawRect ("fill", 200, 200 + (50 * (i -1)), 90, 20)
canvas:attrColor("red")
canvas:drawText(200, 200 + (50 * (i - 1)), canais[i][1])

end

end

function seletor(pos)
boxes(canais)

imgseletor = canvas:new("../res/seletor.png")

canvas:compose(200, 200 + (50 * (pos -1)), imgseletor)

canvas:flush()
end

function horarios(pos)

require(canais[pos])

end

function handler(evt)
	if (evt.class == 'key' and evt.type == 'press') then -- we are just interested in key pressed
    
		if (evt.key == 'CURSOR_UP') then
            pos = pos - 1

            if (pos <= 0) then

                pos = #canais

            end

            seletor(pos)


		elseif (evt.key == 'CURSOR_DOWN') then

            pos = pos + 1

            if (pos > #canais) then
                pos = 1
            end

            seletor(pos)

        elseif (evt.key == 'ENTER') then
        
        if ( pos ~= 0) then
        print(pos)
        init(canais[pos])
            
        end
        
        elseif(evt.key == 'EXIT') then
            print("exit")
            canvas:attcolor("black")
            --canvas:clear()
            
            canvas:clear(0,0,1280,720)
            canvas:flush()
					end
				end
			end

function boxesprog()
canvas:compose(600,0,bg,600,0,680,720)


print("boxeprog1")
--cabecalho
canvas:attrColor("white")
canvas:drawRect("fill",620, 100, 60, 20) -- dia
canvas:drawRect("fill",700, 100, 300, 20) -- canal
canvas:drawRect("fill",620, 150, 60, 20) -- "hora"
canvas:drawRect("fill",700, 150, 300, 20) -- "Programa"
canvas:drawRect("fill",1020, 150, 250, 20) -- "Tipo"
print("boxeprog2")
canvas:attrColor("black")
canvas:drawText(620, 100, dia)
canvas:drawText(700, 100, canal)
canvas:drawText(620, 150, "Hora")
canvas:drawText(700, 150, "Programa")
canvas:drawText(1020, 150, "Categoria")
print("boxeprog3")
preenchedorprog()
 end
 
function preenchedorprog()

print ("preenchedorprog")
tab = programacao(1)

for i = 1, #tab do
--horarios

canvas:attrColor("white")

canvas:drawRect("fill", 620, 200 + (50 *( i - 1)), 60, 20)
canvas:drawRect("fill", 700, 200 + (50 *( i - 1)), 300, 20)
canvas:drawRect("fill", 1020, 200 + (50 *( i - 1)), 250, 20)

canvas:attrColor("black")

canvas:drawText( 620, 200 + (50 *( i - 1)), tab[i][2]) --hora ([2])
canvas:drawText( 700, 200 + (50 *( i - 1)), tab[i][1]) --programa ([1])
canvas:drawText( 1020, 200 + (50 *( i - 1)), tab[i][3]) --tipo ([3])

end
canvas:flush()
end

function programacao (dias)

tabProgs = {}
ind = 1
controlador = 0

    for line in io.lines("TXT") do
        for padrao in line:gmatch('title=') do
            if  ((line:find("title=")) ~= (nil)) then

                local indtituloi = line:find("title=") + 7
                local indtitulof = line:find(">") - 2
                local hora = "%d%d%a%d%d"
                local hora = line:match(hora)
                local indtipoi = line:find("metadados") + 11
                local indtipof = line:find("<", indtipoi) - 1
                
                Programa = (line:sub(indtituloi, indtitulof))
                Horario = (hora)
                Tipo = (line:sub(indtipoi, indtipof))

                tabProgs[ind] = {Programa, Horario, Tipo}
                ind = ind+ 1

                
            end

        end

        if  ((line:find("data_prog")) ~= (nil)) then
                controlador = controlador + 1
                
                if (controlador > dias) then
                    return tabProgs
            end

    
end

end

end

function getdia(tdia)
    novodia = ""
    for line in io.lines("TXT") do
        for padrao in line:gmatch(tdia) do
            novodia = line:match(tdia)
            return (novodia)
        end
    end        
end

function init(tabcanal)
print ("init1")
link = tabcanal[2]
http = require("socket.http")
html = http.request(link)
print("init1-2")
arquivo = io.open("TXT","w")
arquivo:write(html)
arquivo:close()

canvas:attrFont("vera", 20)

print("init2")
tdia = "%d%d/%d%d"
canal = tabcanal[1]

print("init3")
dia = getdia(tdia)
print("init4")

boxesprog()
canvas:flush()
end

event.register(handler) 

boxes(canais)
canvas:flush()
