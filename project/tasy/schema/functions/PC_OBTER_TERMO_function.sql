-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pc_obter_termo ( nr_atendimento_p pep_pac_ci.nr_atendimento%type, cd_pessoa_fisica_p pep_pac_ci.cd_pessoa_fisica%type, ie_tipo_termo_cir_p pep_pac_ci.ie_tipo_termo_cir%type) RETURNS varchar AS $body$
DECLARE


data_w timestamp;
count_w	integer := 0;
ie_term_w varchar(1) := 'N';
nr_sequencia_w          agenda_paciente.nr_sequencia%type;
ie_tipo_origem_w varchar(1);
nr_cirurgia_w pep_pac_ci.nr_cirurgia%type;
nr_seq_agenda_w         agenda_paciente.nr_sequencia%type;


BEGIN

if ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') or (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')) then	
	
	select 	count(1), min(data), max(ie_tipo_origem), max(nr_sequencia)
	into STRICT  	count_w, data_w, ie_tipo_origem_w, nr_sequencia_w
	from (	
		SELECT 	hr_inicio data,
				'A' ie_tipo_origem, 
				apac.nr_sequencia
		from 	agenda_paciente apac, agenda age 
		where 	apac.cd_agenda = age.cd_agenda
		and 	age.cd_tipo_agenda = 1
		and 	ie_status_agenda <> 'c'
		and 	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '')
		and 	coalesce(apac.nr_cirurgia::text, '') = ''
		and 	hr_inicio > clock_timestamp()
		and (apac.nr_atendimento = nr_atendimento_p or apac.cd_pessoa_fisica = cd_pessoa_fisica_p)
		
union

		SELECT 	dt_inicio_prevista data,
				'C' ie_tipo_origem,
				nr_cirurgia nr_sequencia
		from 	cirurgia 
		where 	coalesce(dt_termino::text, '') = ''
		and 	ie_status_cirurgia not in (3,4)
		and (nr_atendimento = nr_atendimento_p or cd_pessoa_fisica = cd_pessoa_fisica_p)
	) alias14;
	
	if  count_w = 0 then
		ie_term_w := null;	
	else
	

		if ie_tipo_origem_w = 'C' then
			
			select 	max(nr_sequencia) 
			into STRICT 	nr_seq_agenda_w
			from 	agenda_paciente 
			where 	nr_cirurgia = nr_sequencia_w;

			select 	count(*)
			into STRICT 	count_w		
			from 	pep_pac_ci a
			where 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and 	coalesce(a.dt_inativacao::text, '') = ''
			and 	a.ie_tipo_consentimento = 'C'	
			and 	a.ie_tipo_termo_cir = ie_tipo_termo_cir_p
			and (a.nr_seq_agenda = nr_seq_agenda_w  or a.nr_cirurgia = nr_sequencia_w);	
		
			if count_w > 0 then
				ie_term_w := 'S';		
			end if;
			
		end if;
		
		
		if ie_tipo_origem_w = 'A' then
			
			select 	count(*)
			into STRICT 	count_w		
			from 	pep_pac_ci a
			where 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and 	coalesce(a.dt_inativacao::text, '') = ''
			and 	a.ie_tipo_consentimento = 'C'	
			and 	a.ie_tipo_termo_cir = ie_tipo_termo_cir_p
			and 	a.nr_seq_agenda = nr_sequencia_w;
		
			if count_w > 0 then
				ie_term_w := 'S';		
			end if;		
			
		end if;
		
	end if;

	
end if;

return ie_term_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pc_obter_termo ( nr_atendimento_p pep_pac_ci.nr_atendimento%type, cd_pessoa_fisica_p pep_pac_ci.cd_pessoa_fisica%type, ie_tipo_termo_cir_p pep_pac_ci.ie_tipo_termo_cir%type) FROM PUBLIC;

