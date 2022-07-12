-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacoes_relatorio (ie_opcao_p text, ie_valor_p text,nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(255);

ds_banda_w 		banda_relatorio.ds_banda%type;
qt_altura_banda_w 	banda_relatorio.qt_altura%type;
ds_expressao_banda_w 	banda_relatorio.ds_expressao%type;
ie_tipo_banda_w 	banda_relatorio.ie_tipo_banda%type;

ds_mascara_w		banda_relat_campo.ds_mascara%type;
nm_atributo_w		banda_relat_campo.nm_atributo%type;
ie_ajustar_tamanho_w	banda_relat_campo.ie_ajustar_tamanho%type;
ie_estender_w		banda_relat_campo.ie_estender%type;
qt_tamanho_w		banda_relat_campo.qt_tamanho%type;
ds_estilo_fonte_w	banda_relat_campo.ds_estilo_fonte%type;
ds_sql_w		banda_relat_campo.ds_sql%type;
qt_altura_w		banda_relat_campo.qt_altura%type;
qt_topo_w		banda_relat_campo.qt_topo%type;
qt_tam_fonte_w		banda_relat_campo.qt_tam_fonte%type;
ds_label_w		banda_relat_campo.ds_label%type;
qt_esquerda_w		banda_relat_campo.qt_esquerda%type;
ds_campo_w 		banda_relat_campo.ds_campo%type;



BEGIN

/*
ie_opcao_p:

BANDA
	ie_valor_p
	DESCRICAO = Descrição da banda
	ALTURA
	EXPRESSAO
	TIPO

CAM PO
	ie_valor_p
	DESCRICAO = Descrição do campo
	ALTURA
	MASCARA
	ATRIBUTO
	AJUSTAR_TAMANHO
	ESTENDER
	TAMANHO
	ESTILO_FONTE
	SQL
	TOPO
	TAM_FONTE
	LABEL
	ESQUERDA
*/
if (upper(ie_opcao_p) = 'BANDA') then

	select	max(ds_banda),
		max(qt_altura),
		max(ds_expressao),
		max(ie_tipo_banda)
	into STRICT	ds_banda_w,
		qt_altura_banda_w,
		ds_expressao_banda_w,
		ie_tipo_banda_w
	from	banda_relatorio
	where	nr_sequencia = nr_sequencia_p;

	if (upper(ie_valor_p) = 'DESCRICAO') then

		ds_retorno_w := ds_banda_w;

	elsif (upper(ie_valor_p) = 'ALTURA') then

		ds_retorno_w := qt_altura_banda_w;

	elsif (upper(ie_valor_p) = 'EXPRESSAO') then

		ds_retorno_w := ds_expressao_banda_w;

	elsif (upper(ie_valor_p) = 'TIPO') then

		ds_retorno_w := ie_tipo_banda_w;

	end if;

elsif (upper(ie_opcao_p) = 'CAMPO') then

	select	max(ds_mascara),
		max(nm_atributo),
		max(ie_ajustar_tamanho),
		max(ie_estender),
		max(qt_tamanho),
		max(ds_estilo_fonte),
		max(qt_altura),
		max(qt_topo),
		max(qt_tam_fonte),
		max(ds_label),
		max(qt_esquerda),
		max(ds_campo)
	into STRICT	ds_mascara_w,
		nm_atributo_w,
		ie_ajustar_tamanho_w,
		ie_estender_w,
		qt_tamanho_w,
		ds_estilo_fonte_w,
		qt_altura_w,
		qt_topo_w,
		qt_tam_fonte_w,
		ds_label_w,
		qt_esquerda_w,
		ds_campo_w
	from	banda_relat_campo
	where	nr_sequencia = nr_sequencia_p;


	if (upper(ie_valor_p) = 'MASCARA') then

		ds_retorno_w := ds_mascara_w;

	elsif (upper(ie_valor_p) = 'ATRIBUTO') then

		ds_retorno_w := nm_atributo_w;

	elsif (upper(ie_valor_p) = 'AJUSTAR_TAMANHO') then

		ds_retorno_w := ie_ajustar_tamanho_w;

	elsif (upper(ie_valor_p) = 'ESTENDER') then

		ds_retorno_w := ie_estender_w;

	elsif (upper(ie_valor_p) = 'TAMANHO') then

		ds_retorno_w := qt_tamanho_w;

	elsif (upper(ie_valor_p) = 'ESTILO_FONTE') then

		ds_retorno_w := ds_estilo_fonte_w;

	elsif (upper(ie_valor_p) = 'ALTURA') then

		ds_retorno_w := qt_altura_w;

	elsif (upper(ie_valor_p) = 'TOPO') then

		ds_retorno_w := qt_topo_w;

	elsif (upper(ie_valor_p) = 'TAM_FONTE') then

		ds_retorno_w := qt_tam_fonte_w;

	elsif (upper(ie_valor_p) = 'LABEL') then

		ds_retorno_w := ds_label_w;

	elsif (upper(ie_valor_p) = 'ESQUERDA') then

		ds_retorno_w := qt_esquerda_w;

	elsif (upper(ie_valor_p) = 'DESCRICAO') then

		ds_retorno_w := ds_campo_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacoes_relatorio (ie_opcao_p text, ie_valor_p text,nr_sequencia_p bigint) FROM PUBLIC;
