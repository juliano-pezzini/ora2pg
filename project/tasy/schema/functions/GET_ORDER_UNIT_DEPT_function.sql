-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_order_unit_dept (nr_sequencia_p cpoe_procedimento.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_departamento_medico_w departamento_medico.ds_departamento%type;


BEGIN

	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		select  b.ds_departamento into STRICT ds_departamento_medico_w
		from cpoe_order_unit a,
		departamento_medico  b,
		cpoe_procedimento c
		where a.nr_sequencia= c.nr_seq_cpoe_order_unit
		and a.cd_departamento_med = b.cd_departamento
		and c.nr_sequencia= nr_sequencia_p;
	end if;

return ds_departamento_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_order_unit_dept (nr_sequencia_p cpoe_procedimento.nr_sequencia%type) FROM PUBLIC;

