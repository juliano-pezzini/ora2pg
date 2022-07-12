-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_lote_exame ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_lote_w	lab_lote_exame.nr_sequencia%type;


BEGIN

select	max(nr_seq_lote)
into STRICT	nr_seq_lote_w
from	lab_lote_exame_item
where	nr_prescricao = nr_prescricao_p
and	nr_seq_prescr = nr_seq_prescr_p;

return	nr_seq_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_lote_exame ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

