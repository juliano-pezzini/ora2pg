-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_barras_nota_mat ( nr_sequencia_p bigint, nr_item_nf_p bigint, cd_barra_material_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_item_nf_p IS NOT NULL AND nr_item_nf_p::text <> '')  then
	begin

update	nota_fiscal_item
set	cd_barra_material = cd_barra_material_p
where	nr_sequencia = nr_sequencia_p
and	nr_item_nf = nr_item_nf_p;

insert	into w_nota_fiscal_item_barra(
	SELECT nextval('w_nota_fiscal_item_barra_seq'),
	clock_timestamp(),
	nm_usuario,
	clock_timestamp(),
	nm_usuario,
	nr_sequencia,
	nr_item_nf,
	cd_barra_material
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_p
and	nr_item_nf = nr_item_nf_p);

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_barras_nota_mat ( nr_sequencia_p bigint, nr_item_nf_p bigint, cd_barra_material_p text, nm_usuario_p text) FROM PUBLIC;
