-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_item_pacote (nr_sequencia_p bigint, ie_proc_mat_p bigint, nr_seq_proc_pacote_p bigint, ie_ratear_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_atendimento_w		bigint;
cd_convenio_w			bigint;
nr_interno_conta_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_proc_pacote_w		bigint;
cd_material_w			bigint;
nr_atend_conta_w		bigint;
ie_inserir_item_zerado_w	varchar(1);
qt_item_conta_w			bigint := 0;
ds_erro_w			varchar(255);
cd_estabelecimento_w		smallint;

 

BEGIN 
 
if (ie_proc_mat_p = 1) then 
 
	select	coalesce(max(nr_atendimento),0), 
		coalesce(max(cd_convenio),0), 
		coalesce(max(nr_interno_conta),0), 
		coalesce(max(cd_procedimento),0), 
		coalesce(max(ie_origem_proced),0) 
	into STRICT	nr_atendimento_w, 
		cd_convenio_w, 
		nr_interno_conta_w, 
		cd_procedimento_w, 
		ie_origem_proced_w 
	from	Procedimento_paciente 
	where	nr_sequencia		= nr_sequencia_p;
	 
	select	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_w;
	 
	ie_inserir_item_zerado_w	:= coalesce(obter_valor_param_usuario(67,630,Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'S');
	 
	if (ie_inserir_item_zerado_w = 'N') then 
		 
		select	sum(qt_procedimento) 
		into STRICT	qt_item_conta_w 
		from	procedimento_paciente 
		where	nr_interno_conta = nr_interno_conta_w 
		and	cd_procedimento = cd_procedimento_w 
		and	ie_origem_proced = ie_origem_proced_w 
		and	coalesce(nr_seq_proc_pacote::text, '') = '';
		 
	end if;
	 
	if (ie_inserir_item_zerado_w = 'S') or (coalesce(qt_item_conta_w,0) <> 0) then 
 
		update	Procedimento_paciente 
		set	nr_seq_proc_pacote	= nr_seq_proc_pacote_p, 
			nm_usuario			= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp() 
		where 	nr_sequencia		= nr_sequencia_p;
		 
		if (philips_param_pck.get_cd_pais = 2) then 
			delete	from propaci_imposto 
			where	nr_seq_propaci = nr_sequencia_p;
		end if;
 
		CALL Gerar_Log_Pacote(nr_interno_conta_w, nr_seq_proc_pacote_p, WHEB_MENSAGEM_PCK.get_texto(278191) || cd_procedimento_w || WHEB_MENSAGEM_PCK.get_texto(278192) || 
						nr_sequencia_p , nm_usuario_p,nr_sequencia_p ,1);
						 
		CALL atualiza_preco_procedimento(nr_sequencia_p, cd_convenio_w, nm_usuario_p);
		 
	else	 
		ds_erro_w	:= nr_sequencia_p;		
	end if;
 
else 
 
	select	coalesce(max(nr_atendimento),0), 
		coalesce(max(cd_convenio),0), 
		coalesce(max(nr_interno_conta),0), 
		coalesce(max(cd_material),0) 
	into STRICT	nr_atendimento_w, 
		cd_convenio_w, 
		nr_interno_conta_w, 
		cd_material_w 
	from	material_atend_paciente 
	where	nr_sequencia		= nr_sequencia_p;
	 
	select	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_w;
	 
	ie_inserir_item_zerado_w	:= coalesce(obter_valor_param_usuario(67,630,Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'S');
	 
	if (ie_inserir_item_zerado_w = 'N') then 
		 
		select	sum(qt_material) 
		into STRICT	qt_item_conta_w 
		from	material_atend_paciente 
		where	nr_interno_conta = nr_interno_conta_w 
		and	cd_material = cd_material_w 
		and	coalesce(nr_seq_proc_pacote::text, '') = '';
		 
	end if;
	 
	if (ie_inserir_item_zerado_w = 'S') or (coalesce(qt_item_conta_w,0) <> 0) then 
 
		update	Material_atend_paciente 
		set	nr_seq_proc_pacote	= nr_seq_proc_pacote_p, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp() 
		where 	nr_sequencia		= nr_sequencia_p;
		 
		if (philips_param_pck.get_cd_pais = 2) then 
			delete	from matpaci_imposto 
			where	nr_seq_matpaci = nr_sequencia_p;
		end if;
 
		CALL Gerar_Log_Pacote(nr_interno_conta_w, nr_seq_proc_pacote_p, WHEB_MENSAGEM_PCK.get_texto(278195) || cd_material_w || WHEB_MENSAGEM_PCK.get_texto(278192) || 
					nr_sequencia_p , nm_usuario_p,nr_sequencia_p,1);
					 
		CALL atualiza_preco_material(nr_sequencia_p, nm_usuario_p);
		 
	else 
		ds_erro_w	:= nr_sequencia_p;
	end if;
 
end if;
 
select 	max(nr_atendimento) 
into STRICT	nr_atend_conta_w 
from 	conta_paciente 
where 	nr_interno_conta = nr_interno_conta_w;
 
if (nr_atend_conta_w <> nr_atendimento_w) then -- Rn 
	nr_atendimento_w:= nr_atend_conta_w;
end if;
 
 
if (nr_atendimento_w > 0) then 
	if (coalesce(ie_ratear_p,'S') = 'S') then 
		CALL Ratear_Valores_Pacote(nr_atendimento_w, 'N', cd_convenio_w, nm_usuario_p);
	end if;
 
	CALL Gerar_Log_Pacote(nr_interno_conta_w, nr_seq_proc_pacote_p, WHEB_MENSAGEM_PCK.get_texto(278196) || nr_sequencia_p , nm_usuario_p,null,null);
end if;
 
ds_erro_p	:= ds_erro_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_item_pacote (nr_sequencia_p bigint, ie_proc_mat_p bigint, nr_seq_proc_pacote_p bigint, ie_ratear_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
