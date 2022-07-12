-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cot_compra_item_vencedor_v2 (nr_sequencia, nr_cot_compra, nr_item_cot_compra, ie_vencedor, vl_vencedor) AS SELECT	I.NR_SEQUENCIA,
	I.nr_cot_compra, 
	I.nr_item_cot_compra, 
	CASE WHEN Obter_Venc_Cot_Fornec_item(I.nr_cot_compra, I.nr_item_cot_compra)=I.nr_sequencia THEN  'S'  ELSE 'N' END  ie_vencedor, 
	CASE WHEN Obter_Venc_Cot_Fornec_item(I.nr_cot_compra, I.nr_item_cot_compra)=I.nr_sequencia THEN  I.vl_presente  ELSE 0 END  vl_vencedor 
FROM	COT_COMPRA_FORN_ITEM I 
WHERE	I.VL_UNITARIO_MATERIAL > 0;

