-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_status_oftalmo_atend (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_status_w	oft_consulta.nr_seq_status%type;
dt_consulta_w	oft_consulta.dt_consulta%type;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	SELECT 	MAX(dt_consulta)
	into STRICT	dt_consulta_w
	FROM    oft_consulta
	WHERE   nr_atendimento = nr_atendimento_p
	and		coalesce(dt_cancelamento::text, '') = '';
	
end if;
	
if (dt_consulta_w IS NOT NULL AND dt_consulta_w::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')  then
	SELECT MAX(nr_seq_status)
	into STRICT   nr_seq_status_w
	FROM   oft_consulta
	WHERE  nr_atendimento = nr_atendimento_p
	and		coalesce(dt_cancelamento::text, '') = ''
	AND    dt_consulta = dt_consulta_w;
	
end if;

return nr_seq_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_status_oftalmo_atend (nr_atendimento_p bigint) FROM PUBLIC;
