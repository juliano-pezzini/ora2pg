-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_result_laborat ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w	varchar(2);


BEGIN

select	max(ie_status)
into STRICT	ie_status_w
from	result_laboratorio
where	nr_prescricao  = nr_prescricao_p
and	nr_seq_prescricao = nr_seq_prescr_p;

return	ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_result_laborat ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

