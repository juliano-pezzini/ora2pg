-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ajusta_relatorio_swing_pck.verifica_caracteres_invalidos (ds_valor_p text) RETURNS boolean AS $body$
DECLARE

	ds_valor_w 	varchar(4000);
	ds_caracter_w	varchar(1);
	contador	bigint;
	achou_caracter  bigint	:= 0;
	caracteres_validos varchar(100) :='abcdefghijklmnopqrstuvxywzABCDEFGHIJKLMNOPRQSTUVXYWZ_1234567890';
	
BEGIN
	ds_valor_w := '';
	if (position('_' in ds_valor_w) = 0) then
		return false;
	end if;
	FOR contador IN REVERSE length(ds_valor_p)..1 loop
		ds_caracter_w := substr(ds_valor_p,contador,1);
		if ( position(ds_caracter_w in caracteres_validos) > 0 ) and ( achou_caracter < 2) then
			ds_valor_w := ds_caracter_w || ds_valor_w;
			achou_caracter := 1;
		else
			if ( achou_caracter = 1 ) then
				achou_caracter := 2;
			end if;
		end if;
	end loop;
	return achou_caracter = 2;
	end;


$body$
LANGUAGE PLPGSQL
 STABLE;
-- REVOKE ALL ON FUNCTION ajusta_relatorio_swing_pck.verifica_caracteres_invalidos (ds_valor_p text) FROM PUBLIC;
