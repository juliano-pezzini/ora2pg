-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_pep_patiente_med (cd_material_p paciente_protocolo_medic.cd_material%type, cd_pessoa_fisica_p paciente_setor.cd_pessoa_fisica%type) RETURNS bigint AS $body$
DECLARE

count_patient_med_w bigint;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '' AND cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then		
	select count(a.nr_seq_paciente)
	into STRICT count_patient_med_w
	from paciente_protocolo_medic a
	inner join paciente_setor b
	on a.nr_seq_paciente = b.nr_seq_paciente
	where a.ie_medicacao_paciente = 'S'
	and b.cd_pessoa_fisica = cd_pessoa_fisica_p
	and a.cd_material = cd_material_p;
end if;

return count_patient_med_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_pep_patiente_med (cd_material_p paciente_protocolo_medic.cd_material%type, cd_pessoa_fisica_p paciente_setor.cd_pessoa_fisica%type) FROM PUBLIC;

