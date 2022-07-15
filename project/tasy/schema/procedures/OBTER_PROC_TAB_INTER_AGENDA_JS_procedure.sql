-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_proc_tab_inter_agenda_js ( nr_seq_interno_p bigint, nr_seq_agenda_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, ds_procedimento_p INOUT text) AS $body$
BEGIN
 
cd_procedimento_p := '';
ie_origem_proced_p := '';
ds_procedimento_p := '';
 
SELECT * FROM Obter_Proc_Tab_Inter_Agenda(nr_seq_interno_p, nr_seq_agenda_p, cd_convenio_p, cd_categoria_p, null, cd_estabelecimento_p, clock_timestamp(), null, null, null, null, ie_tipo_atendimento_p, null, null, null, cd_procedimento_p, ie_origem_proced_p) INTO STRICT cd_procedimento_p, ie_origem_proced_p;
 
if (coalesce(nr_seq_interno_p,0) > 0) then 
	ds_procedimento_p := substr(obter_exame_agenda(0,0,nr_seq_interno_p),1,240);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_proc_tab_inter_agenda_js ( nr_seq_interno_p bigint, nr_seq_agenda_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, ds_procedimento_p INOUT text) FROM PUBLIC;

