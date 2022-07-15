-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_alteracao_valor_tit (nr_titulo_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	delete 	from alteracao_valor a
	where	a.nr_titulo	= nr_titulo_p
	and	a.nr_sequencia	= (SELECT	max(x.nr_sequencia)
				   from		alteracao_valor x
				   where	x.nr_titulo	= a.nr_titulo);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_alteracao_valor_tit (nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

