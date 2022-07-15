-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_gravar_consist_acesso_java ( nr_atendimento_p bigint, dt_alta_p timestamp, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, ds_maquina_p text, ds_maquina_cliente_p text, nr_seq_justificativa_p bigint, ds_justificativa_p text, cd_paciente_p text, nm_usuario_p text, nr_seq_mensagem_p INOUT bigint, ie_permite_p INOUT text, ds_mensagem_p INOUT text, dt_logon_p timestamp, nr_seq_lib_acesso_p INOUT bigint, ie_lib_acesso_p INOUT text) AS $body$
DECLARE

 
ie_somente_atend_aberto_w 	varchar(1);
nr_seq_acesso_w 		bigint;
ie_permite_w			varchar(1);
nr_seq_mensagem_w 		bigint;
ds_mensagem_w 			varchar(255);
ds_usu_perm_vis_w		varchar(255);
nr_seq_lib_acesso_w		bigint;
ie_lib_acesso_w			varchar(1);


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	begin 
	ie_somente_atend_aberto_w := obter_param_usuario(281, 32, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_somente_atend_aberto_w);
	 
	if (ie_somente_atend_aberto_w = 'S') and 
		((nr_atendimento_p = 0) or (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '')) then 
		begin	 
		nr_seq_acesso_w := gravar_log_acesso_pep(cd_estabelecimento_p, nr_atendimento_p, cd_paciente_p, 'N', nm_usuario_p, ds_maquina_p, ds_maquina_cliente_p, nr_seq_justificativa_p, ds_justificativa_p, dt_logon_p, nr_seq_acesso_w, obter_perfil_ativo, obter_funcao_ativa);
		 
		-- Descrição do texto: "Usuário não tem permissão para visualizar atendimentos do SAME." 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(16999);
		end;
	end if;
 
	SELECT * FROM consistir_acesso_pep(cd_estabelecimento_p, nr_atendimento_p, cd_paciente_p, cd_pessoa_fisica_p, nm_usuario_p, dt_logon_p, ie_permite_w, nr_seq_mensagem_w, nr_seq_lib_acesso_w, ie_lib_acesso_w) INTO STRICT ie_permite_w, nr_seq_mensagem_w, nr_seq_lib_acesso_w, ie_lib_acesso_w;
	 
	if (nr_seq_mensagem_w IS NOT NULL AND nr_seq_mensagem_w::text <> '') then 
		begin 
		ds_mensagem_w := substr(obter_mensagem_acesso(nr_seq_mensagem_w),1,255);
		end;
	end if;
	end;
end if;
 
nr_seq_mensagem_p	:= nr_seq_mensagem_w;
ie_permite_p		:= ie_permite_w;
ds_mensagem_p		:= ds_mensagem_w;
nr_seq_lib_acesso_p   := nr_seq_lib_acesso_w;
ie_lib_acesso_p		:= ie_lib_acesso_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_gravar_consist_acesso_java ( nr_atendimento_p bigint, dt_alta_p timestamp, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, ds_maquina_p text, ds_maquina_cliente_p text, nr_seq_justificativa_p bigint, ds_justificativa_p text, cd_paciente_p text, nm_usuario_p text, nr_seq_mensagem_p INOUT bigint, ie_permite_p INOUT text, ds_mensagem_p INOUT text, dt_logon_p timestamp, nr_seq_lib_acesso_p INOUT bigint, ie_lib_acesso_p INOUT text) FROM PUBLIC;

