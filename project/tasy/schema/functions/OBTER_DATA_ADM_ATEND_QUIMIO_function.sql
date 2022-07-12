-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_adm_atend_quimio ( nr_seq_atendimento_p bigint, nr_seq_material_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w	timestamp;


BEGIN
if	(nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '' AND nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
		select	max(dt_administracao)
		into STRICT	dt_retorno_w
		from	paciente_atend_medic_adm
		where	nr_seq_atendimento	= nr_seq_atendimento_p
		and	nr_seq_material		= nr_seq_material_p;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_adm_atend_quimio ( nr_seq_atendimento_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

