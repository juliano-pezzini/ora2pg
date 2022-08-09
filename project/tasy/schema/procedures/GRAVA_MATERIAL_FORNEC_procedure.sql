-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_material_fornec ( cd_material_p bigint, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_unid_medida_w	varchar(30);
qt_conv_compra_est_w	double precision;


BEGIN

select	coalesce(max(cd_unidade_medida_compra),0),
	coalesce(max(qt_conv_compra_estoque),0)
into STRICT	cd_unid_medida_w,
	qt_conv_compra_est_w
from	material
where	cd_material = cd_material_p;

if (coalesce(cd_unid_medida_w,'0') <> '0') and (coalesce(qt_conv_compra_est_w,0) <> 0) then

	insert	into material_fornec(nr_sequencia,				cd_estabelecimento,		cd_material,
		dt_atualizacao,				nm_usuario,			cd_cgc,
		ie_consignado,				cd_unid_medida,			qt_conv_compra_est,
		dt_atualizacao_nrec,			nm_usuario_nrec,		ie_ressuprimento,
		ie_nota_fiscal)
	Values (nextval('material_fornec_seq'),		cd_estabelecimento_p,		cd_material_p,
		clock_timestamp(),				nm_usuario_p,			cd_cgc_p,
		'0',					cd_unid_medida_w,		qt_conv_compra_est_w,
		clock_timestamp(),				nm_usuario_p,			'N',
		'S');
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_material_fornec ( cd_material_p bigint, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
