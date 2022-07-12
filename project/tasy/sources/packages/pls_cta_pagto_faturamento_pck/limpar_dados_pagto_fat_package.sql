-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Limpa dados das variaveis tabela.
CREATE OR REPLACE PROCEDURE pls_cta_pagto_faturamento_pck.limpar_dados_pagto_fat (tb_dados_pagto_fat INOUT table_dados_pagto_fat) AS $body$
BEGIN
	tb_dados_pagto_fat.nr_seq_item.delete;		
	tb_dados_pagto_fat.nr_seq_conta.delete;		
	tb_dados_pagto_fat.vl_liberado.delete;		
	tb_dados_pagto_fat.vl_lib_original.delete;		
	tb_dados_pagto_fat.ds_tipo_item.delete;		
	tb_dados_pagto_fat.nr_seq_prestador_pagto.delete;	
	tb_dados_pagto_fat.nm_prestador_pgto.delete;	
	tb_dados_pagto_fat.vl_hm.delete;			
	tb_dados_pagto_fat.vl_material_pag.delete;		
	tb_dados_pagto_fat.vl_co_pag.delete;
	tb_dados_pagto_fat.qt_item.delete;

END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE pls_cta_pagto_faturamento_pck.limpar_dados_pagto_fat (tb_dados_pagto_fat INOUT table_dados_pagto_fat) FROM PUBLIC;
