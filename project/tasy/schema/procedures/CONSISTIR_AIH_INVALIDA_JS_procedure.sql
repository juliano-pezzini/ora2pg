-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_aih_invalida_js ( nr_aih_p bigint, nm_usuario_p text, nr_atendimento_p bigint, cd_estabelecimento_p bigint, cd_medico_responsavel_p INOUT text, cd_procedimento_solic_p INOUT bigint, ie_origem_proced_p INOUT bigint, dt_emissao_p INOUT timestamp, ds_msg_erro_p INOUT text) AS $body$
DECLARE

 
nr_aih_inicial_w	bigint;
nr_aih_final_w		bigint;
ie_digito_w		varchar(1);
ds_msg_erro_w		varchar(255);
ds_continua_exec_w	varchar(1)	:= 'S';
cd_medico_responsavel_w	varchar(10);
cd_procedimento_solic_w	bigint;
ie_origem_proced_w	bigint;
dt_emissao_w		timestamp;
ie_var_consiste_aih_w	varchar(1);


BEGIN 
 
ie_var_consiste_aih_w := Obter_param_Usuario(916, 184, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_var_consiste_aih_w);
 
if (nr_aih_p IS NOT NULL AND nr_aih_p::text <> '')then 
	begin 
	 
	select 	max(coalesce(nr_aih_inicial,0)), 
		max(coalesce(nr_aih_final,9999999999999)) 
	into STRICT	nr_aih_inicial_w, 
		nr_aih_final_w 
	from 	sus_parametros 
	where 	cd_estabelecimento = cd_estabelecimento_p;
	 
	if (nr_aih_p < nr_aih_inicial_w)and (nr_aih_p > nr_aih_final_w)then 
		begin 
		 
		ds_msg_erro_w		:= obter_texto_tasy(73984, 1);
		ds_continua_exec_w	:= 'N';
		 
		end;
	end if;
	 
	if (ds_continua_exec_w = 'S')then 
		begin 
		 
		ie_digito_w	:= consistir_digito('AIH', nr_aih_p);
	 
		if (ie_digito_w = 'N')and (ie_var_consiste_aih_w = 'S')then 
			begin 
		 
			ds_msg_erro_w		:= obter_texto_tasy(74015, 1);
			ds_continua_exec_w	:= 'N';
		 
			end;
		end if;
		 
		end;
	end if;
	 
	if (ds_continua_exec_w = 'S')then 
		begin 
		 
		 
		select max(cd_medico_responsavel), 
			max(cd_procedimento_solic), 
			max(ie_origem_proced), 
			max(dt_emissao) 
		into STRICT	cd_medico_responsavel_w, 
			cd_procedimento_solic_w, 
			ie_origem_proced_w, 
			dt_emissao_w 
		from  sus_laudo_paciente 
		where  ie_tipo_laudo_sus = 0 
		and   nr_atendimento  = nr_atendimento_p  LIMIT 1;
		 
				 
		end;
	end if;
	 
	end;
end if;
 
cd_medico_responsavel_p	:= cd_medico_responsavel_w;
cd_procedimento_solic_p := cd_procedimento_solic_w;
ie_origem_proced_p	:= ie_origem_proced_w;
dt_emissao_p		:= dt_emissao_w;
ds_msg_erro_p		:= ds_msg_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_aih_invalida_js ( nr_aih_p bigint, nm_usuario_p text, nr_atendimento_p bigint, cd_estabelecimento_p bigint, cd_medico_responsavel_p INOUT text, cd_procedimento_solic_p INOUT bigint, ie_origem_proced_p INOUT bigint, dt_emissao_p INOUT timestamp, ds_msg_erro_p INOUT text) FROM PUBLIC;

