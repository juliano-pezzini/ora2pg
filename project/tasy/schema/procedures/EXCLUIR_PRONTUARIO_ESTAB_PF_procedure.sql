-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_prontuario_estab_pf ( cd_pessoa_fisica_p text, cd_estab_p bigint) AS $body$
BEGIN

delete	from pessoa_fisica_pront_estab
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	cd_estabelecimento = cd_estab_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_prontuario_estab_pf ( cd_pessoa_fisica_p text, cd_estab_p bigint) FROM PUBLIC;
