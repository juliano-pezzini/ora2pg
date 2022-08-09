-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_special_requests (nm_usuario_p text) AS $body$
DECLARE


ie_pressao_negativa_w	cih_precaucao.ie_pressao_negativa%type;
ie_faz_uso_epi_w		cih_precaucao.ie_faz_uso_epi%type;
ie_detento_w			classif_pessoa.ie_detento%type;
ie_agressivo_w			classif_pessoa.ie_agressivo%type;
dt_inicio_vigencia_w	pessoa_classif.dt_inicio_vigencia%type;
cd_pessoa_w		pessoa_fisica.cd_pessoa_fisica%type;
array_nr_seq_w		dbms_utility.number_array;
c01 CURSOR FOR
SELECT 	nr_sequencia,
	nr_atendimento,
	cd_special_request,
	obter_pessoa_atendimento(nr_atendimento,'C') cd_pessoa_w
from	contingencia_pfcs
where	ie_status = 'N';

BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	for c01_w in c01 loop
	
		if (c01_w.cd_special_request in ('SR108', 'SR109'))then
		
			select  coalesce(max(cih.ie_pressao_negativa),'N'),  coalesce(max(cih.ie_faz_uso_epi),'N')
			into STRICT	ie_pressao_negativa_w, ie_faz_uso_epi_w
			from	cih_precaucao cih
			where	cih.nr_sequencia in (SELECT a.nr_seq_precaucao
									from 	atendimento_precaucao a
									where	a.nr_atendimento = c01_w.nr_atendimento
									and 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
									and		coalesce(a.dt_inativacao::text, '') = ''
									and		coalesce(a.dt_final_precaucao, clock_timestamp() + interval '1 days') > clock_timestamp())
			and 	coalesce(ie_isolamento,'N') = 'S';
						
			if (ie_faz_uso_epi_w = 'N' and c01_w.cd_special_request = 'SR108')then
				CALL pfcs_int_special_request('SR108'||c01_w.nr_atendimento, 'SR108', 'Droplet', 'inactive', clock_timestamp(), c01_w.cd_pessoa_w, c01_w.nr_atendimento, nm_usuario_p, 'N');
			end if;
		
			if (ie_pressao_negativa_w = 'N' and c01_w.cd_special_request = 'SR109')then
				CALL pfcs_int_special_request('SR109'||c01_w.nr_atendimento, 'SR109', 'Negative Pressure', 'inactive', clock_timestamp(), c01_w.cd_pessoa_w, c01_w.nr_atendimento, nm_usuario_p, 'N');
			end if;		
			array_nr_seq_w(array_nr_seq_w.count() + 1) := c01_w.nr_sequencia;

		end if;
		
		if (c01_w.cd_special_request in ('SR117', 'SR139'))then
			
			select  coalesce(max(c.ie_detento), 'N'), coalesce(max(c.ie_agressivo), 'N'), max(coalesce(p.dt_inicio_vigencia,clock_timestamp()))
			into STRICT 	ie_detento_w, ie_agressivo_w, dt_inicio_vigencia_w
			from    pessoa_classif p, classif_pessoa c
			where   c.nr_sequencia = p.nr_seq_classif
			and		p.cd_pessoa_fisica = c01_w.cd_pessoa_w
			and  	coalesce(p.dt_inativacao::text, '') = ''
			and 	coalesce(c.ie_situacao, 'I') = 'A';
			
			if (ie_detento_w = 'N' and c01_w.cd_special_request = 'SR117') then
				CALL pfcs_int_special_request('SR117'||c01_w.nr_atendimento, 'SR117', 'Inmate', 'inactive', dt_inicio_vigencia_w, c01_w.cd_pessoa_w, c01_w.nr_atendimento, nm_usuario_p, 'N');
			end if;
			
			if (ie_agressivo_w = 'N'and c01_w.cd_special_request = 'SR139') then
				CALL pfcs_int_special_request('SR139'||c01_w.nr_atendimento, 'SR139', 'Aggressive/risk behavior', 'inactive', clock_timestamp(), c01_w.cd_pessoa_w, c01_w.nr_atendimento, nm_usuario_p, 'N');
			end if;
			array_nr_seq_w(array_nr_seq_w.count() + 1) := c01_w.nr_sequencia;	
		end if;
		
	end loop;
	
	if (array_nr_seq_w.count() > 0) then
		forall indice in array_nr_seq_w.first .. array_nr_seq_w.last
			update 	contingencia_pfcs c
			set 	  c.ie_status = 'S'
			where 	c.nr_sequencia = array_nr_seq_w(indice);
		
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_special_requests (nm_usuario_p text) FROM PUBLIC;
