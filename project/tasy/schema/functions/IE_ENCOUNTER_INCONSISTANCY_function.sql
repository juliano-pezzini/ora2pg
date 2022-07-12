-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ie_encounter_inconsistancy (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_msg_w		varchar(200) := '';
nr_classif_x_count_w	bigint := '';


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')	then

	select 	count(*)
	into STRICT 	nr_classif_x_count_w
	from 	enc_x_classif_x_category a
	where	a.ie_encounter_type =
			(SELECT	max(b.ie_tipo_atendimento)
			from	atendimento_paciente b
			where	nr_atendimento = nr_atendimento_p)
	and	a.ie_situacao = 'A';


	if (nr_classif_x_count_w > 0)	then
		select	CASE WHEN count(*)=0 THEN  substr(obter_desc_expressao(954798), 0, 200)  ELSE '' END 
		into STRICT    ds_msg_w
		FROM enc_x_classif_x_category b, atendimento_paciente a
LEFT OUTER JOIN atend_categoria_convenio c ON (a.nr_atendimento = c.nr_atendimento)
WHERE a.nr_atendimento		= nr_atendimento_p and a.ie_tipo_atendimento		= b.ie_encounter_type and (coalesce(b.ie_classification::text, '') = '' or a.nr_seq_classificacao = b.ie_classification)  and (coalesce(b.ie_category::text, '') = '' or c.nr_seq_patient_category = b.ie_category) and b.ie_situacao 			= 'A';

	end if;
end if;
return	ds_msg_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ie_encounter_inconsistancy (nr_atendimento_p bigint) FROM PUBLIC;

