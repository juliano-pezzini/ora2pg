-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_regra_partic_imp_pck.regra_partic_guia_dth_imp ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
_ora2pg_r RECORD;
qt_grupo_regra_w	integer;
qt_grupo_casou_w	integer;
ds_observacao_w		varchar(32000);
nr_indice_w		integer;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;

c01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type,
		nr_seq_regra_pc		pls_grupo_partic_tm.nr_seq_regra%type) FOR
	SELECT	sel.nr_sequencia,
		sel.cd_guia_referencia,
		sel.nr_seq_segurado, 
		sel.ie_origem_proced,
		sel.cd_procedimento, 
		sel.dt_item
	from 	pls_oc_cta_selecao_imp sel,
		pls_conta_proc_imp proc,
		pls_conta_item_equipe_imp partic
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_tipo_registro = 'P'
	and	sel.ie_valido = 'S'
	and	proc.nr_sequencia = sel.nr_seq_conta_proc
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and 	exists (	SELECT	x.nr_seq_grupo_regra
				from	pls_grupo_partic_tm x
				where	x.nr_seq_regra = nr_seq_regra_pc
				and	x.nr_seq_grau_partic = partic.nr_seq_grau_partic_conv
				and	coalesce(x.nr_seq_prestador, -1) = -1
				and	x.ie_gera_ocorrencia = 'S'
				
union all

				select	x.nr_seq_grupo_regra
				from	pls_grupo_partic_tm x
				where	x.nr_seq_regra = nr_seq_regra_pc
				and	x.nr_seq_prestador = partic.nr_seq_prestador_conv
				and	x.nr_seq_grau_partic = partic.nr_seq_grau_partic_conv
				and	x.ie_gera_ocorrencia = 'S');

c_partic_guia_imp_dth CURSOR(	nr_seq_segurado_pc	pls_conta_imp.nr_seq_segurado_conv%type,
				cd_guia_referencia_pc	pls_conta_imp.cd_guia_ok_conv%type,
				ie_origem_proced_pc	pls_conta_proc_imp.ie_origem_proced_conv%type,
				cd_procedimento_pc	pls_conta_proc_imp.cd_procedimento_conv%type,
				dt_item_pc		pls_conta_proc_imp.dt_execucao_conv%type,
				nr_seq_regra_pc		pls_grupo_partic_tm.nr_seq_regra%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.cd_profissional_conv cd_medico,
		partic.nr_seq_prestador_conv,
		obter_nome_pf(partic.cd_profissional_conv) nm_medico,
		pls_obter_dados_prestador(partic.nr_seq_prestador_conv, 'N') nm_prestador,
		gp.ds_grau_participacao,
		partic.nr_seq_grau_partic_conv nr_seq_grau_partic
	from	pls_conta_imp cta,
		pls_conta_proc_imp proc,
		pls_conta_item_equipe_imp partic,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado_conv = nr_seq_segurado_pc
	and	cta.cd_guia_ok_conv = cd_guia_referencia_pc
	and	proc.dt_execucao_conv = dt_item_pc
	and	proc.nr_seq_conta = cta.nr_sequencia
	and	proc.ie_origem_proced_conv = ie_origem_proced_pc
	and	proc.cd_procedimento_conv = cd_procedimento_pc
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and 	exists (	SELECT	x.nr_seq_grupo_regra
				from	pls_grupo_partic_tm x
				where	x.nr_seq_regra = nr_seq_regra_pc
				and	x.nr_seq_grau_partic = partic.nr_seq_grau_partic_conv
				and	coalesce(x.nr_seq_prestador, -1) = -1
				
union all

				select	x.nr_seq_grupo_regra
				from	pls_grupo_partic_tm x
				where	x.nr_seq_regra = nr_seq_regra_pc
				and	x.nr_seq_prestador = partic.nr_seq_prestador_conv
				and	x.nr_seq_grau_partic = partic.nr_seq_grau_partic_conv)
	and	gp.nr_sequencia = partic.nr_seq_grau_partic_conv;
BEGIN

-- obtém a quantidade de grupos existentes para a regra
qt_grupo_regra_w := pls_regra_partic_imp_pck.obter_qt_grupo_regra(dados_val_partic_p.nr_seq_regra_partic);

nr_indice_w := 0;
SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

-- retorna todos os registros da tabela de seleção que precisam ser processados
-- são somente os que casam com algum item da regra e que tenham sido configurados para gerar ocorrencia (ie_gera_ocorrencia = S)
for r_c01_w in c01(nr_id_transacao_p, dados_val_partic_p.nr_seq_regra_partic) loop

	-- retorna a quantidade de grupos que tiveram casamento
	select	count(distinct nr_seq_grupo_regra) qt_grupo_casou
	into STRICT	qt_grupo_casou_w
	from (
		with query_tmp as (	SELECT	partic.nr_seq_grau_partic_conv nr_seq_grau_partic,
						partic.nr_seq_prestador_conv nr_seq_prestador
					from	pls_conta_imp cta,
						pls_conta_proc_imp proc,
						pls_protocolo_conta_imp prot,
						pls_conta_item_equipe_imp partic
					where	cta.nr_seq_segurado_conv = r_c01_w.nr_seq_segurado
					and	cta.cd_guia_ok_conv = r_c01_w.cd_guia_referencia
					and	cta.nr_seq_protocolo = prot.nr_sequencia
					and	prot.ie_situacao not in ('T','RE')
					and	proc.dt_execucao_conv = r_c01_w.dt_item
					and	proc.nr_seq_conta = cta.nr_sequencia
					and	proc.ie_origem_proced_conv = r_c01_w.ie_origem_proced
					and	proc.cd_procedimento_conv  = r_c01_w.cd_procedimento
					and	partic.nr_seq_conta_proc = proc.nr_sequencia
					
union all

					SELECT	partic.nr_seq_grau_partic,
						partic.nr_seq_prestador
					from	pls_conta cta,
						pls_conta_proc proc,
						pls_proc_participante partic
					where	cta.nr_seq_segurado = r_c01_w.nr_seq_segurado
					and	cta.cd_guia_ok = r_c01_w.cd_guia_referencia
					and	proc.dt_procedimento_referencia = r_c01_w.dt_item
					and	proc.nr_seq_conta = cta.nr_sequencia
					and	proc.ie_origem_proced = r_c01_w.ie_origem_proced
					and	proc.cd_procedimento = r_c01_w.cd_procedimento
					and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
					and	partic.nr_seq_conta_proc = proc.nr_sequencia
					and	partic.ie_status in ('L', 'P', 'U')
					and	partic.ie_gerada_cta_honorario = 'N'
					
union all

					select	cta.nr_seq_grau_partic,
						cta.nr_seq_prestador_exec_imp_ref nr_seq_prestador
					from	pls_conta cta,
						pls_conta_proc proc
					where	cta.nr_seq_segurado = r_c01_w.nr_seq_segurado
					and	cta.cd_guia_ok = r_c01_w.cd_guia_referencia
					and	proc.dt_procedimento_referencia = r_c01_w.dt_item
					and	proc.nr_seq_conta = cta.nr_sequencia
					and	proc.ie_origem_proced = r_c01_w.ie_origem_proced
					and	proc.cd_procedimento = r_c01_w.cd_procedimento
					and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
					and	not exists (	select	1
									from	pls_proc_participante x
									where	x.nr_seq_conta_proc = proc.nr_sequencia))
		select	distinct x.nr_seq_grupo_regra
		from	query_tmp xpto,
			pls_grupo_partic_tm x
		where	x.nr_seq_regra = dados_val_partic_p.nr_seq_regra_partic
		and     x.nr_seq_grau_partic = xpto.nr_seq_grau_partic
		and	coalesce(x.nr_seq_prestador, -1) = -1
		
union all

		select	distinct x.nr_seq_grupo_regra
		from	query_tmp xpto,
			pls_grupo_partic_tm x
		where	x.nr_seq_regra = dados_val_partic_p.nr_seq_regra_partic
		and	x.nr_seq_prestador = xpto.nr_seq_prestador
		and	x.nr_seq_grau_partic = xpto.nr_seq_grau_partic) alias9;

	-- se a quantidade de grupos da regra for igual a que retornou no select significa que todos os grupos
	-- tiveram pelo menos um casamento, ou seja, deve ser gerada a ocorrência
	if ( qt_grupo_casou_w = qt_grupo_regra_w ) then

		ds_observacao_w := null;
		-- busca os dados para gerar a observação da ocorrência
		for r_c_partic_guia_w in c_partic_guia_imp_dth(	r_c01_w.nr_seq_segurado, r_c01_w.cd_guia_referencia,
								r_c01_w.ie_origem_proced, r_c01_w.cd_procedimento,
								r_c01_w.dt_item, dados_val_partic_p.nr_seq_regra_partic) loop

			-- armazena os dados na variável para mais abaixo gravar na seleção
			ds_observacao_w := substr(ds_observacao_w || 	'Conta: ' || r_c_partic_guia_w.nr_seq_conta ||
									' Proc: ' || r_c_partic_guia_w.nr_seq_proc ||
									' Grau partic: ' || r_c_partic_guia_w.ds_grau_participacao ||
									' Prof: ' || r_c_partic_guia_w.nm_medico ||
									' Prest: ' || r_c_partic_guia_w.nm_prestador ||
									pls_util_pck.enter_w, 1, 10000);
		
		end loop;

		-- Alimenta as listas com as informações para gravar no banco todas de uma vez
		tb_seq_selecao_w(nr_indice_w)	:= r_c01_w.nr_sequencia;
		tb_observacao_w(nr_indice_w)	:= substr(ds_observacao_w, 1, 2000);
		tb_valido_w(nr_indice_w)	:= 'S';

		if (nr_indice_w >= pls_util_pck.qt_registro_transacao_w) then
			--Grava as informações na tabela de seleção
			CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
									tb_observacao_w, nr_id_transacao_p,
									'SEQ');	
			
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
			nr_indice_w := 0;
		else
			nr_indice_w := nr_indice_w + 1;
		end if;
	end if;
end loop;

--Grava as informações na tabela de seleção
CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
						tb_observacao_w, nr_id_transacao_p,
						'SEQ');	

SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
						
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_partic_imp_pck.regra_partic_guia_dth_imp ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
