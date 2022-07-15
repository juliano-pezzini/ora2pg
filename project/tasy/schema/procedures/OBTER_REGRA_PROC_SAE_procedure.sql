-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_proc_sae ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_intervalo_p INOUT text, ds_horario_padrao_p INOUT text, ds_observacao_p INOUT text) AS $body$
DECLARE

ds_observacao_w			varchar(255);
cd_intervalo_w			varchar(10);
ds_horario_padrao_w		varchar(255);
ie_entrou_w				varchar(2) := 'N';
cd_setor_atendimento_w	bigint;

C01 CURSOR FOR 
 
	SELECT	ds_observacao_padr, 
			cd_intervalo, 
			ds_horario_padrao 
	from	pe_interv_regra_setor 
	where	nr_seq_proc 			= nr_sequencia_p 
	and		cd_setor_atendimento 	= cd_setor_atendimento_w;


BEGIN 
 
 
begin 
cd_setor_atendimento_w := obter_setor_Atendimento(nr_atendimento_p);
exception 
when others then 
null;	
end;
 
	 
open C01;
loop 
fetch C01 into	 
	ds_observacao_w, 
	cd_intervalo_w, 
	ds_horario_padrao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
begin 
	ie_entrou_w := 'S';
end;
end loop;
close C01;
 
if (ie_entrou_w = 'N') then 
	begin 
	 
	select	ds_observacao_padr, 
			cd_intervalo, 
			ds_horario_padrao 
	into STRICT	ds_observacao_w, 
			cd_intervalo_w, 
			ds_horario_padrao_w	 
	from	pe_procedimento 
	where	nr_sequencia 			= nr_sequencia_p;
	exception 
		when no_data_found then 
		null;
	end	;
end if;
 
 
cd_intervalo_p 		:= cd_intervalo_w;
ds_horario_padrao_p	:= ds_horario_padrao_w;
ds_observacao_p		:= ds_observacao_w;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_proc_sae ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_intervalo_p INOUT text, ds_horario_padrao_p INOUT text, ds_observacao_p INOUT text) FROM PUBLIC;

