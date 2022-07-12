-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_data_coleta (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_coleta_w		timestamp;


BEGIN

select	max(b.dt_coleta)
into STRICT	dt_coleta_w
from	exame_lab_result_item b,
	exame_lab_resultado a
where	a.nr_seq_resultado	= b.nr_seq_resultado
and	a.nr_prescricao		= nr_prescricao_p
and	b.nr_seq_prescr		= nr_seq_prescr_p
and	(b.nr_seq_material IS NOT NULL AND b.nr_seq_material::text <> '');

return	dt_coleta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_data_coleta (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

