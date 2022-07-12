-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- faz o processamento da regra dentro da sequencia do procedimento para verificar se o participante esta duplicado

-- no evento de importacao de XML



CREATE OR REPLACE PROCEDURE pls_regra_partic_pck.partic_duplicado_proc_imp ( nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type, dados_val_partic_p pls_tipos_ocor_pck.dados_val_partic) AS $body$
DECLARE


ds_registro_atual_w	varchar(300);
ds_ultimo_registro_w	varchar(300);
ds_observacao_temp_w	varchar(10000);
ds_observacao_w		varchar(30000);
qt_partic_igual_w	integer;

dados_tb_selecao_w	pls_tipos_ocor_pck.dados_table_selecao_ocor;
nr_indice_w		integer;

c01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		sel.nr_seq_conta_proc
	from	pls_selecao_ocor_cta sel
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_tipo_registro = 'P'
	and	sel.ie_valido = 'S';

c02 CURSOR(	nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.cd_medico_imp cd_medico,
		partic.nr_seq_prestador,
		obter_nome_pf(partic.cd_medico_imp) nm_medico,
		pls_obter_dados_prestador(partic.nr_seq_prestador, 'N') nm_prestador,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa
	from	pls_conta_proc proc,
		pls_proc_participante partic,
		pls_grau_participacao gp
	where	proc.nr_sequencia = nr_seq_conta_proc_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	partic.ie_status in ('L', 'P', 'U')
	and	gp.nr_sequencia = partic.nr_seq_grau_partic
	
union all

	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		cta.cd_medico_executor_imp cd_medico,
		cta.nr_seq_prestador_exec_imp_ref nr_seq_prestador,
		obter_nome_pf(cta.cd_medico_executor_imp) nm_medico,
		pls_obter_dados_prestador(cta.nr_seq_prestador_exec_imp_ref, 'N') nm_prestador,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa
	from	pls_conta_proc proc,
		pls_conta cta,
		pls_grau_participacao gp
	where	proc.nr_sequencia = nr_seq_conta_proc_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	not exists (	select	1
					from	pls_proc_participante x
					where	x.nr_seq_conta_proc = proc.nr_sequencia)
	and	cta.nr_sequencia = proc.nr_seq_conta
	and	gp.nr_sequencia = cta.nr_seq_grau_partic
	order by cd_medico;

c03 CURSOR(	nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.cd_medico_imp cd_medico,
		partic.nr_seq_prestador,
		obter_nome_pf(partic.cd_medico_imp) nm_medico,
		pls_obter_dados_prestador(partic.nr_seq_prestador, 'N') nm_prestador,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa
	from	pls_conta_proc proc,
		pls_proc_participante partic,
		pls_grau_participacao gp
	where	proc.nr_sequencia = nr_seq_conta_proc_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	partic.ie_status in ('L', 'P', 'U')
	and	gp.nr_sequencia = partic.nr_seq_grau_partic
	
union all

	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		cta.cd_medico_executor_imp cd_medico,
		cta.nr_seq_prestador_exec_imp_ref nr_seq_prestador,
		obter_nome_pf(cta.cd_medico_executor_imp) nm_medico,
		pls_obter_dados_prestador(cta.nr_seq_prestador_exec_imp_ref, 'N') nm_prestador,
		gp.ds_grau_participacao,
		coalesce(proc.ie_glosa,'N') ie_glosa
	from	pls_conta_proc proc,
		pls_conta cta,
		pls_grau_participacao gp
	where	proc.nr_sequencia = nr_seq_conta_proc_pc
	and	proc.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U')
	and	not exists (	select	1
					from	pls_proc_participante x
					where	x.nr_seq_conta_proc = proc.nr_sequencia)
	and	cta.nr_sequencia = proc.nr_seq_conta
	and	gp.nr_sequencia = cta.nr_seq_grau_partic
	order by nr_seq_prestador;

BEGIN

nr_indice_w := 0;

-- retorna todos os registros de procedimento e o correspondente na selecao

for r_c01_w in c01(nr_id_transacao_p) loop

	ds_ultimo_registro_w := null;
	ds_observacao_w := null;
	ds_observacao_temp_w := null;
	qt_partic_igual_w := 0;

	-- percorre todos os participantes do procedimento

	-- aqui e verificado a duplicidade do campo cd_medico

	for r_c02_w in c02(r_c01_w.nr_seq_conta_proc) loop

		ds_registro_atual_w := r_c02_w.cd_medico;

		if	((coalesce(dados_val_partic_p.ie_glosa, 'N') = 'S') and (r_c02_w.ie_glosa = 'N')) or (coalesce(dados_val_partic_p.ie_glosa, 'N') = 'N') then
			
			-- para validar o participante usa prestador e medico juntos

			-- a Rio Preto alimenta so o prestador e os demais clientes alimentam os dois campos

			-- se o o prestador e medico executor anterior for igual ao atual significa que ja duplicou

			-- primeira comparacao sempre da verdadeiro quando ainda nao existe o grau de participacao anterior

			if (coalesce(ds_ultimo_registro_w, ds_registro_atual_w) = ds_registro_atual_w) then
				qt_partic_igual_w := qt_partic_igual_w + 1;
			else
				-- se nao for igual significa que mudou de partic

				-- verifica se existe duplicidade e se sim grava a observacao

				if (qt_partic_igual_w > 1) then
					ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
				end if;

				-- reinicializa as variaveis

				ds_observacao_temp_w := null;
				qt_partic_igual_w := 1;
			end if;

			-- armazena os dados na variavel

			ds_observacao_temp_w := substr(ds_observacao_temp_w || 	'Conta: ' || r_c02_w.nr_seq_conta || ' Proc: ' || r_c02_w.nr_seq_proc ||
										' Grau partic: ' || r_c02_w.ds_grau_participacao ||
										' Prof: ' || r_c02_w.nm_medico ||
										pls_util_pck.enter_w, 1, 10000);
			ds_ultimo_registro_w := ds_registro_atual_w;
		end if;
	end loop;

	-- se os ultimos partics sao iguais grava na observacao

	if (qt_partic_igual_w > 1) then
		ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
	end if;

	-- se tiver observacao significa que deve lancar ocorrencia

	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then

		dados_tb_selecao_w.ie_valido(nr_indice_w) := 'S';
		dados_tb_selecao_w.nr_seq_selecao(nr_indice_w) := r_c01_w.nr_seq_selecao;
		dados_tb_selecao_w.ds_seqs_selecao(nr_indice_w) := null;
		dados_tb_selecao_w.ds_observacao(nr_indice_w) := substr(ds_observacao_w, 1, 2000);

		if (nr_indice_w >= pls_util_pck.qt_registro_transacao_w) then
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao,
									dados_tb_selecao_w.ds_seqs_selecao,
									'SEQ',
									dados_tb_selecao_w.ds_observacao,
									dados_tb_selecao_w.ie_valido,
									nm_usuario_p);
			dados_tb_selecao_w.nr_seq_selecao.delete;
			dados_tb_selecao_w.ds_seqs_selecao.delete;
			dados_tb_selecao_w.ie_valido.delete;
			dados_tb_selecao_w.ds_observacao.delete;
			nr_indice_w := 0;
		else
			nr_indice_w := nr_indice_w + 1;
		end if;
	end if;

	ds_ultimo_registro_w := null;
	ds_observacao_w := null;
	ds_observacao_temp_w := null;
	qt_partic_igual_w := 0;

	-- percorre todos os participantes do procedimento

	-- aqui verifica o campo do prestador

	for r_c03_w in c03(r_c01_w.nr_seq_conta_proc) loop

		ds_registro_atual_w := to_char(r_c03_w.nr_seq_prestador);

		if	((coalesce(dados_val_partic_p.ie_glosa, 'N') = 'S') and (r_c03_w.ie_glosa = 'N')) or (coalesce(dados_val_partic_p.ie_glosa, 'N') = 'N') then
			-- para validar o participante usa prestador e medico juntos

			-- a Rio Preto alimenta so o prestador e os demais clientes alimentam os dois campos

			-- se o o prestador e medico executor anterior for igual ao atual significa que ja duplicou

			-- primeira comparacao sempre da verdadeiro quando ainda nao existe o grau de participacao anterior

			if (coalesce(ds_ultimo_registro_w, ds_registro_atual_w) = ds_registro_atual_w) then
				qt_partic_igual_w := qt_partic_igual_w + 1;
			else
				-- se nao for igual significa que mudou de partic

				-- verifica se existe duplicidade e se sim grava a observacao

				if (qt_partic_igual_w > 1) then
					ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
				end if;

				-- reinicializa as variaveis

				ds_observacao_temp_w := null;
				qt_partic_igual_w := 1;
			end if;

			-- armazena os dados na variavel

			ds_observacao_temp_w := substr(ds_observacao_temp_w || 	'Conta: ' || r_c03_w.nr_seq_conta || ' Proc: ' || r_c03_w.nr_seq_proc ||
										' Grau partic: ' || r_c03_w.ds_grau_participacao ||
										' Prest: ' || r_c03_w.nm_prestador ||
										pls_util_pck.enter_w, 1, 10000);
			ds_ultimo_registro_w := ds_registro_atual_w;
		end if;
	end loop;

	-- se os ultimos partics sao iguais grava na observacao

	if (qt_partic_igual_w > 1) then
		ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
	end if;

	-- se tiver observacao significa que deve lancar ocorrencia

	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then

		dados_tb_selecao_w.ie_valido(nr_indice_w) := 'S';
		dados_tb_selecao_w.nr_seq_selecao(nr_indice_w) := r_c01_w.nr_seq_selecao;
		dados_tb_selecao_w.ds_seqs_selecao(nr_indice_w) := null;
		dados_tb_selecao_w.ds_observacao(nr_indice_w) := substr(ds_observacao_w, 1, 2000);

		if (nr_indice_w >= pls_util_pck.qt_registro_transacao_w) then
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao,
									dados_tb_selecao_w.ds_seqs_selecao,
									'SEQ',
									dados_tb_selecao_w.ds_observacao,
									dados_tb_selecao_w.ie_valido,
									nm_usuario_p);
			dados_tb_selecao_w.nr_seq_selecao.delete;
			dados_tb_selecao_w.ds_seqs_selecao.delete;
			dados_tb_selecao_w.ie_valido.delete;
			dados_tb_selecao_w.ds_observacao.delete;
			nr_indice_w := 0;
		else
			nr_indice_w := nr_indice_w + 1;
		end if;
	end if;
end loop;

-- se sobrou algo para atualizar manda para o banco

CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao,
						dados_tb_selecao_w.ds_seqs_selecao,
						'SEQ',
						dados_tb_selecao_w.ds_observacao,
						dados_tb_selecao_w.ie_valido,
						nm_usuario_p);
dados_tb_selecao_w.nr_seq_selecao.delete;
dados_tb_selecao_w.ds_seqs_selecao.delete;
dados_tb_selecao_w.ie_valido.delete;
dados_tb_selecao_w.ds_observacao.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_partic_pck.partic_duplicado_proc_imp ( nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type, dados_val_partic_p pls_tipos_ocor_pck.dados_val_partic) FROM PUBLIC;
