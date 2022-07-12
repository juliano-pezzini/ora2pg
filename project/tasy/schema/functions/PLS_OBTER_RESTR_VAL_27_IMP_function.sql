-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_restr_val_27_imp ( dados_segurado_p pls_ocor_imp_pck.dados_benef, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, dados_limitacao_p pls_ocor_imp_pck.dados_limitacao, ie_proc_mat_p text, dados_proc_limitacao_p pls_ocor_imp_pck.t_pls_limitacao_proc_row, dados_mat_limitacao_p pls_ocor_imp_pck.t_pls_limitacao_mat_row, ie_restricao_p text, dado_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


dados_retorno_w		pls_ocor_imp_pck.dados_restricao_select;


BEGIN

dados_retorno_w.qt_restricao := 0;

if (ie_restricao_p = 'IMP') then
	-- sempre deve se ter a informação do segurado para chamar esta function, pois se não irá pegar todas as contas, o que ocasionará transtornos e lentidão e o resultado do select não será
	-- válido. Portanto deve se olhar se existe informação do segurado fora daqui.
	if (dados_limitacao_p.ie_tipo_incidencia IS NOT NULL AND dados_limitacao_p.ie_tipo_incidencia::text <> '') then

		-- Verificar se a limitação se aplica por beneficiário ou pelos seus dependentes legais.
		-- Se for apenas por beneficiário devem ser consideradas as contas daquele beneficiário.
		if (dados_limitacao_p.ie_tipo_incidencia = 'B') then

			dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
								'and	conta.nr_seq_segurado_conv = :nr_seq_segurado_imp ';
			dado_bind_p := sql_pck.bind_variable(':nr_seq_segurado_imp', dados_segurado_p.nr_sequencia, dado_bind_p);

		-- Se for para os dependentes tabmém devem ser obidos os dependentes legais daquele beneficiário e considerar as contas dele também.
		elsif (dados_limitacao_p.ie_tipo_incidencia = 'T') then

			-- Utiliza a table function pls_util_cta_pck.obter_dependentes_benef para obter os dependentes legais do beneficiário.
			dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
							'and	conta.nr_seq_segurado_conv in (	select	depend.nr_seq_segurado ' || pls_util_pck.enter_w ||
							'					from	table(pls_util_cta_pck.obter_dependentes_benef(:nr_seq_segurado_imp, ''N'', ''S'')) depend )';
			-- Se não for um titular então informa o titular para que sejam buscados seus dependentes. Caso seja um titular então informa a própria sequencia para buscar seus dependetes.
			if (dados_segurado_p.nr_seq_titular IS NOT NULL AND dados_segurado_p.nr_seq_titular::text <> '') then

				dado_bind_p := sql_pck.bind_variable(':nr_seq_segurado_imp', dados_segurado_p.nr_seq_titular, dado_bind_p);
			else
				dado_bind_p := sql_pck.bind_variable(':nr_seq_segurado_imp', dados_segurado_p.nr_sequencia, dado_bind_p);
			end if;
		end if;

		-- Verificar o período de consistência da  regra de limitação cadastrada.
		if (dados_limitacao_p.dt_inicio_periodo IS NOT NULL AND dados_limitacao_p.dt_inicio_periodo::text <> '') and (dados_limitacao_p.dt_fim_periodo IS NOT NULL AND dados_limitacao_p.dt_fim_periodo::text <> '') then

			-- Verificar se é para procedimento ou material
			-- Procedimento
			if (ie_proc_mat_p = 'P') then

				dados_retorno_w.ds_restricao_proc :=	dados_retorno_w.ds_restricao_proc || pls_util_pck.enter_w ||
									'and	proc.dt_execucao_conv between :dt_inicio_periodo_imp and :dt_fim_periodo_imp ';
			-- Material
			elsif (ie_proc_mat_p = 'M') then

				dados_retorno_w.ds_restricao_mat :=	dados_retorno_w.ds_restricao_mat || pls_util_pck.enter_w ||
									'and	mat.dt_execucao_conv between :dt_inicio_periodo_imp and :dt_fim_periodo_imp ';
			end if;

			dado_bind_p := sql_pck.bind_variable(':dt_inicio_periodo_imp', dados_limitacao_p.dt_inicio_periodo, dado_bind_p);
			dado_bind_p := sql_pck.bind_variable(':dt_fim_periodo_imp', dados_limitacao_p.dt_fim_periodo, dado_bind_p);
		end if;

		-- Daqui para baixo serão verificados os campos referentes a procedimentos e materiais da limitação. Manter agrupado a verificação por campos e tratar sempre procedimento e material junto
		-- para que ao alterar a informação em um dos campos seja mais fácil alterar para os dois casos se necessário.
		---------------------------------------------------------- IE_TIPO_GUIA ---------------------------------------------------------------------------
		-- Verificar se é para procedimento ou material.
		-- Procedimento
		if (ie_proc_mat_p = 'P') then

			-- Se a regra da limitação informar para restringir o tipo de guia então só busca contas do tipo de guia informado.
			if (dados_proc_limitacao_p.ie_tipo_guia IS NOT NULL AND dados_proc_limitacao_p.ie_tipo_guia::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	prot.ie_tipo_guia = :ie_tipo_guia_imp';

				dado_bind_p := sql_pck.bind_variable(':ie_tipo_guia_imp', dados_proc_limitacao_p.ie_tipo_guia, dado_bind_p);
			end if;
		-- Material
		elsif (ie_proc_mat_p = 'M') then

			-- Se a regra da limitação informar para restringir o tipo de guia então só busca contas do tipo de guia informado.
			if (dados_mat_limitacao_p.ie_tipo_guia IS NOT NULL AND dados_mat_limitacao_p.ie_tipo_guia::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	prot.ie_tipo_guia = :ie_tipo_guia_imp';

				dado_bind_p := sql_pck.bind_variable(':ie_tipo_guia_imp', dados_mat_limitacao_p.ie_tipo_guia, dado_bind_p);
			end if;
		end if;

		------------------------------------------------------------------------ CD_DOENCA_CID ------------------------------------------------------------------
		-- Verificar se é para procedimento ou material.
		-- Procedimento
		if (ie_proc_mat_p = 'P') then

			-- Se a regra da limitação informar para restringir por cid então deve ser verificado apenas as contas que contenham o cid informado no diagnóstico.
			if (dados_proc_limitacao_p.cd_doenca_cid IS NOT NULL AND dados_proc_limitacao_p.cd_doenca_cid::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	exists	(	select	1 						' || pls_util_pck.enter_w ||
									'			from	pls_diagnostico_conta_imp diag 			' || pls_util_pck.enter_w ||
									'			where	diag.nr_seq_conta	= conta.nr_sequencia	' || pls_util_pck.enter_w ||
									'			and	diag.cd_doenca_conv	= :cd_cid_imp 		' || pls_util_pck.enter_w ||
									'	) ';

				dado_bind_p := sql_pck.bind_variable(':cd_cid_imp', dados_proc_limitacao_p.cd_doenca_cid, dado_bind_p);
			end if;
		-- Material
		elsif (ie_proc_mat_p = 'M') then

			-- Se a regra da limitação informar para restringir por cid então deve ser verificado apenas as contas que contenham o cid informado no diagnóstico.
			if (dados_mat_limitacao_p.cd_doenca_cid IS NOT NULL AND dados_mat_limitacao_p.cd_doenca_cid::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	exists	(	select	1 						' || pls_util_pck.enter_w ||
									'			from	pls_diagnostico_conta_imp diag 			' || pls_util_pck.enter_w ||
									'			where	diag.nr_seq_conta	= conta.nr_sequencia 	' || pls_util_pck.enter_w ||
									'			and	diag.cd_doenca_conv	= :cd_cid_imp 		' || pls_util_pck.enter_w ||
									'	) ';

				dado_bind_p := sql_pck.bind_variable(':cd_cid_imp', dados_mat_limitacao_p.cd_doenca_cid, dado_bind_p);
			end if;
		end if;

		------------------------------------------------------------- CD_PROCEDIMENTO / NR_SEQ_MATERIAL -----------------------------------------------------------
		-- Verificar se é para procedimento ou material.
		-- Procedimento
		if (ie_proc_mat_p = 'P') then

			-- Se existir o procedimento informado na estrutura então busca por procedimento e origem.
			if (dados_proc_limitacao_p.cd_procedimento IS NOT NULL AND dados_proc_limitacao_p.cd_procedimento::text <> '') then

				dados_retorno_w.ds_restricao_proc :=	dados_retorno_w.ds_restricao_proc || pls_util_pck.enter_w ||
									'and	proc.cd_procedimento_conv = :ie_origem_proced_imp ' || pls_util_pck.enter_w ||
									'and	proc.ie_origem_proced_conv = :cd_procedimento_imp ';

				dado_bind_p := sql_pck.bind_variable(':cd_procedimento_imp', dados_proc_limitacao_p.cd_procedimento, dado_bind_p);
				dado_bind_p := sql_pck.bind_variable(':ie_origem_proced_imp', dados_proc_limitacao_p.ie_origem_proced, dado_bind_p);
			end if;
		-- Material
		elsif (ie_proc_mat_p = 'M') then

			-- Se existir o material informado na estrutura então busca por material
			if (dados_mat_limitacao_p.nr_seq_material IS NOT NULL AND dados_mat_limitacao_p.nr_seq_material::text <> '') then

				dados_retorno_w.ds_restricao_mat :=	dados_retorno_w.ds_restricao_mat || pls_util_pck.enter_w ||
									'and	mat.nr_seq_material_conv = :nr_seq_material_imp ';

				dado_bind_p := sql_pck.bind_variable(':nr_seq_material_imp', dados_mat_limitacao_p.nr_seq_material, dado_bind_p);
			end if;
		end if;
	end if;
elsif (ie_restricao_p = 'N') then
	-- sempre deve se ter a informação do segurado para chamar esta function, pois se não irá pegar todas as contas, o que ocasionará transtornos e lentidão e o resultado do select não será
	-- válido. Portanto deve se olhar se existe informação do segurado fora daqui.
	if (dados_limitacao_p.ie_tipo_incidencia IS NOT NULL AND dados_limitacao_p.ie_tipo_incidencia::text <> '') then

		-- Verificar se a limitação se aplica por beneficiário ou pelos seus dependentes legais.
		-- Se for apenas por beneficiário devem ser consideradas as contas daquele beneficiário.
		if (dados_limitacao_p.ie_tipo_incidencia = 'B') then

			dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
								'and	conta.nr_seq_segurado = :nr_seq_segurado ';
			dado_bind_p := sql_pck.bind_variable(':nr_seq_segurado', dados_segurado_p.nr_sequencia, dado_bind_p);

		-- Se for para os dependentes tabmém devem ser obidos os dependentes legais daquele beneficiário e considerar as contas dele também.
		elsif (dados_limitacao_p.ie_tipo_incidencia = 'T') then

			-- Utiliza a table function pls_util_cta_pck.obter_dependentes_benef para obter os dependentes legais do beneficiário.
			dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
							'and	conta.nr_seq_segurado in (	select	depend.nr_seq_segurado ' || pls_util_pck.enter_w ||
							'					from	table(pls_util_cta_pck.obter_dependentes_benef(:nr_seq_segurado, ''N'', ''S'')) depend )';
			-- Se não for um titular então informa o titular para que sejam buscados seus dependentes. Caso seja um titular então informa a própria sequencia para buscar seus dependetes.
			if (dados_segurado_p.nr_seq_titular IS NOT NULL AND dados_segurado_p.nr_seq_titular::text <> '') then

				dado_bind_p := sql_pck.bind_variable(':nr_seq_segurado', dados_segurado_p.nr_seq_titular, dado_bind_p);
			else
				dado_bind_p := sql_pck.bind_variable(':nr_seq_segurado', dados_segurado_p.nr_sequencia, dado_bind_p);
			end if;
		end if;

		-- Verificar o período de consistência da  regra de limitação cadastrada.
		if (dados_limitacao_p.dt_inicio_periodo IS NOT NULL AND dados_limitacao_p.dt_inicio_periodo::text <> '') and (dados_limitacao_p.dt_fim_periodo IS NOT NULL AND dados_limitacao_p.dt_fim_periodo::text <> '') then

			-- Verificar se é para procedimento ou material
			-- Procedimento
			if (ie_proc_mat_p = 'P') then

				dados_retorno_w.ds_restricao_proc :=	dados_retorno_w.ds_restricao_proc || pls_util_pck.enter_w ||
									'and	proc.dt_procedimento between :dt_inicio_periodo and :dt_fim_periodo ';
			-- Material
			elsif (ie_proc_mat_p = 'M') then

				dados_retorno_w.ds_restricao_mat :=	dados_retorno_w.ds_restricao_mat || pls_util_pck.enter_w ||
									'and	mat.dt_atendimento between :dt_inicio_periodo and :dt_fim_periodo ';
			end if;

			dado_bind_p := sql_pck.bind_variable(':dt_inicio_periodo', dados_limitacao_p.dt_inicio_periodo, dado_bind_p);
			dado_bind_p := sql_pck.bind_variable(':dt_fim_periodo', dados_limitacao_p.dt_fim_periodo, dado_bind_p);
		end if;

		-- Daqui para baixo serão verificados os campos referentes a procedimentos e materiais da limitação. Manter agrupado a verificação por campos e tratar sempre procedimento e material junto
		-- para que ao alterar a informação em um dos campos seja mais fácil alterar para os dois casos se necessário.
		---------------------------------------------------------- IE_TIPO_GUIA ---------------------------------------------------------------------------
		-- Verificar se é para procedimento ou material.
		-- Procedimento
		if (ie_proc_mat_p = 'P') then

			-- Se a regra da limitação informar para restringir o tipo de guia então só busca contas do tipo de guia informado.
			if (dados_proc_limitacao_p.ie_tipo_guia IS NOT NULL AND dados_proc_limitacao_p.ie_tipo_guia::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	conta.ie_tipo_guia = :ie_tipo_guia';

				dado_bind_p := sql_pck.bind_variable(':ie_tipo_guia', dados_proc_limitacao_p.ie_tipo_guia, dado_bind_p);
			end if;
		-- Material
		elsif (ie_proc_mat_p = 'M') then

			-- Se a regra da limitação informar para restringir o tipo de guia então só busca contas do tipo de guia informado.
			if (dados_mat_limitacao_p.ie_tipo_guia IS NOT NULL AND dados_mat_limitacao_p.ie_tipo_guia::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	conta.ie_tipo_guia = :ie_tipo_guia';

				dado_bind_p := sql_pck.bind_variable(':ie_tipo_guia', dados_mat_limitacao_p.ie_tipo_guia, dado_bind_p);
			end if;
		end if;

		------------------------------------------------------------------------ CD_DOENCA_CID ------------------------------------------------------------------
		-- Verificar se é para procedimento ou material.
		-- Procedimento
		if (ie_proc_mat_p = 'P') then

			-- Se a regra da limitação informar para restringir por cid então deve ser verificado apenas as contas que contenham o cid informado no diagnóstico.
			if (dados_proc_limitacao_p.cd_doenca_cid IS NOT NULL AND dados_proc_limitacao_p.cd_doenca_cid::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	exists	(	select	1 ' || pls_util_pck.enter_w ||
									'			from	pls_diagnostico_conta	diag ' || pls_util_pck.enter_w ||
									'			where	diag.nr_seq_conta	= conta.nr_sequencia ' || pls_util_pck.enter_w ||
									'			and	diag.cd_doenca		= :cd_cid ' || pls_util_pck.enter_w ||
									'	) ';

				dado_bind_p := sql_pck.bind_variable(':cd_cid', dados_proc_limitacao_p.cd_doenca_cid, dado_bind_p);
			end if;
		-- Material
		elsif (ie_proc_mat_p = 'M') then

			-- Se a regra da limitação informar para restringir por cid então deve ser verificado apenas as contas que contenham o cid informado no diagnóstico.
			if (dados_mat_limitacao_p.cd_doenca_cid IS NOT NULL AND dados_mat_limitacao_p.cd_doenca_cid::text <> '') then

				dados_retorno_w.ds_restricao_conta := 	dados_retorno_w.ds_restricao_conta || pls_util_pck.enter_w ||
									'and	exists	(	select	1 ' || pls_util_pck.enter_w ||
									'			from	pls_diagnostico_conta	diag ' || pls_util_pck.enter_w ||
									'			where	diag.nr_seq_conta	= conta.nr_sequencia ' || pls_util_pck.enter_w ||
									'			and	diag.cd_doenca		= :cd_cid ' || pls_util_pck.enter_w ||
									'	) ';

				dado_bind_p := sql_pck.bind_variable(':cd_cid', dados_mat_limitacao_p.cd_doenca_cid, dado_bind_p);
			end if;
		end if;

		------------------------------------------------------------- CD_PROCEDIMENTO / NR_SEQ_MATERIAL -----------------------------------------------------------
		-- Verificar se é para procedimento ou material.
		-- Procedimento
		if (ie_proc_mat_p = 'P') then

			-- Se existir o procedimento informado na estrutura então busca por procedimento e origem.
			if (dados_proc_limitacao_p.cd_procedimento IS NOT NULL AND dados_proc_limitacao_p.cd_procedimento::text <> '') then

				dados_retorno_w.ds_restricao_proc :=	dados_retorno_w.ds_restricao_proc || pls_util_pck.enter_w ||
									'and	proc.ie_origem_proced = :ie_origem_proced ' || pls_util_pck.enter_w ||
									'and	proc.cd_procedimento = :cd_procedimento ';

				dado_bind_p := sql_pck.bind_variable(':cd_procedimento', dados_proc_limitacao_p.cd_procedimento, dado_bind_p);
				dado_bind_p := sql_pck.bind_variable(':ie_origem_proced', dados_proc_limitacao_p.ie_origem_proced, dado_bind_p);
			end if;
		-- Material
		elsif (ie_proc_mat_p = 'M') then

			-- Se existir o material informado na estrutura então busca por material
			if (dados_mat_limitacao_p.nr_seq_material IS NOT NULL AND dados_mat_limitacao_p.nr_seq_material::text <> '') then

				dados_retorno_w.ds_restricao_mat :=	dados_retorno_w.ds_restricao_mat || pls_util_pck.enter_w ||
									'and	mat.nr_seq_material = :nr_seq_material ';

				dado_bind_p := sql_pck.bind_variable(':nr_seq_material', dados_mat_limitacao_p.nr_seq_material, dado_bind_p);
			end if;
		end if;
	end if;
end if;

if	(not(	(coalesce(dados_retorno_w.ds_restricao_conta::text, '') = '') and (coalesce(dados_retorno_w.ds_restricao_benef::text, '') = '') and (coalesce(dados_retorno_w.ds_restricao_proc::text, '') = '') and (coalesce(dados_retorno_w.ds_restricao_mat::text, '') = ''))) then
	dados_retorno_w.qt_restricao := 1;
end if;

return;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_restr_val_27_imp ( dados_segurado_p pls_ocor_imp_pck.dados_benef, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, dados_limitacao_p pls_ocor_imp_pck.dados_limitacao, ie_proc_mat_p text, dados_proc_limitacao_p pls_ocor_imp_pck.t_pls_limitacao_proc_row, dados_mat_limitacao_p pls_ocor_imp_pck.t_pls_limitacao_mat_row, ie_restricao_p text, dado_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;

