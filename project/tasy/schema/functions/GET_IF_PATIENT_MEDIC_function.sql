-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_patient_medic (nr_seq_ordem_p can_ordem_prod.nr_sequencia%type, cd_material_p material.cd_material%type) RETURNS varchar AS $body$
DECLARE

	cd_patient_medic_w	far_estoque_cabine.cd_material%type := '';

BEGIN
	if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') then
	begin
		select cabin.cd_material
		into STRICT	cd_patient_medic_w
		from	can_ordem_item_prescr item
		join	can_ordem_prod prod_order on item.nr_seq_ordem = prod_order.nr_sequencia
		join	far_etapa_producao stage on stage.nr_sequencia = prod_order.nr_seq_etapa_prod
		join	far_estoque_cabine cabin on stage.nr_seq_cabine = cabin.nr_seq_cabine
		join	material medic on cabin.cd_material = medic.cd_material
		where ((cabin.cd_material = item.cd_material)  or
				(medic.nr_seq_ficha_tecnica = (SELECT  max(x.nr_seq_ficha_tecnica)
												from    material x
												where	x.cd_material = item.cd_material)) or (item.cd_material = medic.cd_material_generico))
		and (cabin.cd_pessoa_fisica IS NOT NULL AND cabin.cd_pessoa_fisica::text <> '')
		and prod_order.nr_sequencia = nr_seq_ordem_p
        and medic.cd_material = cd_material_p;
	end;
	end if;

	return cd_patient_medic_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_patient_medic (nr_seq_ordem_p can_ordem_prod.nr_sequencia%type, cd_material_p material.cd_material%type) FROM PUBLIC;
