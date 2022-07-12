-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_proc_rotina (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_informacao_w		varchar(2000);


BEGIN

select	max(ds_prescricao)
into STRICT	ds_informacao_w
from	procedimento_rotina
where	nr_sequencia = nr_sequencia_p;

return	ds_informacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_proc_rotina (nr_sequencia_p bigint) FROM PUBLIC;
