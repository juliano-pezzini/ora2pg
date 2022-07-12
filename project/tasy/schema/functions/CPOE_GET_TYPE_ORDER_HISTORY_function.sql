-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_get_type_order_history (nr_seq_cpoe_p bigint, ie_tipo_item_cpoe_p text) RETURNS varchar AS $body$
DECLARE


ds_return_w cpoe_material.ds_stack%type;


BEGIN

if (ie_tipo_item_cpoe_p = 'N') then
	select	max(coalesce(d.cd_dieta, d.cd_material, d.nr_seq_tipo, d.cd_mat_prod1))
	into STRICT	ds_return_w
	from	cpoe_dieta d
	where	d.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'M' or ie_tipo_item_cpoe_p = 'MAT') then
    select	max(m.cd_material)
	into STRICT	ds_return_w
	from	cpoe_material m
	where	m.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'P') then
    select	max(p.nr_seq_proc_interno)
	into STRICT	ds_return_w
	from	cpoe_procedimento p
	where	p.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'R') then
    select	max(r.cd_recomendacao)
	into STRICT	ds_return_w
	from	cpoe_recomendacao r
	where	r.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'G') then
    select	max(g.ie_respiracao)
	into STRICT	ds_return_w
	from	cpoe_gasoterapia g
	where	g.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'HM') then
    select	max(h.nr_seq_derivado)
	into STRICT	ds_return_w
	from	cpoe_hemoterapia h 
	where	h.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'AP') then
    select	max(a.nr_seq_proc_interno)
	into STRICT	ds_return_w
	from	cpoe_anatomia_patologica a
	where	a.nr_sequencia = nr_seq_cpoe_p;
elsif (ie_tipo_item_cpoe_p = 'D') then
    select	max(coalesce(d.ie_tipo_peritoneal, d.ie_tipo_hemodialise))
	into STRICT	ds_return_w
	from	cpoe_dialise d
	where	d.nr_sequencia = nr_seq_cpoe_p;
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_get_type_order_history (nr_seq_cpoe_p bigint, ie_tipo_item_cpoe_p text) FROM PUBLIC;

