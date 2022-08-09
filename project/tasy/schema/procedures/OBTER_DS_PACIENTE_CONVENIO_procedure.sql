-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_ds_paciente_convenio ( nr_seq_autorizacao_p bigint, nm_usuario_p text, nm_paciente_prescr_p INOUT text, cd_convenio_p INOUT bigint) AS $body$
DECLARE

nm_paciente_prescr_w	varchar(100);				
cd_convenio_w		integer;	

BEGIN 
if (nr_seq_autorizacao_p IS NOT NULL AND nr_seq_autorizacao_p::text <> '') then 
	begin 
	select 	substr(obter_pessoa_atendimento(nr_atendimento, 'N'),1,255) 
	into STRICT 	nm_paciente_prescr_w 
	from  	autorizacao_convenio 
	where 	nr_sequencia = nr_seq_autorizacao_p;
 
	select 	cd_convenio 
	into STRICT	cd_convenio_w 
	from  	autorizacao_convenio 
	where 	nr_sequencia = nr_seq_autorizacao_p;
	end;
end if;
nm_paciente_prescr_p	:= nm_paciente_prescr_w;
cd_convenio_p		:= cd_convenio_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_ds_paciente_convenio ( nr_seq_autorizacao_p bigint, nm_usuario_p text, nm_paciente_prescr_p INOUT text, cd_convenio_p INOUT bigint) FROM PUBLIC;
