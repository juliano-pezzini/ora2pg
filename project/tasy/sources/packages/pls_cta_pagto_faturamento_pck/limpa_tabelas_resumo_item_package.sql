-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_pagto_faturamento_pck.limpa_tabelas_resumo_item ( table_dados_resumo_item_p INOUT table_dados_resumo_item) AS $body$
BEGIN

table_dados_resumo_item_p.nr_seq_proc.delete;			
table_dados_resumo_item_p.nr_seq_partic.delete;			
table_dados_resumo_item_p.nr_seq_mat.delete;			
table_dados_resumo_item_p.ie_tipo_item.delete;			
table_dados_resumo_item_p.nr_seq_prest_pagto_coleta.delete;	

END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE pls_cta_pagto_faturamento_pck.limpa_tabelas_resumo_item ( table_dados_resumo_item_p INOUT table_dados_resumo_item) FROM PUBLIC;