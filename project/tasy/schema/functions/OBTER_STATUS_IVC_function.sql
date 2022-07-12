-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_ivc ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select	coalesce(max('S'), 'N')
into STRICT	ds_retorno_w
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and		nr_sequencia = nr_seq_procedimento_p
and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');

if (ds_retorno_w = 'S') then
	return 'S';
end if;

select	coalesce(max(ie_status_ivc),'P')
into STRICT	ds_retorno_w
from	adep_irrigacao
where	nr_prescricao = nr_prescricao_p
and		nr_seq_procedimento = nr_seq_procedimento_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_ivc ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint) FROM PUBLIC;
