-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_criar_contas_proc_list ( ds_procedimentos_p text, qt_procedimentos_p text, ie_origem_proced_p text, dt_procedimento_p text, dt_hora_inicio_p text, dt_hora_fim_p text, ie_utiliza_data_p text, nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

		 
ds_procedimentos_w	varchar(255);		
cd_procedimento_w	bigint;
ds_quantidade_w		varchar(255);
qt_procedimento_w	bigint;
ds_origem_proced_w	varchar(255);
ie_origem_proced_w	bigint;	
ie_permite_inserir_w	varchar(1);
dt_procedimento_w	timestamp;
dt_hora_inicio_w	timestamp;
dt_hora_fim_w		timestamp;
dt_procedimento_ww	varchar(255);
dt_hora_inicio_ww	varchar(255);
dt_hora_fim_ww		varchar(255);
ds_utiliza_data_w	varchar(255);
ie_utiliza_data_w	varchar(2);
dt_inicio_aux_w			varchar(255);
dt_fim_aux_w		varchar(255);
dt_procedimento_aux_w	varchar(255);
	
/* 
 A PRINCIPIO, ESTA ROTINA É CHAMADA APENAS DA DIGITAÇÃO DE SP/SADT E DA DIGITAÇÃO DE INTERNACÕES. 
*/
 
		 

BEGIN 
 
ds_procedimentos_w 	:= ds_procedimentos_p;
ds_quantidade_w 	:= qt_procedimentos_p;
ds_origem_proced_w 	:= ie_origem_proced_p;
dt_procedimento_ww	:= dt_procedimento_p;
dt_hora_inicio_ww	:= dt_hora_inicio_p;
dt_hora_fim_ww		:= dt_hora_fim_p;
ds_utiliza_data_w	:= ie_utiliza_data_p;
				 
while(position(',' in ds_procedimentos_w) <> 0) loop 
	begin		 
	 
	--obtem-se a primeira regra 
	cd_procedimento_w 	:= substr(ds_procedimentos_w,1,position(',' in ds_procedimentos_w)-1);
	--obtem-se a quantidade do procedimento.	 
	qt_procedimento_w 	:= substr(ds_quantidade_w,1,position(',' in ds_quantidade_w)-1);	
	--obtem-se a origem do procedimento 
	ie_origem_proced_w 	:= substr(ds_origem_proced_w,1,position(',' in ds_origem_proced_w)-1);		
/* 
	dt_hora_inicio_w 	:= to_date(substr(dt_hora_inicio_ww,1,instr(dt_hora_inicio_ww,',')-1),'hh:mi:ss'); 
	 
	dt_hora_fim_w	 	:= to_date(substr(dt_hora_fim_ww,1,instr(dt_hora_fim_ww,',')-1),'hh:mi:ss');*/
 
	dt_procedimento_aux_w 	:= substr(dt_procedimento_ww,1,position(',' in dt_procedimento_ww)-1);
	 
	dt_inicio_aux_w	 	:= substr(dt_hora_inicio_ww,1,position(',' in dt_hora_inicio_ww)-1);
	 
	dt_fim_aux_w	:= substr(dt_hora_fim_ww,1,position(',' in dt_hora_fim_ww)-1);
	 
	if (coalesce(trim(both replace(dt_procedimento_aux_w,'/','')),'0')	<> '0') then 
		begin 
		dt_procedimento_w:= to_date(dt_procedimento_aux_w);
		exception 
		when others then 
			dt_procedimento_w := null;
		end;
	else 
		dt_procedimento_w := null;
	end if;
	 
	if (coalesce(trim(both replace(dt_inicio_aux_w,':','')),'0')	 <> '0') then 
		begin 
		dt_hora_inicio_w:= to_date(dt_inicio_aux_w,'hh24:mi:ss');
		exception 
		when others then 
			dt_hora_inicio_w := null;
		end;
	else 
		dt_hora_inicio_w := null;
	end if;
	 
	if (coalesce(trim(both replace(dt_fim_aux_w,':','')),'0')	 <> '0') then 
		begin 
		dt_hora_fim_w := to_date(dt_fim_aux_w,'hh24:mi:ss');
		exception 
		when others then 
			dt_hora_fim_w := null;
		end;
	else 
		dt_hora_fim_w := null;
	end if;
	 
	ie_utiliza_data_w 	:= substr(ds_utiliza_data_w,1,position(',' in ds_utiliza_data_w)-1);
	--remove-se o procedimento do conjunto 
	ds_procedimentos_w 	:= substr(ds_procedimentos_w,position(',' in ds_procedimentos_w)+1,255);
	--remove-se a quantidade do conjunto 
	ds_quantidade_w	 	:= substr(ds_quantidade_w,position(',' in ds_quantidade_w)+1,255);	
	--remove-se a origem do proced do conjunto 
	ds_origem_proced_w  	:= substr(ds_origem_proced_w,position(',' in ds_origem_proced_w)+1,255);	
 
	dt_procedimento_ww  	:= substr(dt_procedimento_ww,position(',' in dt_procedimento_ww)+1,255);	
	 
	dt_hora_inicio_ww  	:= substr(dt_hora_inicio_ww,position(',' in dt_hora_inicio_ww)+1,255);	
	 
	dt_hora_fim_ww  	:= substr(dt_hora_fim_ww,position(',' in dt_hora_fim_ww)+1,255);	
	 
	ds_utiliza_data_w 	:= substr(ds_utiliza_data_w,position(',' in ds_utiliza_data_w)+1,255);
 
	if (coalesce(ie_utiliza_data_w,'N') = 'N') then 
		dt_procedimento_w 	:= null;
		dt_hora_inicio_w	:= null;
		dt_hora_fim_w		:= null;
	end if;
	ie_permite_inserir_w  := pls_verifica_proc_existente(	nm_usuario_p, cd_estabelecimento_p, nr_seq_conta_p, cd_procedimento_w, ie_origem_proced_w, qt_procedimento_w, dt_procedimento_w, dt_hora_inicio_w, dt_hora_fim_w, ie_permite_inserir_w );
	/* SE NAO EXISTIR REGISTRO DE PROCEDIMENTO COM MESMA QUANTIDADE , ENTAO INSERE O PROCEDIMENTO QUE ESTA INFORMADO NO FiLTRO DAS DIGITAÇÕES*/
 
	if (ie_permite_inserir_w = 'S') then		 
		CALL pls_gerar_conta_proc_consulta(	nr_seq_conta_p, cd_procedimento_w, ie_origem_proced_w, 
						qt_procedimento_w, nm_usuario_p, cd_estabelecimento_p, 
						dt_procedimento_w,dt_hora_inicio_w, dt_hora_fim_w);
	end if;
	 
	end;	
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_criar_contas_proc_list ( ds_procedimentos_p text, qt_procedimentos_p text, ie_origem_proced_p text, dt_procedimento_p text, dt_hora_inicio_p text, dt_hora_fim_p text, ie_utiliza_data_p text, nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
