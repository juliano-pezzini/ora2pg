-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ano_v (dt_mes) AS select trunc(LOCALTIMESTAMP, 'year') dt_mes

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-12) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-24) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-36) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-48) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-60) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-72) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-84) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-96) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-108) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-120) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-132) 

union

select add_months(trunc(LOCALTIMESTAMP, 'year'),-144);
