-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW colunas_gestao_presc_v (ie_tipo, ds_tipo, vl_chave) AS select 'TT' ie_tipo,
		substr(Obter_Desc_Expressao(329054),1,35) ds_tipo,
		'01' vl_chave


union

select	'D' ie_tipo,
	substr(obter_desc_expressao(287903),1,35) ds_tipo,
	'02' vl_chave


union

select	'SNE' ie_tipo,
	substr(obter_desc_expressao(745065),1,35) ds_tipo,
	'03' vl_chave


union

select	'S' ie_tipo,
	substr(obter_desc_expressao(298694),1,35) ds_tipo,
	'04' vl_chave


union

select	'M' ie_tipo,
	substr(obter_desc_expressao(293070),1,35) ds_tipo,
	'05' vl_chave


union

select	'P' ie_tipo,
	substr(obter_desc_expressao(296422),1,35) ds_tipo,
	'06' vl_chave


union

select	'CG' ie_tipo,
	substr(obter_desc_expressao(493403),1,35) ds_tipo,
	'07' vl_chave


union

select	'R' ie_tipo,
	substr(obter_desc_expressao(297348),1,35) ds_tipo,
	'08' vl_chave


union

select	'C' ie_tipo,
	substr(obter_desc_expressao(285474),1,35) ds_tipo,
	'09' vl_chave


union

select	'G' ie_tipo,
	substr(obter_desc_expressao(290567),1,35) ds_tipo,
	'10' vl_chave
;
