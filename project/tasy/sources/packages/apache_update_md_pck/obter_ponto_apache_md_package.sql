-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE range AS (range bigint[9]);


CREATE OR REPLACE FUNCTION apache_update_md_pck.obter_ponto_apache_md (qt_parametro_p bigint, qt_variavel_p bigint) RETURNS bigint AS $body$
DECLARE

    Range_w	   	Range;
    qt_ponto_w	bigint;

BEGIN
    if (qt_variavel_p = 1) then
      Range_w := range(41,39,0,38.5,36,34,32,30,30);
    elsif (qt_variavel_p = 2) then
      Range_w := range(160,130,110,0,70,0,50,0,50);
    elsif (qt_variavel_p = 3) then
      Range_w := range(180,140,110,0,70,0,55,40,40);
    elsif (qt_variavel_p = 4) then
      Range_w := range(50,35,0,25,12,10,6,0,6);
    elsif (qt_variavel_p = 5) then
      Range_w := range(7.7,7.6,0,7.5,7.33,0,7.25,7.15,7.15);
    elsif (qt_variavel_p = 6) then
      Range_w := range(180,160,155,150,130,0,120,111,111);
    elsif (qt_variavel_p = 7) then
      Range_w := range(7,6,0,5.5,3.5,3,2.5,0,2.5);
    elsif (qt_variavel_p = 8) then
      Range_w := range(60,0,50,46,30,0,20,0,20);
    elsif (qt_variavel_p = 9) then
      Range_w := range(40,0,20,15,3,0,1,0,1);
    elsif (qt_variavel_p = 10) then
      Range_w := range(52,41,0,32,22,0,18,15,15);
    end if;

    if (qt_parametro_p >= range_w(1)) then
        qt_ponto_w := 4;
    elsif (qt_parametro_p >= range_w(2)) and (range_w(2) <> 0) then
      qt_ponto_w := 3;
    elsif (qt_parametro_p >= range_w(3)) and (range_w(3) <> 0) then
      qt_ponto_w := 2;
    elsif (qt_parametro_p >= range_w(4)) and (range_w(4) <> 0) then
      qt_ponto_w := 1;
    elsif (qt_parametro_p >= range_w(5)) and (range_w(5) <> 0) then
      qt_ponto_w := 0;
    elsif (qt_parametro_p >= range_w(6)) and (range_w(6) <> 0) then
      qt_ponto_w := 1;
    elsif (qt_parametro_p >= range_w(7)) and (range_w(7) <> 0) then
      qt_ponto_w := 2;
    elsif (qt_parametro_p >= range_w(8)) and (range_w(8) <> 0) then
      qt_ponto_w := 3;
    elsif (qt_parametro_p < range_w(9)) and (range_w(9) <> 0) then
      qt_ponto_w := 4;
    end if;

    return	qt_ponto_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION apache_update_md_pck.obter_ponto_apache_md (qt_parametro_p bigint, qt_variavel_p bigint) FROM PUBLIC;
