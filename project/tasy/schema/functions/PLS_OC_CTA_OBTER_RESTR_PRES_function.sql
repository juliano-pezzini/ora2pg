-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_restr_pres (ie_opcao_p text, dados_regra_p pls_tipos_ocor_pck.dados_regra, cursor_p integer, dados_filtro_prest_p pls_tipos_ocor_pck.dados_filtro_prest, ie_incidencia_regra_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter a restrição que será usada para filtrar os dados conforme filtro cadastrado
	para a regra de ocorrência;
	Atualizar os valores da binds da restrição conforme dados informados nos fitros.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Realizar tratamento para os campos IMP quando hourver necessidade

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung OS 601441 06/06/2013 -	Trocado a view PLS_PRESTADOR_CONTA_V pela
			tabela PLS_PRESTADOR, não é necessário a view tendo
			em vista que todos os campos dela são os mesmos da tabela.
------------------------------------------------------------------------------------------------------------------
jjung OS 597795 10/06/2013 -

Alteração: 	Linhas 53 e 56 - Adicionado as funtions para obter o acesso a tabela pls_prestador.

Motivo:	Dividir o tratamento que ficaria muito grande e ilegível dentro desta function.
------------------------------------------------------------------------------------------------------------------
jjung 10/06/2013 -

Alteração: 	Restrições de especialidade médica e grupo de prestadores alterados para utilizar as
	table functions da pls_grupos_pck.

Motivo:	Facilita o tratamento e otimiza a performance.
------------------------------------------------------------------------------------------------------------------
jjung 12/06/2013 -

Alteração: 	Restrições de especialidade médica alterado para pegar direto da tabela e não ser mais
	utilizado a table function.

Motivo:	Foi identificado que a table function era desnecessária para este caso.
------------------------------------------------------------------------------------------------------------------
jjung OS 659647 - 23/10/2013  -

Alteração:	Alterado para que, em filtros em branco, não seja retornado nada,.

Motivo:	 Não é ncessário fazer o acesso a tabela PLS_PRESTADOR caso não tenha informação a filtrar
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_restricao_w		varchar(4000);
ds_select_prest_w	varchar(4000);
ds_filtro_prest_w	varchar(4000);
ds_acesso_prest_w	varchar(4000);

BEGIN

--Inicializar as variáveis.
ds_filtro_prest_w	:= null;
ds_restricao_w		:= null;

-- Montar o subselect base.
ds_select_prest_w := pls_tipos_ocor_pck.enter_w||	'and	exists ('||pls_tipos_ocor_pck.enter_w||
							'			select	1 '||pls_tipos_ocor_pck.enter_w||
							'			from	pls_prestador prest '||pls_tipos_ocor_pck.enter_w||
							'			where	1 = 1 ';
-- É obrigatório que o campo IE_TIPO_PRESTADOR esteja informado para que a regra seja verificada.
if (dados_filtro_prest_p.ie_tipo_prestador IS NOT NULL AND dados_filtro_prest_p.ie_tipo_prestador::text <> '') then

	-- Aqui verifca qual prestador da conta será utilizado, se for o prestador de pagamento então será utilizado a function específica para ele, caso contrário será utilizado uma function
	-- que engloba os outros tipos de prestador. Caso uma dessas functions não retorne nada não deve ser filtrado.
	if (dados_filtro_prest_p.ie_tipo_prestador = 'P') then

		-- Obter  o acesso a tabela pls_prestador para o prestador de pagamento.
		ds_acesso_prest_w := pls_oc_cta_obter_rest_pres_pag(dados_regra_p, dados_filtro_prest_p, ie_incidencia_regra_p);
	else
		-- obter o acesso a tabela pls_prestador através dos tipos de prestador diferente de prestador de pagamento.
		ds_acesso_prest_w := pls_oc_cta_obter_rest_pres_pad(dados_regra_p, dados_filtro_prest_p);
	end if;

	-- Neste momento já devemos ter alguma informação na restrição do prestador para saber qual prestador será utilizado na verificação e não ser feito um acesso full na PLS_PRESTADOR
	if (ds_acesso_prest_w IS NOT NULL AND ds_acesso_prest_w::text <> '') then

		-- Código do prestador
		if (dados_filtro_prest_p.cd_prestador IS NOT NULL AND dados_filtro_prest_p.cd_prestador::text <> '') then

			if (ie_opcao_p = 'RESTRICAO') then
				ds_filtro_prest_w :=	ds_filtro_prest_w|| pls_tipos_ocor_pck.enter_w ||
							'			and	prest.cd_prestador = :cd_prestador ';
			else
				dbms_sql.bind_variable(cursor_p, ':cd_prestador', dados_filtro_prest_p.cd_prestador);
			end if;
		end if;

		-- Classificação do prestador
		if (dados_filtro_prest_p.nr_seq_classificacao IS NOT NULL AND dados_filtro_prest_p.nr_seq_classificacao::text <> '') then

			if (ie_opcao_p = 'RESTRICAO') then
				ds_filtro_prest_w := 	ds_filtro_prest_w|| pls_tipos_ocor_pck.enter_w ||
							'			and	prest.nr_seq_classificacao = :nr_seq_classificacao ';
			else
				dbms_sql.bind_variable(cursor_p, ':nr_seq_classificacao', dados_filtro_prest_p.nr_seq_classificacao);
			end if;
		end if;

		-- Sequência do prestador
		if (dados_filtro_prest_p.nr_seq_prestador IS NOT NULL AND dados_filtro_prest_p.nr_seq_prestador::text <> '') then

			if (ie_opcao_p = 'RESTRICAO') then

				ds_filtro_prest_w :=	ds_filtro_prest_w|| pls_tipos_ocor_pck.enter_w ||
							'			and	prest.nr_sequencia = :nr_seq_prestador ';
			else
				dbms_sql.bind_variable(cursor_p, ':nr_seq_prestador', dados_filtro_prest_p.nr_seq_prestador);
			end if;
		end if;

		-- Tipo do prestador
		if (dados_filtro_prest_p.nr_seq_tipo_prestador IS NOT NULL AND dados_filtro_prest_p.nr_seq_tipo_prestador::text <> '') then

			if (ie_opcao_p = 'RESTRICAO') then
				ds_filtro_prest_w :=	ds_filtro_prest_w|| pls_tipos_ocor_pck.enter_w ||
							'			and	prest.nr_seq_tipo_prestador = :nr_seq_tipo_prestador ';
			else
				dbms_sql.bind_variable(cursor_p, ':nr_seq_tipo_prestador', dados_filtro_prest_p.nr_seq_tipo_prestador);
			end if;
		end if;

		-- Especialidade do prestador
		if (dados_filtro_prest_p.cd_especialidade_medica IS NOT NULL AND dados_filtro_prest_p.cd_especialidade_medica::text <> '') then

			if (ie_opcao_p = 'RESTRICAO') then
				ds_filtro_prest_w := 	ds_filtro_prest_w|| pls_tipos_ocor_pck.enter_w ||
							'			and	 exists	(	select	1 ' || pls_tipos_ocor_pck.enter_w ||
							'						from	pls_prestador_med_espec espec ' || pls_tipos_ocor_pck.enter_w ||
							'						where	espec.nr_seq_prestador = prest.nr_sequencia ' || pls_tipos_ocor_pck.enter_w ||
							'						and	espec.cd_especialidade = :cd_especialidade_medica ' || pls_tipos_ocor_pck.enter_w ||
							'						and	(((conta.dt_atendimento) >= (espec.dt_inicio_vigencia )) or (espec.dt_inicio_vigencia is null)) ' || pls_tipos_ocor_pck.enter_w ||
							'						and	(((conta.dt_atendimento) <= (espec.dt_fim_vigencia)) or (espec.dt_fim_vigencia is null)) ' || pls_tipos_ocor_pck.enter_w ||
							'					) ';
			else
				dbms_sql.bind_variable(cursor_p, ':cd_especialidade_medica', dados_filtro_prest_p.cd_especialidade_medica);
			end if;
		end if;

		-- Grupo de prestadores
		if (dados_filtro_prest_p.nr_seq_grupo_prestador IS NOT NULL AND dados_filtro_prest_p.nr_seq_grupo_prestador::text <> '') then

			if (ie_opcao_p = 'RESTRICAO') then
				ds_filtro_prest_w :=	ds_filtro_prest_w|| pls_tipos_ocor_pck.enter_w ||
							'			and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_tipos_ocor_pck.enter_w ||
							'						from	pls_grup_prest_preco_v grup_prest '|| pls_tipos_ocor_pck.enter_w ||
							'						where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_tipos_ocor_pck.enter_w ||
							'						and	grup_prest.nr_seq_prestador = prest.nr_sequencia ) ';
			else
				dbms_sql.bind_variable(cursor_p, ':nr_seq_grupo_prestador', dados_filtro_prest_p.nr_seq_grupo_prestador);
			end if;
		end if;

		if (ds_filtro_prest_w IS NOT NULL AND ds_filtro_prest_w::text <> '') then

			-- No caso dos prestadores não deve ser acicionada a restrição pois se o filtro estiver vazio então será feito um acesso full na PLS_PRESTADOR e nós não queremos isso.
			ds_restricao_w :=	ds_select_prest_w ||
						ds_acesso_prest_w ||
						ds_filtro_prest_w ||
						pls_tipos_ocor_pck.enter_w || '		)';
		end if;
	end if;
end if;

return	ds_restricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_restr_pres (ie_opcao_p text, dados_regra_p pls_tipos_ocor_pck.dados_regra, cursor_p integer, dados_filtro_prest_p pls_tipos_ocor_pck.dados_filtro_prest, ie_incidencia_regra_p text) FROM PUBLIC;
