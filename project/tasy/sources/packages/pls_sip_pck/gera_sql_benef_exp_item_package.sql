-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_sip_pck.gera_sql_benef_exp_item ( ie_tipo_contratacao_in_sip_p text, cd_classificacao_p sip_item_assistencial.cd_classificacao%type, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Monta um sql que retorna os beneficiarios encontrados por contratacao e classificacao
	no SIP.
	
	Essa informacoa vai depender do conteudo da tabela w_sip_benef_exposto, portanto deve
	ser utilizada apenas nas rotinas pertinentes a exposicao do beneficiario.
		
	Atualmente nao e persistido a relacao entre benef exposto e item assistencial,
	e essa informacao pode vir a ser utilizada mais de uma vez, por isto a criacao desta
	rotina. 
	
	Pode-se usar este sql como base para um "from", evitando duplicar codigo, principalmente
	pelo fato de que alguns filtros sao dinamicos, por exemplo, a idade, onde dependendo
	da classificacao do item assistencial, ela sera diferente.

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
		

ds_retorno_w	varchar(32000);


-- Dados para os filtros dinamicos

qt_idade_inicial_w	sip_nv_dados.qt_idade%type;
qt_idade_final_w	sip_nv_dados.qt_idade%type;
ie_sexo_benef_w		sip_nv_dados.ie_sexo%type;


BEGIN

ds_retorno_w	:= ds_retorno_w ||	'select	z.nr_sequencia, ' || pls_util_pck.enter_w ||
					'	z.nr_seq_segurado, ' || pls_util_pck.enter_w ||
					'	z.ie_segmentacao, ' || pls_util_pck.enter_w ||
					'	z.nr_seq_contrato, ' || pls_util_pck.enter_w ||
					'	z.nr_seq_plano, ' || pls_util_pck.enter_w ||
					'	z.ie_sexo, ' || pls_util_pck.enter_w ||
					'	z.ie_tipo_contratacao, ' || pls_util_pck.enter_w ||
					'	z.dt_contratacao, ' || pls_util_pck.enter_w ||
					'	z.dt_rescisao, ' || pls_util_pck.enter_w ||
					'	z.ie_nivel_carencia ' || pls_util_pck.enter_w ||
					'from	w_sip_benef_exposto	z ' || pls_util_pck.enter_w ||
					'where	z.ie_tipo_contratacao	in ('||ie_tipo_contratacao_in_sip_p||') ' || pls_util_pck.enter_w;
			
-- Levanta os dados dos filtros adicionais

ie_sexo_benef_w		:= null;
qt_idade_inicial_w	:= null;
qt_idade_final_w	:= null;
	
-- regra de filtro FIXA, conforme regra de negocio propria do SIP.

if (cd_classificacao_p = 'EX4.1') then

	qt_idade_inicial_w	:= 0;
	qt_idade_final_w	:= 5;
	
elsif (cd_classificacao_p = 'EX2.4') then

	qt_idade_inicial_w	:= 60;
	qt_idade_final_w	:= 999;
	
elsif (cd_classificacao_p = 'C3') then

	ie_sexo_benef_w := 'F';
	qt_idade_inicial_w	:= 25;
	qt_idade_final_w	:= 59;
	
elsif (cd_classificacao_p = 'C10.1') then

	ie_sexo_benef_w := 'F';
	qt_idade_inicial_w	:= 50;
	qt_idade_final_w	:= 69;
	
elsif (cd_classificacao_p = 'C14') then

	qt_idade_inicial_w	:= 50;
	qt_idade_final_w	:= 69;
	
elsif (cd_classificacao_p in ('I3.3', 'I5', 'I8')) then

	qt_idade_inicial_w	:= 0;
	qt_idade_final_w	:= 11;
	
elsif (cd_classificacao_p in ('I4', 'I6', 'I7', 'I9')) then

	qt_idade_inicial_w	:= 12;
	qt_idade_final_w	:= 999;
	
end if;


if	(qt_idade_inicial_w IS NOT NULL AND qt_idade_inicial_w::text <> '' AND qt_idade_final_w IS NOT NULL AND qt_idade_final_w::text <> '') then

	ds_retorno_w := ds_retorno_w || ' and z.qt_idade between :qt_idade_inicial and :qt_idade_final ' || pls_util_pck.enter_w;
	
	dados_bind_p := sql_pck.bind_variable(':qt_idade_inicial', qt_idade_inicial_w, dados_bind_p);
	dados_bind_p := sql_pck.bind_variable(':qt_idade_final', qt_idade_final_w, dados_bind_p);
end if;

if (ie_sexo_benef_w IS NOT NULL AND ie_sexo_benef_w::text <> '') then

	ds_retorno_w := ds_retorno_w || ' and z.ie_sexo = :ie_sexo ' || pls_util_pck.enter_w;
	
	dados_bind_p := sql_pck.bind_variable(':ie_sexo', ie_sexo_benef_w, dados_bind_p);
	
end if;



return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_sip_pck.gera_sql_benef_exp_item ( ie_tipo_contratacao_in_sip_p text, cd_classificacao_p sip_item_assistencial.cd_classificacao%type, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;