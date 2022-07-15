-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_proc_interno_futuro_js ( nr_seq_interno_p bigint, nr_atendimento_p bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, ds_procedimento_p INOUT text) AS $body$
DECLARE

 
nr_prescricao_w		smallint;
nr_interno_conta_w	smallint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_setor_item_w		bigint;
dt_conta_w		timestamp;
ds_procedimento_w	varchar(255);


BEGIN 
 
if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '')then 
	begin 
	 
	SELECT * FROM obter_proc_tab_interno(nr_seq_interno_p, nr_prescricao_w, nr_atendimento_p, nr_interno_conta_w, cd_procedimento_w, ie_origem_proced_w, cd_setor_item_w, dt_conta_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	 
	ds_procedimento_w	:= substr(obter_exame_agenda(0,0,nr_seq_interno_p),1,240);
	 
	end;
end if;
 
cd_procedimento_p	:= cd_procedimento_w;
ie_origem_proced_p	:= ie_origem_proced_w;
ds_procedimento_p	:= ds_procedimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_proc_interno_futuro_js ( nr_seq_interno_p bigint, nr_atendimento_p bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, ds_procedimento_p INOUT text) FROM PUBLIC;

