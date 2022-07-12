-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- OBTER_VALOR_DIMENSAO



CREATE OR REPLACE FUNCTION pls_ar_montar_resultado_pck.obter_valor_dimensao (ds_tipo_dimensao_p text) RETURNS varchar AS $body$
DECLARE


ds_campo_dimensao_w		varchar(255);


BEGIN
if (upper(ds_tipo_dimensao_p) = 'ANO') then -- Ano
	ds_campo_dimensao_w	:= 'to_char(lote.dt_mes_competencia, ''YYYY'')';
elsif (ds_tipo_dimensao_p = 'C') then -- Contrato
	ds_campo_dimensao_w	:= 'nvl(pls_obter_dados_contrato(a.nr_seq_contrato,''N''), nvl(a.nr_seq_contrato, a.nr_seq_intercambio))';
elsif (ds_tipo_dimensao_p = 'F') then -- Faixa etaria
	ds_campo_dimensao_w	:= 'a.nr_seq_faixa_etaria';
elsif (upper(ds_tipo_dimensao_p) = 'MES') then -- Mes
	ds_campo_dimensao_w	:= 'to_char(lote.dt_mes_competencia, ''mm/yyyy'')';
elsif (ds_tipo_dimensao_p = 'P') then -- Plano
	ds_campo_dimensao_w	:= 'a.nr_seq_plano';
elsif (upper(ds_tipo_dimensao_p) = 'PAG') then -- Pagador
	ds_campo_dimensao_w	:= 'a.nr_seq_pagador';
elsif (ds_tipo_dimensao_p = 'B') then -- Beneficiario
	ds_campo_dimensao_w	:= 'a.nr_seq_segurado';
elsif (ds_tipo_dimensao_p = 'TC') then -- Tipo contratacao
	ds_campo_dimensao_w	:= 'a.ie_tipo_contratacao';
elsif (ds_tipo_dimensao_p = 'T') then -- Trimestre
	ds_campo_dimensao_w	:= 'trunc(lote.dt_mes_competencia, ''Q'')';
elsif (ds_tipo_dimensao_p = 'S') then -- Semestre
	ds_campo_dimensao_w	:= 	'case when (to_char(lote.dt_mes_competencia, ''mm'') < 7) then ' || pls_util_pck.enter_w ||
					'	''01/'' || to_char(lote.dt_mes_competencia, ''yyyy'') ' || pls_util_pck.enter_w ||
					'else ' || pls_util_pck.enter_w ||
					'	''02/'' || to_char(lote.dt_mes_competencia, ''yyyy'') end';
end if;

return ds_campo_dimensao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ar_montar_resultado_pck.obter_valor_dimensao (ds_tipo_dimensao_p text) FROM PUBLIC;
