-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- faz o processamento da regra de grau duplicado que tenha a pesquisa por guia
CREATE OR REPLACE PROCEDURE pls_regra_partic_imp_pck.processa_grau_duplicado_guia ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_seq_grau_partic_ultimo_w	pls_grau_participacao.nr_sequencia%type;
ds_observacao_temp_w		varchar(10000);
ds_observacao_w			varchar(30000);
qt_partic_igual_w		integer;
dados_tb_selecao_w		pls_ocor_imp_pck.dados_table_selecao_ocor;
tb_seq_selecao_w		pls_util_cta_pck.t_number_table;
tb_valido_w			pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w			pls_util_cta_pck.t_varchar2_table_4000;
nr_indice_w			integer;
qt_partic_grau_w		integer :=0;

c01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		sel.cd_guia_referencia,
		sel.ie_origem_proced,
		sel.cd_procedimento,
		sel.dt_item,
		sel.nr_seq_segurado,
		sel.nr_seq_conta_proc,
		sel.nr_seq_conta
	from	pls_oc_cta_selecao_imp sel
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_tipo_registro = 'P'
	and	sel.ie_valido = 'S';

/*
	Nesse cursorm busca outras incidências com mesmo grau de partic, considerando, procedimento, guia e e data e hora de execução. 
	No Cursor, primeiro verifica com outros itens sendo importados e também o que já está na base(Quando por guia, precisa considerar
	que uma parte pode já estar integrada)
*/
	
c02 CURSOR(	nr_seq_segurado_pc	pls_conta.nr_seq_segurado%type,
		cd_guia_referencia_pc	pls_conta.cd_guia%type,
		ie_origem_proced_pc	pls_conta_proc.ie_origem_proced%type,
		cd_procedimento_pc	pls_conta_proc.cd_procedimento%type,
		dt_procedimento_pc	pls_conta_proc.dt_procedimento%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.nr_seq_grau_partic_conv nr_seq_grau_partic,
		gp.ds_grau_participacao,
		'N' ie_glosa, -- Como essa parte do union se refere ao que está sendo importado, automaticamente considera não glosado
		'P' origem_grau_partic  --buscando grau participação diretamente do participante
	from	pls_conta_imp cta,
		pls_conta_proc_imp proc,
		pls_protocolo_conta_imp prot,
		pls_conta_item_equipe_imp partic,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado_conv = nr_seq_segurado_pc
	and	cta.cd_guia_ok_conv 	= cd_guia_referencia_pc
	and	cta.nr_seq_protocolo	= prot.nr_sequencia
	and	prot.ie_situacao not in ('T', 'RE')
	and 	proc.dt_execucao_conv 	= dt_procedimento_pc
	and	proc.nr_seq_conta 	= cta.nr_sequencia
	and	proc.ie_origem_proced_conv 	= ie_origem_proced_pc
	and	proc.cd_procedimento_conv  	= cd_procedimento_pc
	and	partic.nr_seq_conta_proc 	= proc.nr_sequencia
	and	gp.nr_sequencia = partic.nr_seq_grau_partic_conv
	
union all

	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.nr_seq_grau_partic,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa,
		'P' origem_grau_partic  --buscando grau participação diretamente do participante
	from	pls_conta cta,
		pls_conta_proc proc,
		pls_proc_participante partic,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado = nr_seq_segurado_pc
	and	cta.cd_guia_ok = cd_guia_referencia_pc
	and 	proc.dt_procedimento_referencia = dt_procedimento_pc
	and	proc.nr_seq_conta = cta.nr_sequencia
	and	proc.ie_origem_proced = ie_origem_proced_pc
	and	proc.cd_procedimento = cd_procedimento_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	partic.ie_status in ('L', 'P', 'U')
	and	coalesce(partic.ie_gerada_cta_honorario,'N') = 'N'
	and	gp.nr_sequencia = partic.nr_seq_grau_partic
	
union all

	select	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		cta.nr_seq_grau_partic,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa,
		'C' origem_grau_partic  --buscando grau participação diretamente da conta por não ter participante
	from	pls_conta cta,
		pls_conta_proc proc,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado = nr_seq_segurado_pc
	and	cta.cd_guia_ok = cd_guia_referencia_pc
	and 	proc.dt_procedimento_referencia = dt_procedimento_pc
	and	proc.nr_seq_conta = cta.nr_sequencia
	and	proc.ie_origem_proced = ie_origem_proced_pc
	and	proc.cd_procedimento = cd_procedimento_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	not exists (	select	1
					from	pls_proc_participante x
					where	x.nr_seq_conta_proc = proc.nr_sequencia)
	and	gp.nr_sequencia = cta.nr_seq_grau_partic
	order by nr_seq_grau_partic;

/*	
	Nesse cursor busca outras incidências com mesmo grau de partic, considerando, procedimento, guia e e data e hora de execução. 
	No Cursor, primeiro verifica com outros itens sendo importados e também o que já está na base(Quando por guia, precisa considerar
	que uma parte pode já estar integrada)
	
	Faz o mesmo que o cursor2, porém leva em conta data truncada, pois considerará a regra sem a hora do procedimento
*/
c03 CURSOR(	nr_seq_segurado_pc	pls_conta.nr_seq_segurado%type,
		cd_guia_referencia_pc	pls_conta.cd_guia%type,
		ie_origem_proced_pc	pls_conta_proc.ie_origem_proced%type,
		cd_procedimento_pc	pls_conta_proc.cd_procedimento%type,
		dt_procedimento_pc	pls_conta_proc.dt_procedimento%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.nr_seq_grau_partic_conv nr_seq_grau_partic,
		gp.ds_grau_participacao,
		'N' ie_glosa, -- Como essa parte do union se refere ao que está sendo importado, automaticamente considera não glosado
		'P' origem_grau_partic  --buscando grau participação diretamente do participante
	from	pls_conta_imp cta,
		pls_conta_proc_imp proc,
		pls_protocolo_conta_imp prot,
		pls_conta_item_equipe_imp partic,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado_conv = nr_seq_segurado_pc
	and	cta.cd_guia_ok_conv 	= cd_guia_referencia_pc
	and	prot.nr_sequencia	= cta.nr_seq_protocolo
	and	prot.ie_situacao not in ('T','RE')
	and 	proc.dt_execucao_trunc_conv 	= dt_procedimento_pc
	and	proc.nr_seq_conta 	= cta.nr_sequencia
	and	proc.ie_origem_proced_conv 	= ie_origem_proced_pc
	and	proc.cd_procedimento_conv  	= cd_procedimento_pc
	and	partic.nr_seq_conta_proc 	= proc.nr_sequencia
	and	gp.nr_sequencia = partic.nr_seq_grau_partic_conv
	
union all

	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.nr_seq_grau_partic,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa,
		'P' origem_grau_partic  --buscando grau participação diretamente do participante
	from	pls_conta cta,
		pls_conta_proc proc,
		pls_proc_participante partic,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado = nr_seq_segurado_pc
	and	cta.cd_guia_ok = cd_guia_referencia_pc
	and	proc.dt_procedimento_referencia_sh = dt_procedimento_pc
	and	proc.nr_seq_conta = cta.nr_sequencia
	and	proc.ie_origem_proced = ie_origem_proced_pc
	and	proc.cd_procedimento = cd_procedimento_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	partic.ie_status in ('L', 'P', 'U')
	and	coalesce(partic.ie_gerada_cta_honorario,'N') = 'N'
	and	gp.nr_sequencia = partic.nr_seq_grau_partic
	
union all

	select	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		cta.nr_seq_grau_partic,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa,
		'C' origem_grau_partic  --buscando grau participação diretamente da conta por não ter participante
	from	pls_conta cta,
		pls_conta_proc proc,
		pls_grau_participacao gp
	where	cta.nr_seq_segurado = nr_seq_segurado_pc
	and	cta.cd_guia_ok = cd_guia_referencia_pc
	and	proc.dt_procedimento_referencia_sh = dt_procedimento_pc
	and	proc.nr_seq_conta = cta.nr_sequencia
	and	proc.ie_origem_proced = ie_origem_proced_pc
	and	proc.cd_procedimento = cd_procedimento_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	not exists (	select	1
					from	pls_proc_participante x
					where	x.nr_seq_conta_proc = proc.nr_sequencia)
	and	gp.nr_sequencia = cta.nr_seq_grau_partic
	order by nr_seq_grau_partic;
BEGIN

nr_indice_w := 0;
-- Incializar as listas para cada regra.
SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

-- busca todos os dados da tabela de seleção que precisam ser validados
for r_c01_w in c01(nr_id_transacao_p) loop

	nr_seq_grau_partic_ultimo_w := null;
	ds_observacao_w := null;
	ds_observacao_temp_w := null;
	qt_partic_igual_w := 0;

	case(dados_val_partic_p.ie_incidencia)
		-- mesma guia, procedimento, data e hora
		when 'GPDH' then

			for r_c02_w in c02(	r_c01_w.nr_seq_segurado, r_c01_w.cd_guia_referencia,
						r_c01_w.ie_origem_proced, r_c01_w.cd_procedimento,
						r_c01_w.dt_item) loop

				if	(dados_val_partic_p.ie_glosa = 'S' AND r_c02_w.ie_glosa = 'N') or (dados_val_partic_p.ie_glosa = 'N') then
				
					-- se o grau de participação anterior for igual ao atual significa que já duplicou
					-- primeira comparação sempre dá verdadeiro quando ainda não existe o grau de participação anterior
					if (coalesce( nr_seq_grau_partic_ultimo_w, r_c02_w.nr_seq_grau_partic) = r_c02_w.nr_seq_grau_partic) then
					
						select	count(1)
						into STRICT	qt_partic_grau_w
						from	pls_conta_item_equipe_imp a
						where	nr_seq_conta_proc 	= r_c01_w.nr_seq_conta_proc
						and	nr_seq_grau_partic_conv = r_c02_w.nr_seq_grau_partic;
					
						--Para garantir que o procedimento em questão tem um participante com grau na qual identificou-se estar duplicado.
						if ( qt_partic_grau_w > 0) then
							qt_partic_igual_w := qt_partic_igual_w + 1;
						else
							-- se não for igual significa que mudou de partic
							-- verifica se existe duplicidade e se sim grava a observação
							if ( qt_partic_igual_w > 1) then
								ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
							end if;

							-- reinicializa as variáveis
							ds_observacao_temp_w := null;
							qt_partic_igual_w := 1;
						end if;
					else
						-- se não for igual significa que mudou de partic
						-- verifica se existe duplicidade e se sim grava a observação
						if ( qt_partic_igual_w > 1) then
							ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
						end if;

						-- reinicializa as variáveis
						ds_observacao_temp_w := null;
						qt_partic_igual_w := 1;
					end if;

					-- armazena os dados na variável
					ds_observacao_temp_w := substr(ds_observacao_temp_w || 	'Conta: ' || r_c02_w.nr_seq_conta ||
												' Proc: ' || r_c02_w.nr_seq_proc ||
												' Grau partic: ' || r_c02_w.ds_grau_participacao ||
												pls_util_pck.enter_w, 1, 10000);

					nr_seq_grau_partic_ultimo_w := r_c02_w.nr_seq_grau_partic;	
				end if;
				
			end loop;

		-- mesma guia, procedimento e data
		when 'GPD' then

			for r_c03_w in c03(	r_c01_w.nr_seq_segurado, r_c01_w.cd_guia_referencia,
						r_c01_w.ie_origem_proced, r_c01_w.cd_procedimento,
						trunc(r_c01_w.dt_item, 'dd')) loop
						
				if	(dados_val_partic_p.ie_glosa = 'S' AND r_c03_w.ie_glosa = 'N') or (dados_val_partic_p.ie_glosa = 'N') then
				
					-- se o grau de participação anterior for igual ao atual significa que já duplicou
					-- primeira comparação sempre dá verdadeiro quando ainda não existe o grau de participação anterior
					if (coalesce(nr_seq_grau_partic_ultimo_w, r_c03_w.nr_seq_grau_partic) = r_c03_w.nr_seq_grau_partic) then
					
						select	count(1)
						into STRICT	qt_partic_grau_w
						from	pls_conta_item_equipe_imp a
						where	nr_seq_conta_proc 	= r_c01_w.nr_seq_conta_proc
						and	nr_seq_grau_partic_conv = r_c03_w.nr_seq_grau_partic;
						
						--Para garantir que o procedimento em questão tem um participante com grau na qual identificou-se estar duplicado.
						if (qt_partic_grau_w > 0) then
							qt_partic_igual_w := qt_partic_igual_w + 1;
						else
							-- se não for igual significa que mudou de partic
							-- verifica se existe duplicidade e se sim grava a observação
							if (qt_partic_igual_w > 1) then
								ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
							end if;

							-- reinicializa as variáveis
							ds_observacao_temp_w := null;
							qt_partic_igual_w := 1;
						end if;
					else
						-- se não for igual significa que mudou de partic
						-- verifica se existe duplicidade e se sim grava a observação
						if (qt_partic_igual_w > 1) then
							ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
						end if;

						-- reinicializa as variáveis
						ds_observacao_temp_w := null;
						qt_partic_igual_w := 1;
					end if;

					-- armazena os dados na variável
					ds_observacao_temp_w := substr(ds_observacao_temp_w || 	'Conta: ' || r_c03_w.nr_seq_conta ||
												' Proc: ' || r_c03_w.nr_seq_proc ||
												' Grau partic: ' || r_c03_w.ds_grau_participacao ||
												pls_util_pck.enter_w, 1, 10000);

					nr_seq_grau_partic_ultimo_w := r_c03_w.nr_seq_grau_partic;
				end if;
				
			end loop;
		else
			null;
	end case;

	-- se os últimos partics são iguais grava na observação
	if (qt_partic_igual_w > 1) then
		ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
	end if;

	-- se tiver observação significa que deve lançar ocorrência
	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		
		-- Alimenta as listas com as informações para gravar no banco todas de uma vez
		tb_seq_selecao_w(nr_indice_w)	:= r_c01_w.nr_seq_selecao;
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

--Grava as informações que sobraram nas estruturas  na tabela de seleção
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
-- REVOKE ALL ON PROCEDURE pls_regra_partic_imp_pck.processa_grau_duplicado_guia ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
