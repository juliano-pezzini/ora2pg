-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_list_of_comments ( nr_seq_cpoe_material_p bigint default null, nr_seq_cpoe_proced_p bigint default null, nr_seq_cpoe_nutricao_p bigint default null, nr_seq_cpoe_recomend_p bigint default null, nr_seq_cpoe_dialise_p bigint default null, nr_seq_cpoe_anat_pat_p bigint default null, nr_seq_cpoe_gasoterapia_p bigint default null, nr_seq_cpoe_hemoterapia_p bigint default null, nr_seq_cpoe_just_item_p bigint default null, nr_seq_cpoe_order_unit_p bigint default null, nr_seq_cpoe_rp_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_return_w 	varchar(32767);
ds_text_w		varchar(32767);
si_bl_transf_w	cpoe_comment_display_rule.si_bl_transf%type;
si_dialysis_w	cpoe_comment_display_rule.si_dialysis%type;
si_endoscopy_w	cpoe_comment_display_rule.si_endoscopy%type;
si_injections_w	cpoe_comment_display_rule.si_injections%type;
si_medicine_w	cpoe_comment_display_rule.si_medicine%type;
si_physiology_w	cpoe_comment_display_rule.si_physiology%type;
si_radiology_w	cpoe_comment_display_rule.si_radiology%type;
si_surgery_w	cpoe_comment_display_rule.si_surgery%type;

c_comments_item CURSOR FOR
SELECT	b.ds_comment,
			d.nr_seq_cpoe_tipo_pedido as nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a,
			cpoe_material c,
			cpoe_order_unit d,
			cpoe_tipo_pedido e
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_material = nr_seq_cpoe_material_p
AND		c.nr_sequencia = a.nr_seq_cpoe_material
AND		c.nr_seq_cpoe_order_unit = d.nr_sequencia
AND		d.nr_seq_cpoe_tipo_pedido = e.nr_sequencia
AND (si_medicine_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'ME')
AND (si_injections_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'I')

union all

select	cpoe_concat_cmt_proc(b.ds_comment, b.ds_additional_matter, a.ds_additional_text) ds_comment,
			d.nr_seq_cpoe_tipo_pedido as nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a,
			cpoe_procedimento c,
			cpoe_order_unit d,
			cpoe_tipo_pedido e
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_proced = nr_seq_cpoe_proced_p
AND		c.nr_sequencia = a.nr_seq_cpoe_proced
AND		c.nr_seq_cpoe_order_unit = d.nr_sequencia
AND		d.nr_seq_cpoe_tipo_pedido = e.nr_sequencia
AND (si_endoscopy_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'E')
AND (si_physiology_w = 'y' or e.NR_SEQ_SUB_GRP <> 'PH')
AND (si_radiology_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'R')
AND (si_surgery_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'S')

union all

select	b.ds_comment,
			b.nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_nutricao = nr_seq_cpoe_nutricao_p

union all

select	b.ds_comment,
			b.nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_recomend = nr_seq_cpoe_recomend_p

union all

select	b.ds_comment,
			d.nr_seq_cpoe_tipo_pedido as nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a,
			cpoe_dialise c,
			cpoe_order_unit d,
			cpoe_tipo_pedido e
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_dialise = nr_seq_cpoe_dialise_p
AND		c.nr_sequencia = a.nr_seq_cpoe_dialise
AND		c.nr_seq_cpoe_order_unit = d.nr_sequencia
AND		d.nr_seq_cpoe_tipo_pedido = e.nr_sequencia
AND (si_dialysis_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'D')

union all

select	b.ds_comment,
			b.nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_anat_pat = nr_seq_cpoe_anat_pat_p

union all

select	b.ds_comment,
			b.nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_gasoterapia = nr_seq_cpoe_gasoterapia_p

union all

select	b.ds_comment,
			d.nr_seq_cpoe_tipo_pedido as nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a,
			cpoe_hemoterapia c,
			cpoe_order_unit d,
			cpoe_tipo_pedido e
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_hemoterapia = nr_seq_cpoe_hemoterapia_p
AND		c.nr_sequencia = a.nr_seq_cpoe_hemoterapia
AND		c.nr_seq_cpoe_order_unit = d.nr_sequencia
AND		d.nr_seq_cpoe_tipo_pedido = e.nr_sequencia
AND (si_bl_transf_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'BT')

union all

select	b.ds_comment,
			b.nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a
where	a.nr_seq_std_comment = b.nr_sequencia
and		a.nr_seq_cpoe_just_item = nr_seq_cpoe_just_item_p;

c_comments_rp CURSOR FOR
SELECT	b.ds_comment,
			d.nr_seq_cpoe_tipo_pedido as nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a,
			cpoe_material c,
			cpoe_order_unit d,
			cpoe_tipo_pedido e
where	a.nr_seq_std_comment = b.nr_sequencia
and		c.nr_sequencia = nr_seq_cpoe_material_p
and		c.nr_seq_cpoe_order_unit = d.nr_sequencia
AND		d.nr_seq_cpoe_tipo_pedido = e.nr_sequencia
AND (si_medicine_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'ME')
AND (si_injections_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'I')
and		a.nr_seq_cpoe_rp = c.nr_seq_cpoe_rp;

c_comments_orderUnity CURSOR FOR
SELECT	b.ds_comment,
			d.nr_seq_cpoe_tipo_pedido as nr_seq_order_type
from		cpoe_std_comment b,
			cpoe_comment_linkage a,
			cpoe_material c,
			cpoe_order_unit d,
			cpoe_tipo_pedido e
where	a.nr_seq_std_comment = b.nr_sequencia
and		c.nr_sequencia = nr_seq_cpoe_material_p
AND		c.nr_seq_cpoe_order_unit = d.nr_sequencia
AND		d.nr_seq_cpoe_tipo_pedido = e.nr_sequencia
AND (si_medicine_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'ME')
AND (si_injections_w = 'Y' or e.NR_SEQ_SUB_GRP <> 'I')
and		a.nr_seq_cpoe_order_unit = c.nr_seq_cpoe_order_unit;
BEGIN

select	coalesce(max(si_bl_transf), 'N'),
			coalesce(max(si_dialysis), 'N'),
			coalesce(max(si_endoscopy), 'N'),
			coalesce(max(si_injections), 'N'),
			coalesce(max(si_medicine), 'N'),
			coalesce(max(si_physiology), 'N'),
			coalesce(max(si_radiology), 'N'),
			coalesce(max(si_surgery), 'N')
into STRICT		si_bl_transf_w,
			si_dialysis_w,
			si_endoscopy_w,
			si_injections_w,
			si_medicine_w,
			si_physiology_w,
			si_radiology_w,
			si_surgery_w
from		cpoe_comment_display_rule
where	coalesce(ie_situacao, 'A') = 'A';

for r_c_comments in c_comments_item loop
	if (r_c_comments.ds_comment IS NOT NULL AND r_c_comments.ds_comment::text <> '') then
		if (r_c_comments.nr_seq_order_type IS NOT NULL AND r_c_comments.nr_seq_order_type::text <> '') then
			ds_text_w :=  obter_descricao_padrao('CPOE_TIPO_PEDIDO', 'DS_TIPO', r_c_comments.nr_seq_order_type) || ': ';
		else
			ds_text_w := ' ';
		end if;

		ds_text_w := ds_text_w || r_c_comments.ds_comment || ' | ';
		ds_return_w := ds_return_w || ds_text_w;

	end if;

end loop;

for r_c_comments_rp in c_comments_rp loop
	if (r_c_comments_rp.ds_comment IS NOT NULL AND r_c_comments_rp.ds_comment::text <> '') then	
		ds_text_w := obter_desc_expressao(1017547) || ': '|| r_c_comments_rp.ds_comment || ' | ';
		ds_return_w := ds_return_w || ds_text_w;
	end if;

end loop;

for r_c_comments_orderUnity in c_comments_orderUnity loop
	if (r_c_comments_orderUnity.ds_comment IS NOT NULL AND r_c_comments_orderUnity.ds_comment::text <> '') then
		ds_text_w := obter_desc_expressao(292294) || ': ' || r_c_comments_orderUnity.ds_comment || ' | ';
		ds_return_w := ds_return_w || ds_text_w;
	end if;

end loop;

return substr(ds_return_w, 1, length(ds_return_w) - 2);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_list_of_comments ( nr_seq_cpoe_material_p bigint default null, nr_seq_cpoe_proced_p bigint default null, nr_seq_cpoe_nutricao_p bigint default null, nr_seq_cpoe_recomend_p bigint default null, nr_seq_cpoe_dialise_p bigint default null, nr_seq_cpoe_anat_pat_p bigint default null, nr_seq_cpoe_gasoterapia_p bigint default null, nr_seq_cpoe_hemoterapia_p bigint default null, nr_seq_cpoe_just_item_p bigint default null, nr_seq_cpoe_order_unit_p bigint default null, nr_seq_cpoe_rp_p bigint default null) FROM PUBLIC;
