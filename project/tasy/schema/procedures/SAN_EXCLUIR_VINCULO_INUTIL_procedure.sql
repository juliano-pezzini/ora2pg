-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_excluir_vinculo_inutil ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then

	update	san_producao
	set	nr_seq_inutil	 = NULL,
		DT_INUTILIZACAO  = NULL,
		NM_USUARIO_INUT  = NULL
	where	nr_sequencia	= nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_excluir_vinculo_inutil ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

