-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carrega_lic_w_importa_precos ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, vl_item_p bigint, ds_marca_p text, cd_pessoa_fisica_p text, cd_cgc_fornec_p text) AS $body$
DECLARE


cd_material_w		integer;


BEGIN

select	max(cd_material)
into STRICT	cd_material_w
from	reg_lic_item
where	nr_seq_licitacao = nr_seq_licitacao_p
and	nr_seq_lic_item = nr_seq_lic_item_p;

if (vl_item_p > 0) then
	insert into lic_w_importa_precos(
		nr_seq_licitacao,
		nr_seq_lic_item,
		cd_material,
		vl_item,
		ds_marca,
		cd_pessoa_fisica,
		cd_cgc_fornec,
		ie_cota_reservada)
	values(	nr_seq_licitacao_p,
		nr_seq_lic_item_p,
		cd_material_w,
		vl_item_p,
		ds_marca_p,
		cd_pessoa_fisica_p,
		cd_cgc_fornec_p,
		(SELECT max(ie_cota_reservada) from reg_lic_item where nr_seq_licitacao = nr_seq_licitacao_p and nr_seq_lic_item = nr_seq_lic_item_p));
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carrega_lic_w_importa_precos ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, vl_item_p bigint, ds_marca_p text, cd_pessoa_fisica_p text, cd_cgc_fornec_p text) FROM PUBLIC;
