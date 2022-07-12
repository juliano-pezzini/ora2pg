-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_proced_exame_result ( nr_seq_resultado_p bigint, nr_seq_exame_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_procedimento_w	bigint;


BEGIN

select	max(b.cd_procedimento) cd_procedimento
into STRICT	cd_procedimento_w
from 	exame_laboratorio c,
        exame_lab_resultado e,
        exame_lab_result_item d,
        prescr_procedimento b
where 	b.nr_prescricao 	= e.nr_prescricao
and 	e.nr_seq_resultado 	= d.nr_seq_resultado
and 	b.nr_sequencia 		= d.nr_seq_prescr
and 	d.nr_seq_exame 		= c.nr_seq_exame
and	d.nr_seq_resultado 	= nr_seq_resultado_p
and	d.nr_seq_exame 		= nr_seq_exame_p
and	d.nr_sequencia 		= nr_sequencia_p;

return	cd_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_proced_exame_result ( nr_seq_resultado_p bigint, nr_seq_exame_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

