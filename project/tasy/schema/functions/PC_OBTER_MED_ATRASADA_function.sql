-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pc_obter_med_atrasada ( nr_atendimento_p atendimento_paciente.nr_atendimento%type) RETURNS integer AS $body$
DECLARE


qt_item_w integer;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 

	select		count(distinct cd_item)
	into STRICT    	qt_item_w
	from		adep_medic_pend_v
	where		nr_atendimento = nr_atendimento_p
	and			ie_tipo_item in ('M', 'ME', 'MAP')
	and 		dt_horario <= clock_timestamp() - interval '30 days'/1440;
	
end if;

return qt_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pc_obter_med_atrasada ( nr_atendimento_p atendimento_paciente.nr_atendimento%type) FROM PUBLIC;
