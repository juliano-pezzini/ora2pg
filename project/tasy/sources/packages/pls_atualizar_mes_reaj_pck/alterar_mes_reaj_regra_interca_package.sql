-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.alterar_mes_reaj_regra_interca (nr_seq_grupo_intercambio_p pls_regra_grupo_inter.nr_sequencia%type, nr_mes_reajuste_p pls_regra_grupo_inter.nr_mes_reajuste%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


C01 CURSOR(	nr_seq_grupo_intercambio_pc	pls_regra_grupo_inter.nr_sequencia%type) FOR
	SELECT	nr_sequencia nr_seq_intercambio,
		nr_mes_reajuste
	from	pls_intercambio
	where	nr_seq_grupo_intercambio = nr_seq_grupo_intercambio_pc;

BEGIN

update	pls_regra_grupo_inter
set	nr_mes_reajuste	= nr_mes_reajuste_p,
	dt_reajuste	= CASE WHEN nr_mes_reajuste_p = NULL THEN null  ELSE add_months(trunc(clock_timestamp(),'year'),nr_mes_reajuste_p-1) END ,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_grupo_intercambio_p;

for r_c01_w in c01(nr_seq_grupo_intercambio_p) loop
	begin
	if (coalesce(r_c01_w.nr_mes_reajuste, 0) <> coalesce(nr_mes_reajuste_p, 0)) then
		CALL pls_atualizar_mes_reaj_pck.atualizar_mes_reaj_intercambio(r_c01_w.nr_seq_intercambio, nr_mes_reajuste_p, null, 'S', 'S', nm_usuario_p, cd_estabelecimento_p);
	end if;
	end;
end loop; --C01
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.alterar_mes_reaj_regra_interca (nr_seq_grupo_intercambio_p pls_regra_grupo_inter.nr_sequencia%type, nr_mes_reajuste_p pls_regra_grupo_inter.nr_mes_reajuste%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;