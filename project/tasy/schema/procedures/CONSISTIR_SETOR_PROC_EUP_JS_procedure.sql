-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_setor_proc_eup_js ( cd_setor_atendimento_p bigint, dt_parametro_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, ie_opcao_p text, nr_atendimento_atend_p bigint, cd_convenio_p bigint, cd_plano_p text, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_categoria_p text, cd_setor_entrega_prescr_p bigint, cd_medico_p text, ie_tipo_convenio_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, ds_msg_erro_p INOUT text, ds_msg_aviso_p INOUT text) AS $body$
DECLARE

 
ds_msg_erro_w			varchar(255) 	:= '';
ds_msg_aviso_w			varchar(2000)	:= '';
ie_continua_exec_w		varchar(1)	:= 'S';
vl_parametro_w			varchar(1);
ds_retorno_w			varchar(2000);
ds_erro_w 			varchar(255);
ie_regra_w			varchar(1);
nr_seq_regra_w			bigint;
ds_observacao_w			varchar(255);
ie_situacao_w			varchar(1);
ie_consiste_proced_atend_w	varchar(1);
cd_pessoa_atend_w		varchar(10);
ie_glosa_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;			

BEGIN 
 
if (coalesce(cd_setor_atendimento_p::text, '') = '')then 
	begin 
	 
	ds_msg_erro_w 		:= Wheb_mensagem_pck.get_texto(306468, null); -- O sistema não gerou o setor de atendimento.\n Favor informar o setor. 
	ie_continua_exec_w	:= 'N';
	 
	end;
end if;
 
if (ie_continua_exec_w = 'S')then 
	begin 
	 
	vl_parametro_w := obter_param_usuario(cd_funcao_p, 165, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	 
	if (vl_parametro_w <> 'N')then 
		begin 
		 
		ds_retorno_w := sus_consiste_fpo(dt_parametro_p, cd_procedimento_p, ie_origem_proced_p, qt_procedimento_p, nr_atendimento_p, cd_estabelecimento_p, ie_tipo_atendimento_p, ie_opcao_p, ds_retorno_w);
		 
		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')then 
			begin 
			 
			ds_msg_aviso_w	:= ds_retorno_w;
			 
			end;
		end if;
		 
		end;
	end if;
	 
	vl_parametro_w := obter_param_usuario(cd_funcao_p, 212, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	 
	if (vl_parametro_w = 'S')then 
		begin 
		 
		select	max(cd_pessoa_fisica) 
		into STRICT	cd_pessoa_atend_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_atend_p;
		 
		SELECT * FROM consiste_plano_convenio(nr_atendimento_atend_p, cd_convenio_p, cd_procedimento_p, ie_origem_proced_p, clock_timestamp(), qt_procedimento_p, ie_tipo_atendimento_p, cd_plano_p, '', ds_erro_w, cd_setor_atendimento_p, nr_seq_exame_p, ie_regra_w, null, nr_seq_regra_w, nr_seq_proc_interno_p, cd_categoria_p, cd_estabelecimento_p, cd_setor_entrega_prescr_p, cd_medico_p, cd_pessoa_atend_w, ie_glosa_w, nr_seq_regra_preco_W) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, nr_seq_regra_preco_W;
		 
		vl_parametro_w := obter_param_usuario(cd_funcao_p, 415, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
		 
		if (vl_parametro_w = 'S')then 
			begin 
			 
			select 	max(ds_observacao) 
			into STRICT	ds_observacao_w 
			from 	regra_convenio_plano 
			where 	nr_sequencia = nr_seq_regra_w;
			 
			ds_observacao_w	:= 'Obs: '|| ds_observacao_w;
			 
			end;
		end if;
		 
		if ((ie_regra_w)::numeric  in (1,2,5))then 
			begin 
			 
			ds_msg_erro_w	:= Wheb_mensagem_pck.get_texto(306470, 'DS_OBSERVACAO=' || ds_observacao_w); -- Este procedimento não é autorizado para este convênio! #@DS_OBSERVACAO#@ 
			ie_continua_exec_w	:= 'N';
			 
			end;
		end if;
		 
		end;
	end if;
	 
	end;
end if;
 
if (ie_continua_exec_w = 'S')then 
	begin 
	 
	vl_parametro_w := obter_param_usuario(cd_funcao_p, 254, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	 
	if (vl_parametro_w = 'S')then 
		begin 
		 
		select 	max(ie_situacao) 
		into STRICT	ie_situacao_w 
		from 	procedimento 
		where 	cd_procedimento = cd_procedimento_p 
		and  	ie_origem_proced = ie_origem_proced_p;
	 
		if (ie_situacao_w = 'I')then 
			begin 
		 
			ds_msg_erro_w		:= Wheb_mensagem_pck.get_texto(306472, null); -- Este procedimento está inativo. Não pode ser prescrito. Parâmetro [254] 
			ie_continua_exec_w	:= 'N';
		 
			end;
		end if;
		 
		end;
	end if;
	 
	end;
end if;
 
if (ie_continua_exec_w = 'S')then 
	begin 
	 
	if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (cd_setor_atendimento_p <> 0)then 
		begin 
		 
		select max(ie_situacao) 
		into STRICT	ie_situacao_w 
		from 	setor_atendimento 
		where  cd_setor_atendimento = cd_setor_atendimento_p;
	 
		if (ie_situacao_w = 'I')then 
			begin 
		 
			ds_msg_erro_w		:= Wheb_mensagem_pck.get_texto(306475, null); -- O setor está inativo. Deve ser informado um setor ativo 
			ie_continua_exec_w	:= 'N';
		 
			end;
		end if;
		 
		end;
	end if;
	 
	end;
end if;
 
if (ie_continua_exec_w = 'S')then 
	begin 
	 
	vl_parametro_w := obter_param_usuario(cd_funcao_p, 393, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	ie_consiste_proced_atend_w	:= sus_consiste_proced_Atend(nr_atendimento_atend_p, cd_procedimento_p, ie_origem_proced_p);
	 
	if (vl_parametro_w = 'S')and (ie_tipo_convenio_p = 3)and (ie_consiste_proced_atend_w = 'N')then 
		begin 
		 
		ds_msg_erro_w		:= Wheb_mensagem_pck.get_texto(306477, null); -- Procedimento incompatível com o tipo do atendimento. Parâmetro [393] 
		ie_continua_exec_w	:= 'N';
		 
		end;
	end if;
	 
	end;
end if;
 
ds_msg_erro_p	:= ds_msg_erro_w;
ds_msg_aviso_p	:= ds_msg_aviso_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_setor_proc_eup_js ( cd_setor_atendimento_p bigint, dt_parametro_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, ie_opcao_p text, nr_atendimento_atend_p bigint, cd_convenio_p bigint, cd_plano_p text, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_categoria_p text, cd_setor_entrega_prescr_p bigint, cd_medico_p text, ie_tipo_convenio_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, ds_msg_erro_p INOUT text, ds_msg_aviso_p INOUT text) FROM PUBLIC;

