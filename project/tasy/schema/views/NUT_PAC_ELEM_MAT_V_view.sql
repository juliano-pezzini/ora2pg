-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nut_pac_elem_mat_v (ds_item, cd_material, ds_material, nr_prescricao, nr_sequencia, ie_tipo_item) AS select	'NPT Adulta' ds_item,
		c.cd_material, --- NPT Adulta Antiga
		obter_desc_material(c.cd_material) ds_material,
		a.nr_prescricao,
		c.nr_sequencia,
		'NAN' ie_tipo_item
FROM	nut_paciente a,
		nut_paciente_elemento b,
		nut_pac_elem_mat c
where	a.nr_sequencia = b.nr_seq_nut_pac
and		b.nr_sequencia = c.nr_seq_nut_pac_ele

union all

select	'NPT Adulta Protocolo' ds_item,
		c.cd_material, --- NPT Adulta Protocolo
		obter_desc_material(c.cd_material) ds_material,
		a.nr_prescricao,
		c.nr_sequencia,
		'NPA' ie_tipo_item
from	nut_pac a,
		nut_pac_elem_mat c
where	a.nr_sequencia = c.nr_seq_nut_pac
and		coalesce(a.ie_npt_adulta,'S') = 'S'

union all

select	CASE WHEN coalesce(a.ie_npt_adulta,'S')='N' THEN  'NPT Neonatal'  ELSE 'NPT Pediátrica' END  ds_item,
		d.cd_material, --- NPT Pediátrica e Neonatal
		obter_desc_material(d.cd_material) ds_material,
		a.nr_prescricao,
		c.nr_sequencia,
		CASE WHEN coalesce(a.ie_npt_adulta,'S')='N' THEN  'NPN'  ELSE 'NPP' END  ds_item
from	nut_pac a,
		nut_pac_elemento b,
		nut_pac_elem_mat c,
		nut_elem_material d
where	a.nr_sequencia = b.nr_seq_nut_pac
and		b.nr_sequencia = c.nr_seq_pac_elem
and		b.nr_seq_elemento = d.nr_seq_elemento
and		d.nr_sequencia = c.nr_seq_elem_mat
and		coalesce(a.ie_npt_adulta,'S') <> 'S';
