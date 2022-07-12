-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pontos_nas_campo (ds_campo_p text) RETURNS bigint AS $body$
DECLARE


nr_retorno_w	real;


BEGIN

if (ds_campo_p = 'DS_ITEM_1A') then
	nr_retorno_w := '4,5';
elsif (ds_campo_p = 'DS_ITEM_1B') then
	nr_retorno_w := '12,1';
elsif (ds_campo_p = 'DS_ITEM_1C') then
	nr_retorno_w := '19,6';
elsif (ds_campo_p = 'DS_ITEM_2') then
	nr_retorno_w := '4,3';
elsif (ds_campo_p = 'DS_ITEM_3') then
	nr_retorno_w := '5,6';
elsif (ds_campo_p = 'DS_ITEM_4A') then
	nr_retorno_w := '4,1';
elsif (ds_campo_p = 'DS_ITEM_4B') then
	nr_retorno_w := '16,5';
elsif (ds_campo_p = 'DS_ITEM_4C') then
	nr_retorno_w := '20';
elsif (ds_campo_p = 'DS_ITEM_5') then
	nr_retorno_w := '1,8';
elsif (ds_campo_p = 'DS_ITEM_6A') then
	nr_retorno_w := '5,5';
elsif (ds_campo_p = 'DS_ITEM_6B') then
	nr_retorno_w := '12,4';
elsif (ds_campo_p = 'DS_ITEM_6C') then
	nr_retorno_w := '17';
elsif (ds_campo_p = 'DS_ITEM_7A') then
	nr_retorno_w := '4';
elsif (ds_campo_p = 'DS_ITEM_7B') then
	nr_retorno_w := '32';
elsif (ds_campo_p = 'DS_ITEM_8A') then
	nr_retorno_w := '4,2';
elsif (ds_campo_p = 'DS_ITEM_8B') then
	nr_retorno_w := '23,2';
elsif (ds_campo_p = 'DS_ITEM_8C') then
	nr_retorno_w := '30';
elsif (ds_campo_p = 'DS_ITEM_9') then
	nr_retorno_w := '1,4';
elsif (ds_campo_p = 'DS_ITEM_10') then
	nr_retorno_w := '1,8';
elsif (ds_campo_p = 'DS_ITEM_11') then
	nr_retorno_w := '4,4';
elsif (ds_campo_p = 'DS_ITEM_12') then
	nr_retorno_w := '1,2';
elsif (ds_campo_p = 'DS_ITEM_13') then
	nr_retorno_w := '2,5';
elsif (ds_campo_p = 'DS_ITEM_14') then
	nr_retorno_w := '1,7';
elsif (ds_campo_p = 'DS_ITEM_15') then
	nr_retorno_w := '7,1';
elsif (ds_campo_p = 'DS_ITEM_16') then
	nr_retorno_w := '7,7';
elsif (ds_campo_p = 'DS_ITEM_17') then
	nr_retorno_w := '7';
elsif (ds_campo_p = 'DS_ITEM_18') then
	nr_retorno_w := '1,6';
elsif (ds_campo_p = 'DS_ITEM_19') then
	nr_retorno_w := '1,3';
elsif (ds_campo_p = 'DS_ITEM_20') then
	nr_retorno_w := '2,8';
elsif (ds_campo_p = 'DS_ITEM_21') then
	nr_retorno_w := '1,3';
elsif (ds_campo_p = 'DS_ITEM_22') then
	nr_retorno_w := '2,8';
else
	nr_retorno_w := '1,9';
end if;


return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pontos_nas_campo (ds_campo_p text) FROM PUBLIC;

