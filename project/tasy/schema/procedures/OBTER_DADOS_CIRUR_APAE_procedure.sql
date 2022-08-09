-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_cirur_apae ( cd_pessoa_fisica_p text, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, cd_medico_p INOUT text, dt_cirurgia_p INOUT timestamp, nr_seq_agenda_p INOUT bigint, nr_cirurgia_p INOUT bigint ) AS $body$
BEGIN
 
select	cd_procedimento, 
	ie_origem_proced, 
	coalesce(cd_medico,'0'), 
	hr_inicio, 
	nr_sequencia, 
	coalesce(nr_cirurgia,0)	 
into STRICT	cd_procedimento_p, 
	ie_origem_proced_p, 
	cd_medico_p, 
	dt_cirurgia_p, 
	nr_seq_agenda_p, 
	nr_cirurgia_p 
from	agenda_paciente 
where	cd_pessoa_fisica		= cd_pessoa_fisica_p 
and	dt_agenda			>= trunc(clock_timestamp(),'dd') 
and	obter_tipo_agenda(cd_agenda)	= 1 
and	dt_agenda	=	(	SELECT	min(dt_agenda) 
					from	agenda_paciente 
					where	cd_pessoa_fisica		= cd_pessoa_fisica_p 
					and	dt_agenda			>= trunc(clock_timestamp(),'dd') 
					and	obter_tipo_agenda(cd_agenda)	= 1);
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_cirur_apae ( cd_pessoa_fisica_p text, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, cd_medico_p INOUT text, dt_cirurgia_p INOUT timestamp, nr_seq_agenda_p INOUT bigint, nr_cirurgia_p INOUT bigint ) FROM PUBLIC;
