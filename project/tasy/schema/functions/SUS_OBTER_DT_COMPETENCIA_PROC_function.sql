-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_dt_competencia_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		timestamp;


BEGIN

select	max(dt_competencia)
into STRICT	dt_retorno_w
from	sus_preco
where	cd_procedimento	= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p
and	dt_competencia	< dt_procedimento_p;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_dt_competencia_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp) FROM PUBLIC;

