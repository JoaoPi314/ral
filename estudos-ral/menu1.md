+++
title = "Blocos de registradores com RAL"
hascode = true
date = Date(2019, 3, 22)
rss = "A short description of the page which would serve as **blurb** in a `RSS` feed; you can use basic markdown here but the whole description string must be a single line (not a multiline string). Like this one for instance. Keep in mind that styling is minimal in RSS so for instance don't expect maths or fancy styling to work; images should be ok though: ![](https://upload.wikimedia.org/wikipedia/en/3/32/Rick_and_Morty_opening_credits.jpeg)"

tags = ["syntax", "code"]
+++


# Blocos de registradores com RAL

\toc


## Visão geral

Seguinte, uma coisa que curto muito é RPG, então fiz esse guia sobre RAL todo voltado a um mini-banco de registradores com essa temática.

O banco será simples. Ele terá apenas dois endereços e para fins de praticidade (Não quero ficar escrevendo sem parar), vou resumir bastante os campos.

Na imagem abaixo encontra-se o mapa de memória para esse banco:

![Banco de registradores](/assets/memory_map.png)

Onde cada valor está descrito nas tabelas a seguir:

- Para o registrador **PLAYER**:


|    **Campo**   | **Posição** |                                                **Descrição**                                               | **Acesso** |
|:--------------:|:-----------:|:----------------------------------------------------------------------------------------------------------:|:----------:|
| MAX_HEALTH     | [15:10]     | Valor máximo da vida do personagem                                                                         | RO         |
| CURRENT_HEALTH | [9:4]       | Valor atual da vida do personagem                                                                          | WR         |
| IS_DEAD        | 3           | 1 -> Player caído\\ 0 -> Player vivo                                                                       | RO         |
| INITIATIVE     | [2:0]       | Cada valor representa o modificador:\\ 3'b000 -> +0\\ 3'b001 -> +1\\ 3'b010 -> +2\\ E assim sucessivamente | RO         |


- Para o registrador **ACTIONS**:

| **Campo** | **Posição** |                                                                      **Descrição**                                                                     | **Acesso** |
|:---------:|:-----------:|:------------------------------------------------------------------------------------------------------------------------------------------------------:|------------|
| Reserved  | [15:6]      | Espaço reservado                                                                                                                                       | --         |
| DEBUFFS   | [5:4]       | Lista de Debuffs que o player pode ter:\\ 2'b00 -> Envenenado\\ 2'b01 -> Paralizado\\ 2'b10 -> Dormindo\\ 2'b11 -> Confuso                             | RO         |
| BUFFS     | [3:2]       | Lista de buffs que o player pode ter:\\ 2'b00 -> Vantagem no ataque 2'b01 -> Bonus de CA\\ 2'b10 -> Vantagem em Saving throws 2'b11 -> Vida temporária | RO         |
| ACTION    | [1:0]       | Lista de movimentos:\\ 2'b00 -> Não faz nada 2'b01 -> Movimento 2'b10 -> Ataque 2'b11 -> Recebe dano                                                   | WR         |

- Para o registrador **INVENTORY**:

| **Campo** | **Posição** |                                 **Descrição**                                 | **Acesso** |
|:---------:|:-----------:|:-----------------------------------------------------------------------------:|------------|
| DAMAGE    | [15:10]     | Dano causado pela arma.                                                       | RO         |
| WEAPON    | [9:0]       | Arma que causou o dano. Vamos supor aqui que cada número representa uma arma. | WR         |

Com isso, vamos começar a falar sobre a modelagem de registradores em RAL de fato!

## Register_fields


