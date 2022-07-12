-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_result_exam_suep (nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_valor_w	bigint := 0;			
				

BEGIN

select max(coalesce(qt_resultado, 0))
into STRICT qt_valor_w
from exame_lab_result_item x,
     exame_lab_resultado y
where x.nr_seq_resultado = y.nr_seq_resultado
and y.nr_prescricao = nr_prescricao_p
and x.nr_seq_prescr = nr_sequencia_p;

return	qt_valor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_result_exam_suep (nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
