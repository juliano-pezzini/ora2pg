-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_restr_benef (ie_opcao_p text, dados_regra_p pls_tipos_ocor_pck.dados_regra, cursor_p integer, dados_filtro_benef_p pls_tipos_ocor_pck.dados_filtro_benef) RETURNS varchar AS $body$
DECLARE


ds_restricao_w		varchar(4000);
ds_select_benef_w	varchar(4000);
ds_filtro_benef_w	varchar(4000);

BEGIN

--Inicializar as variáveis.
ds_filtro_benef_w	:= null;
ds_restricao_w		:= null;



--Sequência do segurado
if (dados_filtro_benef_p.nr_seq_segurado IS NOT NULL AND dados_filtro_benef_p.nr_seq_segurado::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w|| pls_tipos_ocor_pck.enter_w || '			and	benef.nr_sequencia = :nr_seq_segurado ';
	else
		dbms_sql.bind_variable(cursor_p, ':nr_seq_segurado', dados_filtro_benef_p.nr_seq_segurado);
	end if;
end if;
-- Código do convênio
if (dados_filtro_benef_p.cd_convenio IS NOT NULL AND dados_filtro_benef_p.cd_convenio::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w|| pls_tipos_ocor_pck.enter_w || '			and	benef.cd_convenio = :cd_convenio ';
	else
		dbms_sql.bind_variable(cursor_p, ':cd_convenio', dados_filtro_benef_p.cd_convenio);
	end if;
end if;
-- Local de cadastro do beneificário
if (dados_filtro_benef_p.ie_local_cadastro IS NOT NULL AND dados_filtro_benef_p.ie_local_cadastro::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w|| pls_tipos_ocor_pck.enter_w || '			and	benef.ie_local_cadastro = :ie_local_cadastro ';
	else
		dbms_sql.bind_variable(cursor_p, ':ie_local_cadastro', dados_filtro_benef_p.ie_local_cadastro);
	end if;
end if;
-- Tipo de beneficiário
if (dados_filtro_benef_p.ie_tipo_segurado IS NOT NULL AND dados_filtro_benef_p.ie_tipo_segurado::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w || pls_tipos_ocor_pck.enter_w || '			and	benef.ie_tipo_segurado = :ie_tipo_segurado ';
	else
		dbms_sql.bind_variable(cursor_p, ':ie_tipo_segurado',dados_filtro_benef_p.ie_tipo_segurado);
	end if;
end if;
-- Categoria de convênio
if (dados_filtro_benef_p.cd_categoria IS NOT NULL AND dados_filtro_benef_p.cd_categoria::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w|| pls_tipos_ocor_pck.enter_w || '			and	benef.cd_categoria = :cd_categoria ';
	else
		dbms_sql.bind_variable(cursor_p, ':cd_categoria', dados_filtro_benef_p.cd_categoria);
	end if;
end if;
-- Idade mínima
if (dados_filtro_benef_p.qt_idade_min IS NOT NULL AND dados_filtro_benef_p.qt_idade_min::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then

		-- Unidade de tempo da idade
		if (dados_filtro_benef_p.ie_unid_tempo_idade = 'A' or coalesce(dados_filtro_benef_p.ie_unid_tempo_idade::text, '') = '') then
			ds_filtro_benef_w := ds_filtro_benef_w|| '			and	benef.qt_idade_conta_anos > :qt_idade_min'|| pls_tipos_ocor_pck.enter_w;
		elsif (dados_filtro_benef_p.ie_unid_tempo_idade = 'M') then
			ds_filtro_benef_w := ds_filtro_benef_w|| '			and	benef.qt_idade_conta_meses > :qt_idade_min'|| pls_tipos_ocor_pck.enter_w;
		end if;
	else
		dbms_sql.bind_variable(cursor_p, ':qt_idade_min', dados_filtro_benef_p.qt_idade_min);
	end if;
end if;
-- Idade Maxima
if (dados_filtro_benef_p.qt_idade_max IS NOT NULL AND dados_filtro_benef_p.qt_idade_max::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then

		-- Unidade de tempo da idade
		if (dados_filtro_benef_p.ie_unid_tempo_idade = 'A' or coalesce(dados_filtro_benef_p.ie_unid_tempo_idade::text, '') = '') then
			ds_filtro_benef_w := ds_filtro_benef_w|| '			and	benef.qt_idade_conta_anos < :qt_idade_max'|| pls_tipos_ocor_pck.enter_w;
		elsif (dados_filtro_benef_p.ie_unid_tempo_idade = 'M') then
			ds_filtro_benef_w := ds_filtro_benef_w|| '			and	benef.qt_idade_conta_meses < :qt_idade_max'|| pls_tipos_ocor_pck.enter_w;
		end if;
	else
		dbms_sql.bind_variable(cursor_p, ':qt_idade_max', dados_filtro_benef_p.qt_idade_max);
	end if;
end if;
-- Sexo do beneficiário
if (dados_filtro_benef_p.ie_sexo IS NOT NULL AND dados_filtro_benef_p.ie_sexo::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w|| '			and	benef.ie_sexo = :ie_sexo '|| pls_tipos_ocor_pck.enter_w;
	else
		dbms_sql.bind_variable(cursor_p, ':ie_sexo', dados_filtro_benef_p.ie_sexo);
	end if;
end if;
-- PCMSO
if (dados_filtro_benef_p.ie_pcmso = 'S') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w|| '			and	benef.ie_pcmso = :ie_pcmso '|| pls_tipos_ocor_pck.enter_w;
	else
			dbms_sql.bind_variable(cursor_p, ':ie_pcmso', dados_filtro_benef_p.ie_pcmso);
	end if;
end if;

if (ds_filtro_benef_w IS NOT NULL AND ds_filtro_benef_w::text <> '') then

	-- Montar o subselect base.
	ds_select_benef_w := pls_tipos_ocor_pck.enter_w||	'and	exists ('||pls_tipos_ocor_pck.enter_w||
					'			select	1 '||pls_tipos_ocor_pck.enter_w||
					'			from	pls_segurado_conta_ocor_v benef '||pls_tipos_ocor_pck.enter_w||
					'			where	benef.nr_sequencia = conta.nr_seq_segurado ' ||pls_tipos_ocor_pck.enter_w||
					'			and	benef.nr_seq_conta = conta.nr_sequencia ';

	ds_select_benef_w := ds_select_benef_w || pls_tipos_ocor_pck.enter_w || ds_filtro_benef_w ||'		)';
end if;

ds_restricao_w := ds_select_benef_w;

return	ds_restricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_restr_benef (ie_opcao_p text, dados_regra_p pls_tipos_ocor_pck.dados_regra, cursor_p integer, dados_filtro_benef_p pls_tipos_ocor_pck.dados_filtro_benef) FROM PUBLIC;
