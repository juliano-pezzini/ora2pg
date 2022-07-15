-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_manipulador_quimio ( nr_seq_ordem_prod_p bigint, cd_manipulador_p bigint, nr_seq_etapa_prod_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_seq_etapa_prod_p,0) = 0) then
	update	can_ordem_prod
	set		nm_usuario	= nm_usuario_p,
			cd_manipulador	= cd_manipulador_p
	where	nr_sequencia	= nr_seq_ordem_prod_p;
else
	update	can_ordem_prod
	set		nm_usuario	= nm_usuario_p,
			cd_manipulador	= cd_manipulador_p
	where	nr_seq_etapa_prod	= nr_seq_etapa_prod_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_manipulador_quimio ( nr_seq_ordem_prod_p bigint, cd_manipulador_p bigint, nr_seq_etapa_prod_p bigint, nm_usuario_p text) FROM PUBLIC;

