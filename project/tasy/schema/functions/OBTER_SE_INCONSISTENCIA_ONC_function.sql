-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_inconsistencia_onc (nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

select 	coalesce(max('S'),'N')
into STRICT	ie_retorno_w
from	paciente_atendimento_erro
where 	nr_seq_paciente	= nr_seq_paciente_p;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_inconsistencia_onc (nr_seq_paciente_p bigint) FROM PUBLIC;

