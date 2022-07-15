-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_registrar_obs_ocorrencia ( ds_observacao_p text, nr_sequencia_p bigint) AS $body$
BEGIN

if 	(ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '' AND nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')	then

	update 	lote_ent_ocorrencia
	SET	   	ds_observacao = ds_observacao_p
	WHERE  	nr_sequencia = nr_sequencia_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_registrar_obs_ocorrencia ( ds_observacao_p text, nr_sequencia_p bigint) FROM PUBLIC;

