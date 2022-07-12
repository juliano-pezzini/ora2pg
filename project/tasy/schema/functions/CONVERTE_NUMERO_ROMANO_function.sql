-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_numero_romano ( nr_numero_p integer ) RETURNS varchar AS $body$
DECLARE


nr_romano_w	varchar(10);


BEGIN

if (nr_numero_p = 1) then
	nr_romano_w	:= 'I';
elsif (nr_numero_p = 2) then
	nr_romano_w	:= 'II';
elsif (nr_numero_p = 3) then
	nr_romano_w	:= 'III';
elsif (nr_numero_p = 4) then
	nr_romano_w	:= 'IV';
elsif (nr_numero_p = 5) then
	nr_romano_w	:= 'V';
elsif (nr_numero_p = 6) then
	nr_romano_w	:= 'VI';
elsif (nr_numero_p = 7) then
	nr_romano_w	:= 'VII';
elsif (nr_numero_p = 8) then
	nr_romano_w	:= 'VIII';
elsif (nr_numero_p = 9) then
	nr_romano_w	:= 'IX';
elsif (nr_numero_p = 10) then
	nr_romano_w	:= 'X';
end if;

return	nr_romano_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_numero_romano ( nr_numero_p integer ) FROM PUBLIC;

