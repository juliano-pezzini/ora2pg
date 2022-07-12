-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_disp_lib_evento ( nr_seq_dispositivo_p bigint, nr_seq_evento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1);
nr_seq_evento_dist_w	bigint;


BEGIN

Select	nr_seq_evento
into STRICT	nr_seq_evento_dist_w
from	qua_evento_paciente
where	nr_sequencia =  nr_seq_evento_p;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	dispositivo_evento
where	nr_seq_dispositivo = nr_seq_dispositivo_p
and		nr_seq_evento = nr_seq_evento_dist_w;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_disp_lib_evento ( nr_seq_dispositivo_p bigint, nr_seq_evento_p bigint) FROM PUBLIC;
