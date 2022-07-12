-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_clinica_pac_alteracao (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


ie_clinica_w	integer;


BEGIN

select 	max(a.ie_clinica)
into STRICT	ie_clinica_w
from	atend_paciente_alteracao a
where	a.nr_atendimento = nr_atendimento_p
and	a.dt_atualizacao = ( SELECT max(e.dt_atualizacao)
			   from	  atend_paciente_alteracao e
			   where  e.nr_atendimento = a.nr_atendimento);


return	ie_clinica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_clinica_pac_alteracao (nr_atendimento_p bigint) FROM PUBLIC;
