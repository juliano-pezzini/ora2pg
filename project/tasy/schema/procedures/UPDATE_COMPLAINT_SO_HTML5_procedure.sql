-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_complaint_so_html5 (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, nm_usuario_p man_ordem_servico.nm_usuario%type) AS $body$
DECLARE

										
ie_security_event_w	varchar(1);
ie_harmed_event_w	varchar(1);
ie_unacceptable_w	varchar(1);
ie_medical_device_w	reg_customer_requirement.ie_clinico%type;
ie_assessment_w		man_ordem_servico.ie_complaint%type;

ie_probability_harm_w	man_ordem_servico.ie_probability_harm%type;
ie_severity_harm_w		man_ordem_servico.ie_severity_harm%type;
ie_plataforma_w			man_ordem_servico.ie_plataforma%type;


BEGIN

if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then
	select	case when ie_potencial_privacy = 'S' or ie_potencial_privacy = 'S' then 'S' else 'N' end,
			case when ie_potential_harmed = 'S' or ie_potencial_safety = 'S' then 'S' else 'N' end,
			case when man_obter_regra_determ_risco(ie_probability_harm, ie_severity_harm) = 'I' then 'S' else 'N' end,
			coalesce(man_obter_se_md(nr_customer_requirement), 'N'),
			ie_plataforma
	into STRICT	ie_security_event_w,
			ie_harmed_event_w,
			ie_unacceptable_w,
			ie_medical_device_w,
			ie_plataforma_w
	from	man_ordem_servico
	where	nr_sequencia	= nr_seq_ordem_serv_p;

	if (ie_plataforma_w = 'H') then
		ie_assessment_w	:= case when ((ie_security_event_w = 'S') or (ie_harmed_event_w = 'S') or (ie_unacceptable_w = 'S') or (ie_medical_device_w = 'S')) then 'S' else 'N' end;
		
		update	man_ordem_servico
		set		ie_complaint	= ie_assessment_w
		where	nr_sequencia	= nr_seq_ordem_serv_p;

		commit;
		
		CALL generate_history_regulatory(nr_seq_ordem_serv_p, nm_usuario_p, 'N', 'N', 'S', 'N');
	end if;
		
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_complaint_so_html5 (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, nm_usuario_p man_ordem_servico.nm_usuario%type) FROM PUBLIC;
