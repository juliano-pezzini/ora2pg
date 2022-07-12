-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_tiss_tipo_tabela ( cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE


nr_seq_tabela_w			bigint;


BEGIN

select	max(a.nr_seq_tiss_tipo_tab)
into STRICT	nr_seq_tabela_w
from	procedimento_tiss_tabela	a
where	a.cd_procedimento		= cd_procedimento_p
and	a.ie_origem_proced		= ie_origem_proced_p
and	a.dt_inicio_vigencia		= (	SELECT	max(x.dt_inicio_vigencia)
						from 	procedimento_tiss_tabela x
						where	x.cd_procedimento	= cd_procedimento_p
						and	x.ie_origem_proced	= ie_origem_proced_p
						and	dt_vigencia_p between x.dt_inicio_vigencia and coalesce(x.dt_fim_vigencia, dt_vigencia_p+1));

return	nr_seq_tabela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_tiss_tipo_tabela ( cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_vigencia_p timestamp) FROM PUBLIC;

