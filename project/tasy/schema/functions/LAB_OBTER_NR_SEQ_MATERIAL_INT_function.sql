-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_nr_seq_material_int (nr_prescricao_p text, cd_material_exame_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_material_w		varchar(20);


BEGIN

select  MAX(d.nr_sequencia)
into STRICT 	nr_seq_material_w
from	exame_lab_resultado b,
	material_exame_lab d,
	exame_lab_result_item c,
	prescr_procedimento a
where 	a.nr_prescricao = b.nr_prescricao
and	a.nr_sequencia = c.nr_seq_prescr
and	b.nr_seq_resultado = c.nr_seq_resultado
and	c.nr_seq_material = d.nr_sequencia
and	a.nr_prescricao = nr_prescricao_p
and	coalesce(d.cd_material_integracao,d.cd_material_exame) = cd_material_exame_p
and	(c.nr_seq_material IS NOT NULL AND c.nr_seq_material::text <> '');

return	nr_seq_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_nr_seq_material_int (nr_prescricao_p text, cd_material_exame_p text) FROM PUBLIC;

