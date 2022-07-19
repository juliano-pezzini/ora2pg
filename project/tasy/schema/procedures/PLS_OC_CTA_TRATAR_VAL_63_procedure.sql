-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_63 (( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) is /* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Aplicar a validacao 63 - Validar apresentacao de contas enquanto beneficiario internado
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

jjung - OS 707203 - 23/04/2014 - Criacao da rotina.
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 tb_seq_w dbms_sql.number_table) RETURNS varchar AS $body$
DECLARE

/*
Finalidade:	Montar o acesso de pesquisa a conta de internacao quando o beneficiario estiver internado.
*/
ds_rest_conta_w	varchar(1000);
BEGIN

-- Sempre serao verificadas apenas contas do mesmo beneficiario e sempre desconsidera a mesma conta.
ds_rest_conta_w	:= 	' and	x.nr_seq_segurado = conta.nr_seq_segurado ' || pls_util_pck.enter_w ||
			' and	x.nr_sequencia <> conta.nr_sequencia ' || pls_util_pck.enter_w ||
			' and 	x.ie_status not in (''C'') ';

-- Verificar se estamos buscando as guias de internacao ou os demais atendimentos.
if (ie_momento_p = 'INTER') then

	ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
				' and x.ie_tipo_guia = ''5'' ';

	-- Sempre que for buscar as internacoes sera visto se a conta sendo consistida foi realizada dentro do periodo da internacao.
	if (dados_regra_p.ie_evento = 'IMP') then

		if (ie_considera_horario_p = 'N') then
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_entrada_trunc <= conta.dt_atendimento_imp_dd ' || pls_util_pck.enter_w ||
						' and	(x.dt_alta_trunc is null or x.dt_alta_trunc >= conta.dt_atendimento_imp_dd) ';
		else
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_entrada <= conta.dt_atendimento_imp ' || pls_util_pck.enter_w ||
						' and	(x.dt_alta is null or x.dt_alta >= conta.dt_atendimento_imp) ';
		end if;


	else
		if (ie_considera_horario_p = 'N') then
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_entrada_trunc <= conta.dt_atendimento_dd ' || pls_util_pck.enter_w ||
						' and	(x.dt_alta_trunc is null or x.dt_alta_trunc >= conta.dt_atendimento_dd) ';
		else
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_entrada <= conta.dt_atendimento ' || pls_util_pck.enter_w ||
						' and	(x.dt_alta is null or x.dt_alta >= conta.dt_atendimento) ';
		end if;
	end if;

else
	/*A restricao abaixo sera comentada para que as internacoes possam ser confrontadas com outras contas de internacao
        ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
				' and (x.ie_tipo_guia <> ''5'' and x.cd_tiss_atendimento <> ''7'') ';*/


	-- Sempre que for buscar o que nao for internacao entao verifica se o atendimento foi realizado no periodo da internacao sendo consistida.
	if (dados_regra_p.ie_evento = 'IMP') then

		if (ie_considera_horario_p = 'N') then
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_atendimento_dd between conta.dt_entrada_imp_trunc and nvl(conta.dt_alta_imp_trunc, x.dt_atendimento_dd) ';
		else
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_atendimento between conta.dt_entrada_imp and nvl(conta.dt_alta_imp, x.dt_atendimento) ';
		end if;
	else
		if (ie_considera_horario_p = 'N') then
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_atendimento_dd between conta.dt_entrada_trunc and nvl(conta.dt_alta_trunc, x.dt_atendimento_dd) ';
		else
			ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
						' and	x.dt_atendimento between conta.dt_entrada and nvl(conta.dt_alta, x.dt_atendimento) ';
		end if;
	end if;

end if;

-- Valida apenas contas com mesmo numero de guia
if (ie_numero_guia_p = 'M') then

	ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
				' and	x.cd_guia_referencia = conta.cd_guia_referencia ';

-- Valida apenas contas com numero de guia diferente
elsif (ie_numero_guia_p = 'D') then

	ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
				' and	x.cd_guia_referencia <> conta.cd_guia_referencia ' || pls_util_pck.enter_w ||
				' and	nvl(x.nr_seq_guia,0) <> nvl(conta.nr_seq_guia,0) ';
end if;

if (ie_considera_cta_glosada_p = 'N') then
	ds_rest_conta_w := ds_rest_conta_w || pls_util_pck.enter_w ||
	' and	x.ie_glosa = ''N'' ';
end if;

return ds_rest_conta_w;

end;


function obter_restricao_inter_auto(	dados_regra_p		pls_tipos_ocor_pck.dados_regra,
					ie_numero_guia_p	pls_oc_cta_val_cta_per_int.ie_numero_guia%type,
					ie_considera_horario_p	pls_oc_cta_val_cta_per_int.ie_considera_horario%type)	return varchar2 is
/*
Finalidade:	Montar o acesso de pesquisa a guia de autorizacao de internacao quando o beneficiario estiver internado.
*/
ds_rest_conta_w	varchar2(1000);
begin
ds_rest_conta_w	:= 	' and	x.nr_seq_segurado = conta.nr_seq_segurado ' || pls_util_pck.enter_w ||
			' and	x.dt_cancelamento is null '|| pls_util_pck.enter_w || -- Nao considera as guias canceladas
			' and	x.ie_tipo_guia = ''1'' ' || pls_util_pck.enter_w || -- Retona apenas as guias de solicitacao de internacao
			' and	x.ie_status = ''1'' '; -- Retona apenas as guias autorizadas


-- Valida apenas contas com mesmo numero de guia
if (ie_numero_guia_p = 'M') then

	if (dados_regra_p.ie_evento = 'IMP') then

		ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
					' and	x.nr_sequencia = conta.cd_guia_referencia ';
	else
		ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
					' and	x.nr_sequencia = conta.cd_guia_referencia ';
	end if;

-- Valida apenas contas com numero de guia diferente
elsif (ie_numero_guia_p = 'D') then

	if (dados_regra_p.ie_evento = 'IMP') then

		ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
					' and	x.nr_sequencia <> conta.cd_guia_referencia ' || pls_util_pck.enter_w ||
					' and	nvl(x.nr_sequencia,0) <> nvl(conta.nr_seq_guia,0) ';
	else

		ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
					' and	x.nr_sequencia <> conta.cd_guia_referencia ' || pls_util_pck.enter_w ||
					' and	nvl(x.nr_sequencia,0) <> nvl(conta.nr_seq_guia,0) ';
	end if;

end if;

-- Sempre que for buscar as autorizacoes de internacoes sera visto se a conta sendo consistida foi realizada dentro do periodo da internacao.

-- caso a data de alta da autorizacao nao estiver preenchida, sera considerado o dia de internacao somada com as diarias autorizadas

-- e necessario ainda considerar as diarias acumuladas de todas as possiveis guias de solicitacao de prorrogacao de internacao
if (ie_considera_horario_p = 'N') then
	ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
				' and	trunc(y.dt_internacao,''dd'') <= trunc(a.dt_atendimento_referencia,''dd'') ' || pls_util_pck.enter_w ||
				' and	(nvl(trunc(y.dt_alta,''dd''),  trunc(y.dt_internacao,''dd'') + nvl(x.qt_dia_autorizado,1) + nvl(( ' || pls_util_pck.enter_w ||
				'												select	sum(nvl(z.qt_dia_autorizado,1)) ' || pls_util_pck.enter_w ||
				'												from	pls_guia_plano		z ' || pls_util_pck.enter_w ||
				'												where	z.nr_seq_guia_principal	= x.nr_sequencia ' || pls_util_pck.enter_w ||
				'												and	z.dt_cancelamento is null '|| pls_util_pck.enter_w || -- Nao considera as guias canceladas
				'												and	z.ie_tipo_guia = ''8'' ' || pls_util_pck.enter_w ||  -- Retona apenas as guias de solicitacao de prorrogacao de internacao
				'												and	z.ie_status = ''1'' ), 0)' || pls_util_pck.enter_w ||  -- Retona apenas as guias autorizadas
				') >= trunc(a.dt_atendimento_referencia,''dd'')) ';
else
	ds_rest_conta_w :=	ds_rest_conta_w || pls_util_pck.enter_w ||
				' and	y.dt_internacao <= a.dt_atendimento_referencia ' || pls_util_pck.enter_w ||
				' and	(nvl(y.dt_alta,  y.dt_internacao + nvl(x.qt_dia_autorizado,1) + nvl((	select	sum(nvl(z.qt_dia_autorizado,1)) ' || pls_util_pck.enter_w ||
				'										from	pls_guia_plano		z ' || pls_util_pck.enter_w ||
				'										where	z.nr_seq_guia_principal	= x.nr_sequencia ' || pls_util_pck.enter_w ||
				'										and	z.dt_cancelamento is null '|| pls_util_pck.enter_w || -- Nao considera as guias canceladas
				'										and	z.ie_tipo_guia = ''8'' ' || pls_util_pck.enter_w ||  -- Retona apenas as guias de solicitacao de prorrogacao de internacao
				'										and	z.ie_status = ''1'' ), 0)' || pls_util_pck.enter_w ||  -- Retona apenas as guias autorizadas
				') >= a.dt_atendimento_referencia) ';
end if;

return ds_rest_conta_w;

end;


begin
-- Verificar se a regra informada e valida.
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- Percorrer as regra cadastradas para a validacao.
	for	r_C01_w in C01(dados_regra_p) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

		begin
			-- Primeiro vai atras do que nao e internacao e esta sendo consistido para veriricar se tinha outra conta no periodo.
			ds_rest_conta_w := obter_restricao_internacao('INTER', dados_regra_p, r_C01_w.ie_numero_guia, r_C01_w.ie_considera_horario, r_C01_w.ie_considera_cta_glosada );

			ds_sql_w	:= 	'select ''S'' ie_valido, ' || pls_util_pck.enter_w ||
						'	''O beneficiario estava internado no periodo informado.'' || chr(13) || chr(10) || ' || pls_util_pck.enter_w ||
						'	''Conta internacao: '' || ' || pls_util_pck.enter_w ||
						'	(select	min(x.nr_sequencia) ' || pls_util_pck.enter_w ||
						'	from	pls_conta_v x ' || pls_util_pck.enter_w ||
						'	where	1 = 1 ' || pls_util_pck.enter_w ||
						ds_rest_conta_w || pls_util_pck.enter_w ||
						'	) ds_observacao, ' || pls_util_pck.enter_w ||
						'	pls_tipos_ocor_pck.obter_sequencia_selecao( ' || pls_util_pck.enter_w ||
						'	null, null, conta.nr_sequencia, :nr_id_transacao, ''N'', null, :ie_excecao, ''V'') seqs ' || pls_util_pck.enter_w ||
						'from	pls_oc_cta_selecao_ocor_v sel, ' || pls_util_pck.enter_w ||
						'	pls_conta_ocor_v conta ' || pls_util_pck.enter_w ||
						'where	sel.nr_id_transacao = :nr_id_transacao ' || pls_util_pck.enter_w ||
						'and	sel.ie_valido = ''S'' ' || pls_util_pck.enter_w ||
						'and	conta.nr_sequencia = sel.nr_seq_conta ' || pls_util_pck.enter_w ||
						-- neste primeiro momento verifica tudo que nao for internacao para barrar caso o beneficiario estava internado.
						'and	conta.ie_tipo_guia <> ''5'' ' || pls_util_pck.enter_w ||
						'and	exists (select	1 ' || pls_util_pck.enter_w ||
						'		from	pls_conta_v x ' || pls_util_pck.enter_w ||
						'		where	1 = 1 ' || pls_util_pck.enter_w ||
						'	' || ds_rest_conta_w || pls_util_pck.enter_w ||
						'	) ';

			if (r_C01_w.ie_considerar_auto = 'S') then
				ds_rest_conta_w		:= obter_restricao_inter_auto(dados_regra_p, r_C01_w.ie_numero_guia, r_C01_w.ie_considera_horario);
				ds_sql_w	:= 	ds_sql_w || pls_util_pck.enter_w ||
							'union all ' || pls_util_pck.enter_w ||
							pls_util_pck.enter_w || 'select ''S'' ie_valido, ' || pls_util_pck.enter_w ||
							'	''O beneficiario estava internado no periodo informado.'' || chr(13) || chr(10) || ' || pls_util_pck.enter_w ||
							'	''Autorizacao internacao: '' || ' || pls_util_pck.enter_w ||
							'	(select	min(x.nr_sequencia) ' || pls_util_pck.enter_w ||
							'	from	pls_guia_plano x, ' || pls_util_pck.enter_w ||
							'		pls_guia_atendimento	y ' || pls_util_pck.enter_w ||
							'	where	1 = 1 ' || pls_util_pck.enter_w ||
							'		and	y.nr_seq_guia	= x.nr_sequencia ' || pls_util_pck.enter_w ||
							ds_rest_conta_w || pls_util_pck.enter_w ||
							'	) ds_observacao, ' || pls_util_pck.enter_w ||
							'	pls_tipos_ocor_pck.obter_sequencia_selecao( ' || pls_util_pck.enter_w ||
							'	null, null, conta.nr_sequencia, '||to_char(nr_id_transacao_p)||', ''N'', null, '''||dados_regra_p.ie_excecao||''', ''V'') seqs ' || pls_util_pck.enter_w ||
							'from	pls_oc_cta_selecao_ocor_v	sel, ' || pls_util_pck.enter_w ||
							'	pls_conta_ocor_v		conta, ' || pls_util_pck.enter_w ||
							'	pls_conta			a '|| pls_util_pck.enter_w ||
							'where	sel.nr_id_transacao = '||to_char(nr_id_transacao_p)||' ' || pls_util_pck.enter_w ||
							'and	sel.ie_valido = ''S'' ' || pls_util_pck.enter_w ||
							'and	conta.nr_sequencia = sel.nr_seq_conta ' || pls_util_pck.enter_w ||
							'and	a.nr_sequencia = conta.nr_sequencia ' || pls_util_pck.enter_w ||
							-- neste primeiro momento verifica tudo que nao for internacao para barrar caso o beneficiario estava internado.
							'and	conta.ie_tipo_guia <> ''5'' ' || pls_util_pck.enter_w ||
							'and	exists (select	1 ' || pls_util_pck.enter_w ||
							'		from	pls_guia_plano 		x, ' || pls_util_pck.enter_w ||
							'			pls_guia_atendimento	y ' || pls_util_pck.enter_w ||
							'		where	1 = 1 ' || pls_util_pck.enter_w ||
							'		and	y.nr_seq_guia	= x.nr_sequencia ' || pls_util_pck.enter_w ||
							'	' || ds_rest_conta_w || pls_util_pck.enter_w ||
							'	) ';

			end if;
			
			open	cd_cursor_w for EXECUTE ds_sql_w
			using	nr_id_transacao_p, dados_regra_p.ie_excecao, nr_id_transacao_p;
			loop
				fetch cd_cursor_w
				bulk collect into tb_valido_w, tb_observacao_w, tb_seqs_selecao_w
				limit pls_cta_consistir_pck.qt_registro_transacao_w;

				exit when tb_seqs_selecao_w.count = 0;

				-- Sera passado uma lista com todas a sequencias da selecao para a conta e para seus itens, estas sequencias serao atualizadas com os mesmos dados da conta,

				-- conforme passado por parametro,
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_w, tb_seqs_selecao_w,
										'LISTA', tb_observacao_w, tb_valido_w,
										nm_usuario_p);
			end loop;
			close cd_cursor_w;


			-- Agora vai atras das contas de internacao que estao sendo consistidas para gerar a ocorrencia.
			ds_rest_conta_w := obter_restricao_internacao('OUTROS', dados_regra_p, r_C01_w.ie_numero_guia, r_C01_w.ie_considera_horario, r_C01_w.ie_considera_cta_glosada);

			ds_sql_w	:= 	'select ''S'' ie_valido, ' || pls_util_pck.enter_w ||
						'	''O beneficiario pode ter realizado outro atendimento durante o periodo em que estava internado.'' || chr(13) || chr(10) || ' || pls_util_pck.enter_w ||
						'	''Conta : '' || ' || pls_util_pck.enter_w ||
						'	(select	min(x.nr_sequencia) ' || pls_util_pck.enter_w ||
						'	from	pls_conta_v x ' || pls_util_pck.enter_w ||
						'	where	1 = 1 ' || pls_util_pck.enter_w ||
						ds_rest_conta_w || pls_util_pck.enter_w ||
						'	) ds_observacao, ' || pls_util_pck.enter_w ||
						'	pls_tipos_ocor_pck.obter_sequencia_selecao( ' || pls_util_pck.enter_w ||
						'	null, null, conta.nr_sequencia, :nr_id_transacao, ''N'', null, :ie_excecao, ''V'') seqs ' || pls_util_pck.enter_w ||
						'from	pls_oc_cta_selecao_ocor_v sel, ' || pls_util_pck.enter_w ||
						'	pls_conta_ocor_v conta ' || pls_util_pck.enter_w ||
						'where	sel.nr_id_transacao = :nr_id_transacao ' || pls_util_pck.enter_w ||
						'and	sel.ie_valido = ''S'' ' || pls_util_pck.enter_w ||
						'and	conta.nr_sequencia = sel.nr_seq_conta ' || pls_util_pck.enter_w ||
						-- neste momento verifica tudo que for internacao para que nao seja possivel apresentar contas de internacao caso

						-- o beneficiario tiver outra conta neste periodo.
						'and	conta.ie_tipo_guia = ''5'' ' || pls_util_pck.enter_w ||
						'and	exists (select	1 ' || pls_util_pck.enter_w ||
						'		from	pls_conta_v x ' || pls_util_pck.enter_w ||
						'		where	1 = 1 ' || pls_util_pck.enter_w ||
						'	' || ds_rest_conta_w || pls_util_pck.enter_w ||
						'	) ';

			open	cd_cursor_w for EXECUTE ds_sql_w
			using	nr_id_transacao_p, dados_regra_p.ie_excecao, nr_id_transacao_p;
			loop
				fetch cd_cursor_w
				bulk collect into tb_valido_w, tb_observacao_w, tb_seqs_selecao_w
				limit pls_cta_consistir_pck.qt_registro_transacao_w;

				exit when tb_seqs_selecao_w.count = 0;

				-- Sera passado uma lista com todas a sequencias da selecao para a conta e para seus itens, estas sequencias serao atualizadas com os mesmos dados da conta,

				-- conforme passado por parametro,
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_w, tb_seqs_selecao_w,
										'LISTA', tb_observacao_w, tb_valido_w,
										nm_usuario_p);
			end loop;
			close cd_cursor_w;

		exception
		when others then

			-- Verifica se o cursor ainda esta aberto para fecha-lo.
			if (cd_cursor_w%isopen) then

				close cd_cursor_w;
			end if;

			-- E gravar o log de erro.
			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p, ds_sql_w, nr_id_transacao_p, nm_usuario_p);
		end;
	end loop; -- C01

	-- seta os registros que serao validos ou invalidos apos o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_63 (( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) is  tb_seq_w dbms_sql.number_table) FROM PUBLIC;

