-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mipres_total_value ( nr_precricao_p prescr_mipres.nr_prescricao%type ) RETURNS bigint AS $body$
DECLARE


vl_total_w	double precision;


BEGIN

if (nr_precricao_p IS NOT NULL AND nr_precricao_p::text <> '') then
	select	sum(obter_valor_conta(a.nr_interno_conta, 0))
	into STRICT	vl_total_w
	from	conta_paciente a
	where	a.nr_atendimento = (
		SELECT	max(b.nr_atendimento)
		from	prescr_medica b
		where	b.nr_prescricao = nr_precricao_p
	);
end if;

RETURN coalesce(vl_total_w, 0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mipres_total_value ( nr_precricao_p prescr_mipres.nr_prescricao%type ) FROM PUBLIC;
