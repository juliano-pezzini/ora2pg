-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW funcao_tf_campo_v (nm_tabela, nm_atributo, cd_funcao) AS select	'BORDERO_TIT_REC' nm_tabela,
	'NR_SEQ_TRANS_FINANC' nm_atributo,
	809 cd_funcao


union

select	'TITULO_RECEBER_LIQ' nm_tabela,
	'NR_SEQ_TRANS_FIN' nm_atributo,
	801 cd_funcao


union

select	'ADIANTAMENTO' nm_tabela,
	'NR_SEQ_TRANS_CAIXA' nm_atributo,
	813 cd_funcao


union

select	'TITULO_RECEBER_LIQ' nm_tabela,
	'NR_SEQ_TRANS_CAIXA' nm_atributo,
	813 cd_funcao


union

select	'MOVTO_TRANS_FINANC' nm_tabela,
	'NR_SEQ_TRANS_FINANC' nm_atributo,
	813 cd_funcao


union

select	'TITULO_RECEBER_COBR' nm_tabela,
	'NR_SEQ_TRANS_FINANC' nm_atributo,
	815 cd_funcao

order by 1,2;

