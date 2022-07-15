-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_aprovar_aditivo ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


pr_aditivo_w			double precision;
pr_aditivo_total_w			double precision;
qt_item_w			double precision;
nr_seq_reg_compra_item_w		bigint;
ds_historico_w			varchar(4000);
cd_material_w			integer;
ds_material_w			varchar(255);
nr_seq_reg_compra_w		bigint;


BEGIN

select	nr_seq_reg_compra_item,
	pr_aditivo,
	qt_item
into STRICT	nr_seq_reg_compra_item_w,
	pr_aditivo_w,
	qt_item_w
from	reg_lic_aditivo
where	nr_sequencia = nr_sequencia_p;

select	coalesce(sum(pr_aditivo),0) + pr_aditivo_w
into STRICT	pr_aditivo_total_w
from	reg_lic_aditivo
where	nr_seq_reg_compra_item = nr_seq_reg_compra_item_w
and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');

if (pr_aditivo_total_w > 25) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266169);
	--'O valor de ativo não pode ultrapassar 25% sobre a quantidade do registro de preço.');
end if;

update	reg_compra_item
set	qt_item		= qt_item + qt_item_w
where	nr_sequencia	= nr_seq_reg_compra_item_w;

update	reg_lic_aditivo
set	dt_aprovacao	= clock_timestamp(),
	nm_usuario_aprov	= nm_usuario_p
where	nr_sequencia	= nr_sequencia_p;

select	nr_seq_reg_compra,
	cd_material,
	substr(obter_desc_material(cd_material),1,255) ds_material
into STRICT	nr_seq_reg_compra_w,
	cd_material_w,
	ds_material_w
from	reg_compra_item
where	nr_sequencia	= nr_seq_reg_compra_item_w;

ds_historico_w := 	substr(WHEB_MENSAGEM_PCK.get_texto(310364, 'NR_SEQUENCIA_P=' || nr_sequencia_p || ';PR_ADITIVO_W=' || pr_aditivo_w) || cd_material_w || ' - ' || ds_material_w || '.',1,4000); --Aprovado o aditivo número ' || nr_sequencia_p || ' de ' || pr_aditivo_w  || '% do material '
CALL lic_gerar_historico_reg_preco(nr_seq_reg_compra_w, ds_historico_w, 'S', nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_aprovar_aditivo ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

