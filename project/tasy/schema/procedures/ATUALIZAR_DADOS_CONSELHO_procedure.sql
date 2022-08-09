-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_conselho ( nr_seq_conselho_p bigint, ds_codigo_prof_p text, cd_pessoa_fisica_p text) AS $body$
BEGIN

if (nr_seq_conselho_p IS NOT NULL AND nr_seq_conselho_p::text <> '') and (ds_codigo_prof_p IS NOT NULL AND ds_codigo_prof_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin

	update	pessoa_fisica
	set	nr_seq_conselho   = nr_seq_conselho_p,
		ds_codigo_prof    = ds_codigo_prof_p
	where	cd_pessoa_fisica  = cd_pessoa_fisica_p;
	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_conselho ( nr_seq_conselho_p bigint, ds_codigo_prof_p text, cd_pessoa_fisica_p text) FROM PUBLIC;
