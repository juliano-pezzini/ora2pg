-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_consiste_proc_comp (nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_proc_comp_w	integer	:= 0;
ds_retorno_w	varchar(1);


BEGIN
select	count(*)
into STRICT	qt_proc_comp_w
from	sus_bpa_proc_compativel	b,
	procedimento_paciente	a
where	b.cd_proc_faturado	= cd_procedimento_p
and	b.ie_origem_faturado	= 7
and	a.cd_procedimento	= b.cd_proc_compativel
and	a.ie_origem_proced	= b.ie_origem_compativel
and	a.nr_interno_conta	= nr_interno_conta_p
and	a.nr_atendimento	= nr_atendimento_p;

if (qt_proc_comp_w = 0) then
	ds_retorno_w	:= 'S';
else
	ds_retorno_w	:= 'N';
end if;

return ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_consiste_proc_comp (nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_procedimento_p bigint) FROM PUBLIC;
