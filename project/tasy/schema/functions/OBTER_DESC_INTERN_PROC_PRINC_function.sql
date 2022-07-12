-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_intern_proc_princ ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255) := null;
ie_tipo_atendimento_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;


BEGIN

select	ie_tipo_atendimento
into STRICT	ie_tipo_atendimento_w
from	atendimento_paciente
where	nr_atendimento		= nr_atendimento_p;

SELECT * FROM obter_proc_princ_interno(nr_atendimento_p, ie_tipo_atendimento_w, cd_procedimento_w, ie_origem_proced_w, 0) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
select	max(ds_proc_interno)
into STRICT	ds_retorno_w
from	procedimento
where	cd_procedimento		= cd_procedimento_w
and	ie_origem_proced	= ie_origem_proced_w;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_intern_proc_princ ( nr_atendimento_p bigint) FROM PUBLIC;

