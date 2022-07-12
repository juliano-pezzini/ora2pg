-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_dados_atuariais_pck.monta_mascara_sql_campo_arq ( ie_campo_p pls_atuarial_arq_campo.ie_campo%type, ds_sql_p text, ds_mascara_p pls_atuarial_arq_campo.ds_mascara%type, ie_tipo_arquivo_p pls_atuarial_arq_regra.ie_tipo_arquivo%type) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Verifica o tipo do campo e retorna a mascara propriamente dita
		
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	A montagem da mascara sera feita utilizando as rotinas ja disponibilizadas pela Oracle
	
	quando uma mascara for determinada, sera buscado o tipo do campo conforme metadata,
	se for uma coluna de tabela, ou sera considerado "varchar2" se o campo for uma function
	
	Conform e o tipo do campo, sera aplicada a  mascara, por exemplo se o campo for uma 
	coluna data ou numero, entao aplicado o TO_CHAR.
	
	um exemplo para converter um numero em 2 casas decimais, com separador de milhar conforme
	territorio configurado no banco, e separador de decimais como ",":
	'999G999G999D99MI', 'NLS_NUMERIC_CHARACTERS = '',.'' NLS_CURRENCY = ''territory'' '
	
	DEVE-SE MANTER OS APOSTROFOS, pois essa mascara sera concatenada de forma pura.
	
	Um exemplo para fazer uma data ficar no formado ano mes dia: 'yyyyMMdd'.
	
	
	Os campos que forem VARCHAR2 ou FUNCTION, terao o tratamento baseado em expressoes regulares.
	
	um exemplo para formatar um CNPJ: 
	'([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{4})([0-9]{2})','\1.\2.\3/\4-\5'
	
	um exemplo para formatar um CPF:
	'([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})','\1.\2.\3-\4'
	
	DEVE-SE MANTER OS APOSTROFOS, pois essa mascara sera concatenada de forma pura.
	
	Apos aplicar a mascara, os campos receberao um TRIM, para evitar "poluicao" por conta da mascara em si,
	se os espacos em branco forem necessarios, utilizar a configuracao para preenchimento e tamanho
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_retorno_w		varchar(32000) := '';
ie_tipo_campo_w		varchar(1000) := '';


BEGIN

-- Busca o tipo do campo

ie_tipo_campo_w :=  pls_dados_atuariais_pck.retorna_tipo_col_regra(ie_campo_p, ie_tipo_arquivo_p);

if (ie_tipo_campo_w = 'VARCHAR2') then

	ds_retorno_w := 'regexp_replace('||ds_sql_p||','||ds_mascara_p||')';
	
elsif (ie_tipo_campo_w in ('NUMBER', 'DATE')) then

	ds_retorno_w := 'to_char('||ds_sql_p||','||ds_mascara_p||')';
	
end if;

-- Por ultimo, se possui coluna de retorno, entao e aplicado um TRIM

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then

	ds_retorno_w := 'trim('||ds_retorno_w||')';
	
end if;

return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_dados_atuariais_pck.monta_mascara_sql_campo_arq ( ie_campo_p pls_atuarial_arq_campo.ie_campo%type, ds_sql_p text, ds_mascara_p pls_atuarial_arq_campo.ds_mascara%type, ie_tipo_arquivo_p pls_atuarial_arq_regra.ie_tipo_arquivo%type) FROM PUBLIC;
