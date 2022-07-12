-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_check_in_out_hospital ( cd_material_p bigint, nr_seq_order_unit_p bigint) RETURNS varchar AS $body$
DECLARE


    ie_in_hospital_w             cpoe_type_of_prescription.ie_in_hospital%type;
    ds_retorno_w                 varchar(4000) := null;
    ie_out_of_hospital_w         cpoe_type_of_prescription.ie_out_of_hospital%type;
    ie_material_in_hospital_w    material_estab.ie_in_hospital%type;
    ie_material_out_hospital_w   material_estab.ie_out_of_hospital%type;
    si_type_of_prescription_w    cpoe_order_unit.si_type_of_prescription%type;
    nr_seq_cpoe_tipo_pedido_w     cpoe_order_unit.nr_seq_cpoe_tipo_pedido%type;


BEGIN
	if (cd_material_p IS NOT NULL AND cd_material_p::text <> '' AND nr_seq_order_unit_p IS NOT NULL AND nr_seq_order_unit_p::text <> '') then
		select
		coalesce(b.ie_in_hospital, 'S'),
		coalesce(b.ie_out_of_hospital, 'S'),
		b.si_type_of_prescription,
		b.nr_seq_cpoe_tipo_pedido
		into STRICT
		ie_in_hospital_w,
		ie_out_of_hospital_w,
		si_type_of_prescription_w,
		nr_seq_cpoe_tipo_pedido_w
		from
		cpoe_order_unit             a,
		cpoe_type_of_prescription   b
		where
		a.si_type_of_prescription = b.si_type_of_prescription
		and a.nr_seq_cpoe_tipo_pedido = b.nr_seq_cpoe_tipo_pedido
		and a.nr_sequencia = nr_seq_order_unit_p;

		select
		max(b.ie_in_hospital),
		max(b.ie_out_of_hospital)
		into STRICT
		ie_material_in_hospital_w,
		ie_material_out_hospital_w
		from
		material_estab b
		where
		cd_material = cd_material_p;
	end if;

	if ( (ie_in_hospital_w = 'S' and (coalesce(ie_material_in_hospital_w::text, '') = '' or ie_material_in_hospital_w <> 'S') ) or (ie_out_of_hospital_w = 'S' and (coalesce(ie_material_out_hospital_w::text, '') = '' or ie_material_out_hospital_w <> 'S')) ) then
		ds_retorno_w := obter_desc_expressao(1072326);
	end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_check_in_out_hospital ( cd_material_p bigint, nr_seq_order_unit_p bigint) FROM PUBLIC;

