-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_conv_ret_item (ie_analisada_p text, nr_sequencia_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update   convenio_retorno_item
	set      dt_analisada   	= clock_timestamp(),
		 ie_analisada   	= ie_analisada_p
	where    nr_sequencia   	= nr_sequencia_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_conv_ret_item (ie_analisada_p text, nr_sequencia_p bigint) FROM PUBLIC;

