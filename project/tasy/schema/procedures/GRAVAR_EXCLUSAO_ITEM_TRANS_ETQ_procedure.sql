-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_exclusao_item_trans_etq ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w	integer;
ds_material_w	varchar(255);
ds_historico_w	varchar(255);


BEGIN
select	cd_material,
	substr(obter_desc_material(cd_material),1,255)
into STRICT	cd_material_w,
	ds_material_w
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(302836,'NR_ITEM_OCI_P='|| NR_ITEM_OCI_P ||';CD_MATERIAL_W='|| CD_MATERIAL_W ||';DS_MATERIAL_W='|| DS_MATERIAL_W),1,255);
		/*Foi realizada a exclusão do item #@NR_ITEM_OCI_P#@ [#@CD_MATERIAL_W#@] - #@DS_MATERIAL_W#@*/

CALL inserir_historico_ordem_compra(
	nr_ordem_compra_p,
	'S',
	Wheb_mensagem_pck.get_Texto(302837), /*'Exclusão de item após estorno da liberação',*/
	ds_historico_w,
	nm_usuario_p);
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_exclusao_item_trans_etq ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nm_usuario_p text) FROM PUBLIC;
