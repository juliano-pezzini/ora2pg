-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_hist_desdob_entrega_oc ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ds_entrega_original_p text, ds_entrega_alterada_p text, nm_usuario_p text) AS $body$
DECLARE


cd_material_w			integer;
ds_mensagem_w			varchar(4000);

BEGIN

select	cd_material
into STRICT	cd_material_w
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;


CALL inserir_historico_ordem_compra(
		nr_ordem_compra_p,
		'S',
		WHEB_MENSAGEM_PCK.get_texto(302533),
		substr(WHEB_MENSAGEM_PCK.get_texto(302534,'NM_USUARIO_P=' || nm_usuario_p || ';' || 'CD_MATERIAL_W=' || cd_material_w || ';' ||
							'DS_ENTREGA_ORIGINAL_P=' || ds_entrega_original_p || ';' || 'DS_ENTREGA_ALTERADA_P=' || ds_entrega_alterada_p),1,4000),
		nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_hist_desdob_entrega_oc ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ds_entrega_original_p text, ds_entrega_alterada_p text, nm_usuario_p text) FROM PUBLIC;

