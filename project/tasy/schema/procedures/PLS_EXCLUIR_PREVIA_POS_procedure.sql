-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_previa_pos ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_exclusao_p text) AS $body$
DECLARE


/*nr_seq_tx_opme lancamento de itens de faturamento manual nao ira desconsiderar, pois aqui a rotina remove esses itens e depois na chamada da gerar_valor_pos_estab
ira lancar novamente eles, fazendo a leitura da regra convenientemente com o momento da consistencia da conta*/
--ie_tipo_exclusao_p = T - Exclui previa e lancamentos de itens que implicam em geracao de pos-estabelecido, posteriormente
--ie_tipo_exclusao_p = P - Exclui apenas registros de previa de pos-estabelecido
qt_vinc_contab_w		integer := 0;
qt_contab_vinc_lote_w		integer := 0;
qt_vinc_fatura_w		integer := 0;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_conta_proc,
		nr_seq_conta_mat
	from	pls_conta_pos_estab_prev
	where	nr_seq_conta = nr_seq_conta_p;
BEGIN
	
	select count(1)
	into STRICT	qt_vinc_contab_w
	from	pls_conta_pos_estab_prev
	where 	nr_seq_conta = nr_seq_conta_p
	and 	(nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '');

	--Se tiver algum registro na conta que tenha vinculo com lote contabil, entao nem limpa mais, pois nao ocorrera lancamento mais da previa de pos
	if (qt_vinc_contab_w = 0) then
		
		select 	count(1)
		into STRICT	qt_contab_vinc_lote_w
		from 	pls_conta a,
			pls_conta_pos_estab_prev b,
			pls_conta_pos_estab_contab c
		where 	a.nr_sequencia = nr_seq_conta_p
		and 	a.nr_sequencia = b.nr_seq_conta
		and	c.nr_seq_previa_pos = b.nr_sequencia
		and 	(c.nr_lote_contabil_prov IS NOT NULL AND c.nr_lote_contabil_prov::text <> '')
		and 	c.nr_lote_contabil_prov != 0;
	
		if ( qt_contab_vinc_lote_w = 0 ) then
	
			--verifica se tem vinculo com lote de faturamento. Pode cair aqui nessa situacao se utilizado processos de contas medicas
			select 	count(1)
			into STRICT	qt_vinc_fatura_w
			from (
				SELECT 	nr_sequencia nr_seq_contab
				from	pls_fatura_Proc
				where 	nr_seq_conta_pos_contab in (
					SELECT 	c.nr_sequencia
					from 	pls_conta a,
						pls_conta_pos_estab_prev b,
						pls_conta_pos_estab_contab c
					where 	a.nr_sequencia = nr_seq_conta_p
					and 	a.nr_sequencia = b.nr_seq_conta
					and	c.nr_seq_previa_pos = b.nr_sequencia
				)
				
union all
	
				select 	nr_sequencia nr_seq_contab
				from	pls_fatura_mat
				where 	nr_seq_conta_pos_contab in (
					select 	c.nr_sequencia
					from 	pls_conta a,
						pls_conta_pos_estab_prev b,
						pls_conta_pos_estab_contab c
					where 	a.nr_sequencia = nr_seq_conta_p
					and 	a.nr_sequencia = b.nr_seq_conta
					and	c.nr_seq_previa_pos = b.nr_sequencia
				)
			) alias4;
		
		
			if (qt_vinc_fatura_w = 0) then
	
				delete from pls_cta_pos_estab_ctb_log
				where nr_seq_conta_pos_contab in (
					SELECT 	c.nr_sequencia
					from 	pls_conta a,
						pls_conta_pos_estab_prev b,
						pls_conta_pos_estab_contab c
					where 	a.nr_sequencia = nr_seq_conta_p
					and 	a.nr_sequencia = b.nr_seq_conta
					and	c.nr_seq_previa_pos = b.nr_sequencia
				
				);
				
				delete from pls_pos_estab_dados_contab
				where nr_seq_pos_estab_contab in (
					SELECT 	c.nr_sequencia
					from 	pls_conta a,
						pls_conta_pos_estab_prev b,
						pls_conta_pos_estab_contab c
					where 	a.nr_sequencia = nr_seq_conta_p
					and 	a.nr_sequencia = b.nr_seq_conta
					and	c.nr_seq_previa_pos = b.nr_sequencia
				
				);
				
				delete from pls_conta_pos_estab_contab
				where nr_sequencia in (
					SELECT 	c.nr_sequencia
					from 	pls_conta a,
						pls_conta_pos_estab_prev b,
						pls_conta_pos_estab_contab c
					where 	a.nr_sequencia = nr_seq_conta_p
					and 	a.nr_sequencia = b.nr_seq_conta
					and	c.nr_seq_previa_pos = b.nr_sequencia
				
				);
			
			
				if (ie_tipo_exclusao_p = 'T') then
					
					for r_c01_w in C01 loop
					
						update pls_conta_pos_estab_prev
						set	nr_seq_conta_proc  = NULL,
							nr_seq_conta_mat  = NULL
						where 	nr_sequencia = r_c01_w.nr_sequencia;

						delete from pls_hist_analise_conta where nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
						delete from pls_hist_analise_conta where nr_seq_conta_mat = r_c01_w.nr_seq_conta_mat;
						
					end loop;
							
					--se sobrar algum item que nao teve vinculo a previa, mas sera excluido como fat manual a seguir, necessita apagar historico			
					delete from pls_hist_analise_conta where nr_seq_conta_proc in ( 	SELECT 	nr_sequencia
						from	pls_conta_Proc a
						where   ie_status = 'M'
						and 	coalesce(a.nr_seq_regra_lanc_aut::text, '') = '' --nao exclui itens lancados por regra de lancamento automatico
						and a.nr_seq_conta = nr_seq_conta_p
						and (SELECT count(1) from pls_conta where nr_sequencia = a.nr_seq_conta and (nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')) = 0 --ajuste de refaturamento tambem
						and (select count(1) from pls_conta_pos_estab_prev where nr_Seq_conta_proc = a.nr_sequencia and (nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')) = 0
						and (select count(1) from pls_conta_pos_estabelecido where nr_seq_conta_proc = a.nr_sequencia) = 0 --se tiver vinculo com pos, nao exclui
						and (select count(1) from pls_conta_coparticipacao where nr_Seq_conta_proc = a.nr_sequencia) = 0);
							
					--se sobrar algum item que nao teve vinculo a previa, mas sera excluido como fat manual a seguir, necessita apagar historico
					delete from pls_hist_analise_conta where nr_seq_conta_mat in (
						SELECT 	nr_sequencia
						from 	pls_conta_mat a
						where   ie_status = 'M'
						and 	coalesce(a.nr_seq_regra_lanc_aut::text, '') = '' --nao exclui itens lancados por regra de lancamento automatico
						and 	a.nr_seq_conta = nr_seq_conta_p
						and (SELECT count(1) from pls_conta where nr_sequencia = a.nr_seq_conta and (nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')) = 0 --ajuste de refaturamento tambem
						and (select count(1) from pls_conta_pos_estab_prev where nr_Seq_conta_mat = a.nr_sequencia and (nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')) = 0
						and (select count(1) from pls_conta_pos_estabelecido where nr_seq_conta_mat = a.nr_sequencia) = 0 --se tiver vinculo com pos, nao exclui
						and (select count(1) from pls_conta_coparticipacao where nr_Seq_conta_mat = a.nr_sequencia) = 0
					);
					
					delete from pls_analise_fluxo_item where nr_seq_conta_proc in -- delete necessario para quando o item tem algum vinculo com o fluxo. OS 2447870.
					( 	SELECT 	nr_sequencia
						from	pls_conta_Proc a
						where   ie_status = 'M'
						and 	coalesce(a.nr_seq_regra_lanc_aut::text, '') = '' --nao exclui itens lancados por regra de lancamento automatico
						and a.nr_seq_conta = nr_seq_conta_p
						and (SELECT count(1) from pls_conta where nr_sequencia = a.nr_seq_conta and (nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')) = 0 --ajuste de refaturamento tambem
						and (select count(1) from pls_conta_pos_estab_prev where nr_Seq_conta_proc = a.nr_sequencia and (nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')) = 0
						and (select count(1) from pls_conta_pos_estabelecido where nr_seq_conta_proc = a.nr_sequencia) = 0 --se tiver vinculo com pos, nao exclui
						and (select count(1) from pls_conta_coparticipacao where nr_Seq_conta_proc = a.nr_sequencia) = 0);
					
					delete from pls_analise_fluxo_item where nr_seq_conta_mat in (
						SELECT 	nr_sequencia
						from 	pls_conta_mat a
						where   ie_status = 'M'
						and 	coalesce(a.nr_seq_regra_lanc_aut::text, '') = '' --nao exclui itens lancados por regra de lancamento automatico
						and 	a.nr_seq_conta = nr_seq_conta_p
						and (SELECT count(1) from pls_conta where nr_sequencia = a.nr_seq_conta and (nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')) = 0 --ajuste de refaturamento tambem
						and (select count(1) from pls_conta_pos_estab_prev where nr_Seq_conta_mat = a.nr_sequencia and (nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')) = 0
						and (select count(1) from pls_conta_pos_estabelecido where nr_seq_conta_mat = a.nr_sequencia) = 0 --se tiver vinculo com pos, nao exclui
						and (select count(1) from pls_conta_coparticipacao where nr_Seq_conta_mat = a.nr_sequencia) = 0
					);
							
					--Exclui itens de faturamento manual(lancamento automatico) com vinculo com previa de pos-estabelecido
					delete from pls_conta_Proc a
					where   ie_status = 'M'
					and 	coalesce(a.nr_seq_regra_lanc_aut::text, '') = '' --nao exclui itens lancados por regra de lancamento automatico
					and a.nr_seq_conta = nr_seq_conta_p
					and (SELECT count(1) from pls_conta where nr_sequencia = a.nr_seq_conta and (nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')) = 0 --ajuste de refaturamento tambem
					and (select count(1) from pls_conta_pos_estab_prev where nr_Seq_conta_proc = a.nr_sequencia and (nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')) = 0
					and (select count(1) from pls_conta_pos_estabelecido where nr_seq_conta_proc = a.nr_sequencia) = 0 --se tiver vinculo com pos, nao exclui
					and (select count(1) from pls_conta_coparticipacao where nr_Seq_conta_proc = a.nr_sequencia) = 0;
					
					delete from pls_conta_mat a
					where   ie_status = 'M'
					and 	coalesce(a.nr_seq_regra_lanc_aut::text, '') = '' --nao exclui itens lancados por regra de lancamento automatico
					and 	a.nr_seq_conta = nr_seq_conta_p
					and (SELECT count(1) from pls_conta where nr_sequencia = a.nr_seq_conta and (nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')) = 0 --ajuste de refaturamento tambem
					and (select count(1) from pls_conta_pos_estab_prev where nr_Seq_conta_mat = a.nr_sequencia and (nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '')) = 0
					and (select count(1) from pls_conta_pos_estabelecido where nr_seq_conta_mat = a.nr_sequencia) = 0 --se tiver vinculo com pos, nao exclui
					and (select count(1) from pls_conta_coparticipacao where nr_Seq_conta_mat = a.nr_sequencia) = 0;
					
				end if;
				
				for r_c01_w in C01 loop
				
					delete from pls_conta_pos_estab_prev
					where 	nr_sequencia = r_c01_w.nr_sequencia;
				
				end loop;
			end if;

		end if;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_previa_pos ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_exclusao_p text) FROM PUBLIC;

