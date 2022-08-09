-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_prot_cirurgia (nr_cirurgia_p bigint, nr_seq_pepo_p bigint, cd_medico_anestesista_p INOUT bigint, nm_medico_anestesista_p INOUT text, ds_procedimento_p INOUT text, nr_seq_proc_interno_p INOUT bigint) AS $body$
BEGIN
 
if (coalesce(nr_cirurgia_p,0) > 0) then 
	select max(cd_medico_anestesista), 
		max(substr(obter_nome_pf(cd_medico_anestesista),1,255)), 
		max(substr(obter_exame_agenda(cd_procedimento_princ, ie_origem_proced, nr_seq_proc_interno),1,240)), 
		max(nr_seq_proc_interno) 
	into STRICT	cd_medico_anestesista_p, 
		nm_medico_anestesista_p, 
		ds_procedimento_p, 
		nr_seq_proc_interno_p 
	from 	cirurgia 
	where  nr_cirurgia = nr_cirurgia_p;
		 
 
elsif (coalesce(nr_seq_pepo_p,0) > 0) then 
	select max(cd_medico_anestesista), 
		max(substr(obter_nome_pf(cd_medico_anestesista),1,255)), 
		max(substr(obter_exame_agenda(cd_procedimento_princ, ie_origem_proced, nr_seq_proc_interno),1,240)), 
		max(nr_seq_proc_interno) 
	into STRICT	cd_medico_anestesista_p, 
		nm_medico_anestesista_p, 
		ds_procedimento_p, 
		nr_seq_proc_interno_p 
	from 	cirurgia 
	where  nr_seq_pepo = nr_seq_pepo_p;
end if;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_prot_cirurgia (nr_cirurgia_p bigint, nr_seq_pepo_p bigint, cd_medico_anestesista_p INOUT bigint, nm_medico_anestesista_p INOUT text, ds_procedimento_p INOUT text, nr_seq_proc_interno_p INOUT bigint) FROM PUBLIC;
