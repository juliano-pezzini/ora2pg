-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_nr_seq_mot_desap (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_motivo_desaprov_w		bigint;


BEGIN

select 	max(nr_seq_motivo_desaprov)
into STRICT	nr_seq_motivo_desaprov_w
from 	prescr_procedimento
where 	nr_prescricao  = nr_prescricao_p
and	nr_sequencia   = nr_seq_prescr_p;

return	nr_seq_motivo_desaprov_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_nr_seq_mot_desap (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;
