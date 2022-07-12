-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/* Formata os ds_hora conforme os minutos administrados */

CREATE OR REPLACE FUNCTION cpoe_gerar_registro_json_pck.formata_ds_hora (nr_min_p bigint) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w		varchar(30);

	
BEGIN
		ds_retorno_w := '';

		if (nr_min_p = 0) then
			ds_retorno_w	:= ';B;B;B;B';
		elsif (nr_min_p <= 15) then
			ds_retorno_w	:= ';P;B;B;B';
		elsif (nr_min_p > 15 AND nr_min_p <= 30) then
			ds_retorno_w	:= ';P;P;B;B';
		elsif (nr_min_p > 30 AND nr_min_p <= 45) then
			ds_retorno_w	:= ';P;P;P;B';
		elsif (nr_min_p > 45) then
			ds_retorno_w	:= ';P;P;P;P';
		else
			ds_retorno_w	:= '';
		end if;

		return ds_retorno_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION cpoe_gerar_registro_json_pck.formata_ds_hora (nr_min_p bigint) FROM PUBLIC;
