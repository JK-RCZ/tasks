#!/usr/bin/env python3

import pygame
pygame.init()

# -------------- Default Inputs --------------
step = 7
w_name = 'KILL W. MAIM'
bgcolor = (20, 30, 40)
px = 1366
py = 768
img_addr = './Windows_live_square-4161473548.jpeg'
img_px = 120
img_py = 120
x = px/2- img_px/2
y = py/2- img_py/2
x_limit = px-img_px
y_limit = py-img_py
gameover = False
m_u = False
m_d = False
m_l = False
m_r = False

# -----------------Settings------------------
window = pygame.display.set_mode((px, py), pygame.FULLSCREEN)
pygame.display.set_caption(w_name)
sq = pygame.image.load(img_addr)
sq = pygame.transform.scale(sq, (img_px, img_py))


# -----------------GO, Baby, Go-------------------
while gameover == False:
    for event in pygame.event.get():
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                gameover = True

            if event.key == pygame.K_UP:
                m_u = True
            if event.key == pygame.K_DOWN:
                m_d = True
            if event.key == pygame.K_LEFT:
                m_l = True
            if event.key == pygame.K_RIGHT:
                m_r = True

        if event.type == pygame.KEYUP:
            if event.key == pygame.K_UP:
                m_u = False
            if event.key == pygame.K_DOWN:
                m_d = False
            if event.key == pygame.K_LEFT:
                m_l = False
            if event.key == pygame.K_RIGHT:
                m_r = False

    if m_u == True:
        if y - step >= 0:
            y -= step
        else:
            y = 0
    if m_d == True:
        if y + step <= y_limit:
            y += step
        else:
            y = y_limit
    if m_l == True:
        if x - step >= 0:
                x -= step
        else:
                x = 0
    if m_r == True:
        if x + step <= x_limit:
                x += step
        else:
                x = x_limit

        if event.type == pygame.MOUSEBUTTONDOWN:
            x, y = event.pos
            x -= 60
            y -= 60
            if x < 0:
                x = 0
            if x > 680:
                x = 680
            if y < 0:
                y = 0
            if y > 480:
                y = 480


    window.fill(bgcolor)
    window.blit(sq, (x, y))
    pygame.display.flip()




