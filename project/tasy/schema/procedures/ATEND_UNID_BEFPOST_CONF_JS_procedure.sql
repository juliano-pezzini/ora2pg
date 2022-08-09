-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atend_unid_befpost_conf_js ( ie_consist_nome_pac_p text, nr_acompanhante_p bigint, cd_unidade_compl_p text, cd_unidade_basica_p text, ie_consist_num_acomp_p text, cd_senha_p text, nr_doc_convenio_p text, cd_estab_atend_p bigint, cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p bigint, nr_seq_classificacao_p bigint, cd_setor_atendimento_p bigint, cd_plano_p text, ie_clinica_p bigint, cd_empresa_p bigint, cd_procedencia_p bigint, nr_seq_cobertura_p bigint, nr_seq_tipo_acidente_p bigint, cd_tipo_acomodacao_p bigint, cd_medico_resp_p text, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_queixa_p bigint, dt_entrada_p timestamp, ds_msg_setor_lib_abort_p INOUT text, ds_msg_setor_lib_inf_p INOUT text, ds_msg_setor_lib_excl_p INOUT text, ds_msg_exclui_atend_p INOUT text, ds_msg_acomp_abort_p INOUT text, ds_msg_acomp_confi_p INOUT text, ds_msg_nome_pac_abort_p INOUT text, ds_msg_nome_pac_conf_p INOUT text) AS $body$
DECLARE

 
qt_idade_w			integer;					
ie_tipo_conv_ant_w		smallint;
nr_seq_queixa_ant_w		bigint;
ie_bloqueia_atendimento_w	varchar(2)	:= 'L';
ds_mensagem_w			varchar(255)	:= '';	
qt_atend_w			bigint;			
qt_max_acomp_w			smallint;
qt_pac_mesmo_nome_w		integer;				
				 

BEGIN 
 
qt_idade_w := obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A');
 
select	max(a.ie_tipo_convenio) 
into STRICT	ie_tipo_conv_ant_w 
from	atendimento_paciente a 
where	a.nr_atendimento = (SELECT	max(b.nr_atendimento) 
			  from	atendimento_paciente b 
			  where	nr_atendimento < nr_atendimento_p);
			   
select	max(a.nr_seq_queixa) 
into STRICT	nr_seq_queixa_ant_w 
from	atendimento_paciente a 
where	a.nr_atendimento = (SELECT	max(b.nr_atendimento) 
			from	atendimento_paciente b 
			where	nr_atendimento < nr_atendimento_p);
 
SELECT * FROM Obter_Se_Lib_Setor_Conv(cd_estab_atend_p, cd_convenio_p, cd_categoria_p, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_plano_p, nr_seq_classificacao_p, ds_mensagem_w, ie_bloqueia_atendimento_w, ie_clinica_p, cd_empresa_p, cd_procedencia_p, nr_seq_cobertura_p, nr_seq_tipo_acidente_p, cd_tipo_acomodacao_p, cd_medico_resp_p, qt_idade_w, ie_tipo_conv_ant_w, nr_seq_queixa_p, nr_seq_queixa_ant_w, dt_entrada_p, cd_pessoa_fisica_p) INTO STRICT ds_mensagem_w, ie_bloqueia_atendimento_w;
 
if (ie_bloqueia_atendimento_w = 'B') then 
	if (coalesce(ds_mensagem_w::text, '') = '') then 
		ds_msg_setor_lib_abort_p := substr(wheb_mensagem_pck.get_texto(279467, null),1,255);
	else 
		ds_msg_setor_lib_abort_p := ds_mensagem_w;
	end if;
	goto final;
end if;
 
if (ie_bloqueia_atendimento_w = 'T') and 
	((coalesce(nr_doc_convenio_p::text, '') = '') or (coalesce(cd_senha_p::text, '') = '')) then 
	if (coalesce(ds_mensagem_w::text, '') = '') then 
		ds_msg_setor_lib_abort_p := substr(wheb_mensagem_pck.get_texto(279467, null),1,255);
	else 
		ds_msg_setor_lib_abort_p := ds_mensagem_w;
	end if;
	goto final;
end if;
 
if (ie_bloqueia_atendimento_w = 'G') and (coalesce(nr_doc_convenio_p::text, '') = '') then 
	if (coalesce(ds_mensagem_w::text, '') = '') then 
		ds_msg_setor_lib_abort_p := substr(wheb_mensagem_pck.get_texto(279467, null),1,255);
	else 
		ds_msg_setor_lib_abort_p := ds_mensagem_w;
	end if;
	goto final;
end if;
 
if (ie_bloqueia_atendimento_w = 'S') and (coalesce(cd_senha_p::text, '') = '') then 
	if (coalesce(ds_mensagem_w::text, '') = '') then 
		ds_msg_setor_lib_abort_p := substr(wheb_mensagem_pck.get_texto(279467, null),1,255);
	else 
		ds_msg_setor_lib_abort_p := ds_mensagem_w;
	end if;
	goto final;
end if;
 
if (ie_bloqueia_atendimento_w = 'M') and (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then 
    ds_msg_setor_lib_inf_p := ds_mensagem_w;
end if;
	 
if (ie_bloqueia_atendimento_w = 'E') then 
     
	select count(*) 
	into STRICT	qt_atend_w 
	from	atendimento_paciente 
	where  nr_atendimento = nr_atendimento_p;
	 
	if (qt_atend_w > 0) then 
	 
		if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then 
			ds_msg_setor_lib_excl_p := ds_mensagem_w;
		else 
			ds_msg_setor_lib_excl_p := substr(wheb_mensagem_pck.get_texto(279467, null),1,255);
		end if;
		ds_msg_exclui_atend_p := substr(wheb_mensagem_pck.get_texto(212936, null),1,255);
		 
	end if;
end if;	
	 
if (ie_consist_num_acomp_p <> 'N') then 
	select 	max(qt_max_acomp) 
	into STRICT	qt_max_acomp_w 
	from 	unidade_atendimento 
	where 	cd_setor_atendimento = cd_setor_atendimento_p 
	and 	cd_unidade_basica = cd_unidade_basica_p 
	and 	cd_unidade_compl = cd_unidade_compl_p;
	 
	if (ie_consist_num_acomp_p = 'S') and (nr_acompanhante_p > qt_max_acomp_w) then 
		 
		ds_msg_acomp_abort_p := substr(wheb_mensagem_pck.get_texto(215792, 'NR_ACOMPANHANTE='|| qt_max_acomp_w),1,255);
		goto final;
	elsif (ie_consist_num_acomp_p = 'Q') and (nr_acompanhante_p > qt_max_acomp_w) then 
		ds_msg_acomp_confi_p := substr(wheb_mensagem_pck.get_texto(308286, 'NR_ACOMPANHANTE='|| qt_max_acomp_w),1,255);
	end if;
	 
end if;	
 
if (ie_consist_nome_pac_p <> 'S') then 
 
	select 	count(*) 
	into STRICT	qt_pac_mesmo_nome_w 
	from  	unidade_atendimento a 
	where 	cd_setor_atendimento = cd_setor_atendimento_p 
	and  	cd_unidade_basica = cd_unidade_basica_p 
	and  	a.nr_atendimento <> nr_atendimento_p 
	AND	obter_pessoa_atendimento(a.nr_atendimento,'C') <> obter_pessoa_atendimento(nr_atendimento_p,'C') 
	and  	elimina_acentuacao(obter_primeiro_nome(obter_nome_pf_atend(a.nr_atendimento))) = Elimina_acentuacao(obter_primeiro_nome(obter_nome_pf_atend(nr_atendimento_p)));
 
	if (qt_pac_mesmo_nome_w > 0) then 
		if (ie_consist_nome_pac_p = 'N') then 
			ds_msg_nome_pac_abort_p := substr(wheb_mensagem_pck.get_texto(308329, null),1,255);
			goto final;
		elsif (ie_consist_nome_pac_p = 'Q') then 
			ds_msg_nome_pac_conf_p := substr(wheb_mensagem_pck.get_texto(308330, null),1,255);
		end if;	
	end if;
end if;
 
	 
<<final>> 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atend_unid_befpost_conf_js ( ie_consist_nome_pac_p text, nr_acompanhante_p bigint, cd_unidade_compl_p text, cd_unidade_basica_p text, ie_consist_num_acomp_p text, cd_senha_p text, nr_doc_convenio_p text, cd_estab_atend_p bigint, cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p bigint, nr_seq_classificacao_p bigint, cd_setor_atendimento_p bigint, cd_plano_p text, ie_clinica_p bigint, cd_empresa_p bigint, cd_procedencia_p bigint, nr_seq_cobertura_p bigint, nr_seq_tipo_acidente_p bigint, cd_tipo_acomodacao_p bigint, cd_medico_resp_p text, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_queixa_p bigint, dt_entrada_p timestamp, ds_msg_setor_lib_abort_p INOUT text, ds_msg_setor_lib_inf_p INOUT text, ds_msg_setor_lib_excl_p INOUT text, ds_msg_exclui_atend_p INOUT text, ds_msg_acomp_abort_p INOUT text, ds_msg_acomp_confi_p INOUT text, ds_msg_nome_pac_abort_p INOUT text, ds_msg_nome_pac_conf_p INOUT text) FROM PUBLIC;
