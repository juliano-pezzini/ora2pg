-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_tipo_diagnostico (nr_atendimento_p bigint, dt_diagnostico_p timestamp) RETURNS bigint AS $body$
DECLARE


ie_tipo_diagnostico_w	bigint;


BEGIN

select	ie_tipo_diagnostico
into STRICT	ie_tipo_diagnostico_w
from	diagnostico_medico
where	nr_atendimento	= nr_atendimento_p
and	dt_diagnostico	= dt_diagnostico_p;

return	ie_tipo_diagnostico_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_tipo_diagnostico (nr_atendimento_p bigint, dt_diagnostico_p timestamp) FROM PUBLIC;
