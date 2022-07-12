-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_anestesia (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50);
nr_seq_proc_internos_w	bigint;


BEGIN

select	nr_proc_interno
into STRICT	nr_seq_proc_internos_w
from 	procedimento_rotina
where	nr_sequencia = nr_sequencia_p;

select	ie_exige_anestesia
into STRICT	ds_retorno_w
from 	proc_interno
where 	nr_sequencia = nr_seq_proc_internos_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_anestesia (nr_sequencia_p bigint) FROM PUBLIC;
