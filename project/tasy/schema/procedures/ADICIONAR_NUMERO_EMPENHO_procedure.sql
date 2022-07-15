-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adicionar_numero_empenho ( nr_ordem_compra_p bigint, cd_conta_contabil_p text, nr_empenho_p text, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(cd_conta_contabil_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265564);
	--'Não é possível inserir número de empenho se não possuir conta contábil.'
end if;

update	ordem_compra_item
set	nr_empenho	= nr_empenho_p,
	dt_empenho	= clock_timestamp()
where	nr_ordem_compra	= nr_ordem_compra_p
and	cd_conta_contabil	= cd_conta_contabil_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adicionar_numero_empenho ( nr_ordem_compra_p bigint, cd_conta_contabil_p text, nr_empenho_p text, nm_usuario_p text) FROM PUBLIC;

