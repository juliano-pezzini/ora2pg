-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_atend_pend_reval (nr_atendimento_p prescr_medica.nr_atendimento%type) RETURNS varchar AS $body$
DECLARE


ie_pendente_w		varchar(1);

c01 CURSOR FOR
	SELECT  distinct
			b.nr_seq_cpoe,
			b.ie_tipo_item,
			a.nr_atendimento
	from    prescr_medica a,
			gpt_revalidation_events b
	where   a.nr_atendimento = b.nr_atendimento
	and 	clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr
	and 	b.dt_validacao < clock_timestamp()
	and     a.nr_atendimento = nr_atendimento_p;

BEGIN

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	
		ie_pendente_w := 'N';
		
		for r_c01_w in c01
		loop
			if (gpt_obter_se_pend_reval(r_c01_w.nr_seq_cpoe, r_c01_w.ie_tipo_item, r_c01_w.nr_atendimento) = 'S') then
				ie_pendente_w := 'S';
				exit;
			end if;
		end loop;
		
	end if;
	
	return ie_pendente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_atend_pend_reval (nr_atendimento_p prescr_medica.nr_atendimento%type) FROM PUBLIC;
