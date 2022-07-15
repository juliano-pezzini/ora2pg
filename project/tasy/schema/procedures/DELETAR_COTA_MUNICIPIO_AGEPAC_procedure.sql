-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_cota_municipio_agepac ( nr_seq_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_medico_exec_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_novo_registro_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_agenda_w		timestamp;
cd_municipio_ibge_w	varchar(06);
ie_novo_w		varchar(01);


BEGIN 
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_novo_w 
from	agenda_paciente 
where	nr_sequencia	= nr_seq_agenda_p 
and	coalesce(cd_pessoa_fisica::text, '') = '';
 
select	trunc(dt_agenda_p, 'month'), 
	substr(obter_compl_pf(cd_pessoa_fisica_p, 1,'CDM'),1,6) 
into STRICT	dt_agenda_w, 
	cd_municipio_ibge_w
;
 
if (ie_novo_w = 'S') or (ie_novo_registro_p = 'S') then 
	update	agenda_paciente_cota_munic 
	set	qt_agendada	= (qt_agendada - 1), 
		qt_saldo		= (qt_saldo + 1), 
		dt_atualizacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p 
	where	dt_mes_referencia	= dt_agenda_w 
	and	cd_convenio	= cd_convenio_p 
	/* OS 116811 - Jerusa - Eraldo solicitou a não restrição pelo médico executor 
	and	cd_medico	= cd_medico_exec_p*/
 
	and	cd_municipio_ibge	= cd_municipio_ibge_w 
	and	cd_procedimento	= cd_procedimento_p 
	and	ie_origem_proced	= ie_origem_proced_p 
	and	nr_seq_proc_interno	= nr_seq_proc_interno_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_cota_municipio_agepac ( nr_seq_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_medico_exec_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_novo_registro_p text, nm_usuario_p text) FROM PUBLIC;

