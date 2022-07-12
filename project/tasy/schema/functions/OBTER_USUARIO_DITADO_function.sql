-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_ditado ( nr_seq_prescr_proc_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_w         varchar(15);


BEGIN

select	max(nm_usuario)
into STRICT	nm_usuario_w
from	prescr_proc_ditado
where   nr_seq_prescr_proc      = nr_seq_prescr_proc_p;

return       nm_usuario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_ditado ( nr_seq_prescr_proc_p bigint) FROM PUBLIC;

