-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_exame_prescrito ( nr_prescricao_p bigint, nr_seq_exame_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_exame_w	bigint;


BEGIN

select max(b.nr_seq_exame)
into STRICT	nr_seq_exame_w
from 	prescr_procedimento b,
	prescr_medica c,
	exame_lab_resultado e,
	exame_lab_result_item g
where	b.nr_prescricao         = c.nr_prescricao
and	b.nr_prescricao         = e.nr_prescricao
and	e.nr_seq_resultado   	= g.nr_seq_resultado
and	g.nr_seq_prescr        = b.nr_sequencia
and	b.nr_prescricao         = nr_prescricao_p
and	g.nr_seq_exame		= nr_seq_exame_p;

return	nr_seq_exame_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_exame_prescrito ( nr_prescricao_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
