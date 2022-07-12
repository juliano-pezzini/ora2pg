-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pa_obter_sequencia_peca (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(10);

BEGIN

select	coalesce(max(nr_sequencia_princ),0) + 1
into STRICT	ds_retorno_w
from	prescr_proc_peca
where	nr_prescricao = nr_prescricao_p
and	nr_seq_prescr = nr_seq_prescr_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pa_obter_sequencia_peca (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

