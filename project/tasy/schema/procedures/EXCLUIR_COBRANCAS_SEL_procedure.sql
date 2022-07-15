-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_cobrancas_sel (ds_lista_p text) AS $body$
BEGIN

if (ds_lista_p IS NOT NULL AND ds_lista_p::text <> '') then

	delete
	from	cobranca
	where	ds_lista_p like '% ' || nr_sequencia || ' %';

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_cobrancas_sel (ds_lista_p text) FROM PUBLIC;

