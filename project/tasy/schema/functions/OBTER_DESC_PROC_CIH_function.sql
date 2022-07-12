-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_proc_cih (cd_procedimento_p bigint, nr_atendimento_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ds_procedimento_w	varchar(255) 	:= '';
cd_convenio_w		bigint;
ie_tipo_atendimento_w	integer;


BEGIN

select 	max(ds_procedimento)
into STRICT	ds_procedimento_w
from	procedimento
where	cd_procedimento	= cd_procedimento_p
  and	ie_origem_proced	in (2,3,7);

return	ds_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_proc_cih (cd_procedimento_p bigint, nr_atendimento_p bigint default 0) FROM PUBLIC;
