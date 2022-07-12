-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dia_treinamento_v (dt_dia) AS select trunc(last_day(dt_mes),'dd') dt_dia FROM mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -1 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -2 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -3 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -4 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -5 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -6 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -7 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -8 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -9 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -10 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -11 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -12 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -13 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -14 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -15 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -16 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -17 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -18 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -19 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -20 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -21 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -22 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -23 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -24 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -25 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -26 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -27 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -28 dt_dia from mes_treinamento_v

union

select trunc(last_day(dt_mes),'dd') -29 dt_dia from mes_treinamento_v where to_char(last_day(dt_mes),'dd') >= '29'

union

select trunc(last_day(dt_mes),'dd') -30 dt_dia from mes_treinamento_v where to_char(last_day(dt_mes),'dd') >= '30'

union

select trunc(last_day(dt_mes),'dd') -31 dt_dia from mes_treinamento_v where to_char(last_day(dt_mes),'dd') >= '31';

