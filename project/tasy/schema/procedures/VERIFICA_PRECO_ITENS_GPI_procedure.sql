-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_preco_itens_gpi ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, vl_preco_liquido_p bigint, vl_realizado_p bigint, vl_orcado_p bigint, cd_material_p bigint, ie_bloqueia_p text, nm_usuario_p text) AS $body$
DECLARE


ds_consistencia_w    varchar(255);


BEGIN

if ((vl_preco_liquido_p + vl_realizado_p) > vl_orcado_p) then
	ds_consistencia_w   := substr(Wheb_mensagem_pck.get_Texto(1164538,'CD_MATERIAL='||cd_material_p),1,255);
	CALL grava_consistencia_cotacao(nr_cot_compra_p,nr_item_cot_compra_p,null,ds_consistencia_w,ie_bloqueia_p,nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_preco_itens_gpi ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, vl_preco_liquido_p bigint, vl_realizado_p bigint, vl_orcado_p bigint, cd_material_p bigint, ie_bloqueia_p text, nm_usuario_p text) FROM PUBLIC;

