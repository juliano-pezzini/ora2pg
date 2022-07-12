-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_diagnosis_status ( cd_diagnostico_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w		varchar(5)	:= '';


BEGIN

if (cd_diagnostico_p IS NOT NULL AND cd_diagnostico_p::text <> '' AND nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

select max(ie_status)
into STRICT ie_status_w
from	lista_problema_pac
where cd_doenca = cd_diagnostico_p
and nr_atendimento = nr_atendimento_p;

end if;

return ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_diagnosis_status ( cd_diagnostico_p text, nr_atendimento_p bigint) FROM PUBLIC;

