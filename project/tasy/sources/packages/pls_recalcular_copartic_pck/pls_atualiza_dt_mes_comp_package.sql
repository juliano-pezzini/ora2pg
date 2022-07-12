-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--Atualiza m?s compet?ncia dos itens recalculados na aplica??o do lote
CREATE OR REPLACE PROCEDURE pls_recalcular_copartic_pck.pls_atualiza_dt_mes_comp ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_p pls_recalc_copartic_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

	
/*
	Essa rotina atualiza o m?s de compet?ncia cont?bil dos itens gerados no rec?clulo de coparticipa??o. Basicamente deve atualizar conforme os seguintes pontos:
	
	1 - se o item original da coparticipa??o ainda n?o foi contabilizado, ent?o a data de compet?ncia do novo registro de coparticipa??o ser? conforme a data de compet?ncia do registro de origem.
	2 - se o item original da coparticipa??o j? foi contabilizado, ent?o a data de compet?ncia da coparticipa??o ser? conforme a data de gera??o da coparticipa??o, que neste caso do rec?lculo, ser? a data de aplica??o do rec?lculo.
	
	Como ao recalcular a coparticipa??o ? chamada normalmente a rotina da coparticipa??o, ? gerado no primeiro momento com a compet?ncia padr?o para  o item e ent?o, essa rotina aqui verifica se as coparticipa??es estornadas pelo
	processo possuem v?nculo com lote cont?bil(ou seja, j? contabilizado) a? apenas nesses casos eles necessitam de atualiza??o da compet?ncia nos nosvos registros gerados.
*/
	
	
C01 CURSOR FOR
	SELECT 	nr_sequencia nr_seq_conta_proc,
			null	nr_seq_conta_mat,
			(	SELECT 	max(nr_lote_contabil_prov)
				from 	pls_conta_coparticipacao 
				where 	(nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')
				and 	nr_seq_conta_proc = a.nr_sequencia
				and 	(dt_estorno IS NOT NULL AND dt_estorno::text <> '')) nr_seq_lote_contab_prov,
			(	select 	max(nr_sequencia) 
				from 	pls_conta_coparticipacao 
				where 	nr_seq_conta_proc = a.nr_sequencia
				and 	coalesce(dt_estorno::text, '') = '') nr_seq_reg_copartic_atual
	from	pls_conta_proc a
	where 	nr_seq_conta = nr_seq_conta_p
	
union all

	select 	null nr_seq_conta_proc,
			a.nr_sequencia nr_seq_conta_mat,
			(	select 	nr_sequencia 
				from 	pls_conta_coparticipacao 
				where 	(nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')
				and 	nr_seq_conta_mat = a.nr_sequencia
				and 	(dt_estorno IS NOT NULL AND dt_estorno::text <> '')) nr_seq_lote_contab_prov,
			(	select 	max(nr_sequencia) 
				from 	pls_conta_coparticipacao 
				where 	nr_seq_conta_mat = a.nr_sequencia
				and 	coalesce(dt_estorno::text, '') = '') nr_seq_reg_copartic_atual
	from	pls_conta_mat a
	where	a.nr_seq_conta = nr_seq_conta_p;	
	
BEGIN

	--Percorre todos os itens da conta
	for r_c01_w in C01 loop
	
		--Procedimentos
		if (r_c01_w.nr_seq_conta_proc IS NOT NULL AND r_c01_w.nr_seq_conta_proc::text <> '') then
		
			--Se o item tem registro de coparticipa??o anterior(estornado nesse processo)  vinculado ? lote cont?bil, deve atualizar a data de compet?ncia conforme aplica??o do lote(data atual).
			if (r_c01_w.nr_seq_lote_contab_prov IS NOT NULL AND r_c01_w.nr_seq_lote_contab_prov::text <> '') then
			
					update 	pls_conta_copartic_contab
					set	dt_mes_competencia = clock_timestamp()
					where 	nr_seq_conta_copartic = r_c01_w.nr_seq_reg_copartic_atual;
					
					update 	pls_conta_copartic_contab
					set	dt_mes_competencia = clock_timestamp()
					where 	nr_seq_conta_copartic = r_c01_w.nr_seq_reg_copartic_atual;
			
			end if;
		
		-- materiais
		else
			
			--Se o item tem registro de coparticipa??o anterior(estornado nesse processo)  vinculado ? lote cont?bil, deve atualizar a data de compet?ncia conforme aplica??o do lote(data atual).
			if (r_c01_w.nr_seq_lote_contab_prov IS NOT NULL AND r_c01_w.nr_seq_lote_contab_prov::text <> '') then
			
					update 	pls_conta_copartic_contab
					set	dt_mes_competencia = clock_timestamp()
					where 	nr_seq_conta_copartic = r_c01_w.nr_seq_reg_copartic_atual;
					
					update 	pls_conta_copartic_contab
					set	dt_mes_competencia = clock_timestamp()
					where 	nr_seq_conta_copartic = r_c01_w.nr_seq_reg_copartic_atual;
			
			end if;
			
		end if;
		
		--Gera log para registro gerado update aqui fora dos IF's pois nem sempre entrar? na atualiza??o de m?s compet?ncia, por?m sempre dever? gerar o log
		update pls_conta_coparticipacao
		set		ds_observacao = 'Gerado atrav?s de rec?lculo processado via lote de rec?lculo '||nr_seq_lote_p||
								' na fun??o OPS - Controle de Coparticipa??es e P?s Estabelecido'
		where	nr_sequencia = r_c01_w.nr_seq_reg_copartic_atual;
	
	end loop;

END;									

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_copartic_pck.pls_atualiza_dt_mes_comp ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_p pls_recalc_copartic_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
