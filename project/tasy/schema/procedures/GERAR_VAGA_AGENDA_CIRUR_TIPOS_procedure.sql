-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_vaga_agenda_cirur_tipos ( nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_tipo_vagas_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

						
cd_tipo_acomodacao_w		smallint;
cd_convenio_w			integer;
nr_sequencia_w			bigint:= 0;
cd_pessoa_fisica_w		varchar(10);
cd_medico_resp_w		varchar(10);
ie_existe_w			varchar(1);
dt_agenda_w			timestamp;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_atendimento_w		bigint;
cd_doenca_cid_w			varchar(10);
cd_categoria_w			varchar(10);
nr_seq_agenda_w			agenda_paciente.nr_sequencia%type;
ie_consiste_internado_w		varchar(1);
ie_status_agenda_w		varchar(3);
cd_plano_w			varchar(10);
nm_paciente_w			varchar(80);
cd_tipo_agenda_w		varchar(10);
nr_telefone_w			varchar(255);
ds_observacao_w			varchar(255);
ie_consiste_sem_pf_dup_w    	varchar(1):= 'S';
nr_seq_gestao_vaga_w		bigint;
dt_chegada_prev_w		timestamp;	
ie_consiste_tipo_acom_w		varchar(1);
qt_diaria_prev_w		bigint;
cd_estabelecimento_w		smallint:= null;
ie_estab_agenda_w		varchar(1);
ie_reserva_vaga_w		varchar(1);
ie_gerar_autor_w		varchar(10) := 'N';
nr_seq_proc_interno_w		bigint;
ds_tipo_vagas_w			varchar(40);
ds_codigo_aux_w			varchar(3);
ds_codigo_temp_w		varchar(4000);
nr_seq_atepacu_w		bigint;
cd_setor_atendimento_w		integer;
cd_especialidade_medica_w	paciente_espera.cd_especialidade_medica%type;
ie_espec_medico_w		varchar(1);
cd_tipo_acomod_autor_w		smallint;
ie_possui_virgula_w		varchar(1);
ie_ver_solic_ambulatorial_w    	varchar(1);
ie_solicitacao_w		varchar(15);
ie_tipo_atendimento_w		 atendimento_paciente.ie_tipo_atendimento%type;
ie_consistencia_w		varchar(255);
ie_espec_valid_w		varchar(255);
ie_cid_valid_w			varchar(255);
nr_seq_classif_atend_w 		atendimento_paciente.nr_seq_classificacao%type;
cd_unid_basica_atual_w		gestao_vaga.cd_unid_basica_atual%type;
cd_unid_compl_atual_w		gestao_vaga.cd_unid_compl_atual%type;

k			smallint;
i			smallint;
						

BEGIN

-- ANALISAR TAMBEM O TRATAMENTO DE MENSAGEM NA PROCEDURE ATUALIZAR_GESTAO_VAGA, PARA VER SE O NUMERO JA NAO EXISTE NESTA PROCEDURE

-- ANALISAR TAMBEM O TRATAMENTO DE MENSAGEM NA PROCEDURE ATUALIZAR_GESTAO_VAGA, PARA VER SE O NUMERO JA NAO EXISTE NESTA PROCEDURE

-- ANALISAR TAMBEM O TRATAMENTO DE MENSAGEM NA PROCEDURE ATUALIZAR_GESTAO_VAGA, PARA VER SE O NUMERO JA NAO EXISTE NESTA PROCEDURE

-- ANALISAR TAMBEM O TRATAMENTO DE MENSAGEM NA PROCEDURE ATUALIZAR_GESTAO_VAGA, PARA VER SE O NUMERO JA NAO EXISTE NESTA PROCEDURE
ie_estab_agenda_w := Obter_Param_Usuario(871, 410, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_estab_agenda_w);
ie_espec_medico_w := Obter_Param_Usuario(1002, 153, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_espec_medico_w);

select	b.cd_pessoa_fisica,
	b.hr_inicio,
	b.cd_medico,
	b.cd_procedimento,
	b.ie_origem_proced,
	b.cd_convenio,
	b.cd_categoria,
	b.nr_atendimento,
	b.cd_tipo_acomodacao,
	b.cd_doenca_cid,
	b.nr_sequencia,
	b.ie_status_agenda,
	b.cd_plano,
	b.nm_paciente,
	1,
	b.nr_telefone,
	substr(b.ds_observacao,1,255) ds_observacao,
	b.dt_chegada_prev,
	b.qt_diaria_prev,
	b.nr_seq_proc_interno,
	b.ie_tipo_atendimento,
	(select c.nr_seq_classif_atend from agenda_paciente_auxiliar c where c.nr_seq_agenda = b.nr_sequencia) NR_SEQ_CLASSIF_ATEND
into STRICT	cd_pessoa_fisica_w,
	dt_agenda_w,
	cd_medico_resp_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_convenio_w,
	cd_categoria_w,
	nr_atendimento_w,
	cd_tipo_acomodacao_w,
	cd_doenca_cid_w,
	nr_seq_agenda_w,
	ie_status_agenda_w,
	cd_plano_w,
	nm_paciente_w,
	cd_tipo_agenda_w,
	nr_telefone_w,
	ds_observacao_w,
	dt_chegada_prev_w,
	qt_diaria_prev_w,
	nr_seq_proc_interno_w,
	ie_tipo_atendimento_w,
	nr_seq_classif_atend_w
from	agenda_paciente b
where	b.nr_sequencia = 	nr_seq_agenda_p;

ds_tipo_vagas_w	:= ds_tipo_vagas_p;

select	max(CASE WHEN SUBSTR(ds_tipo_vagas_w,LENGTH(ds_tipo_vagas_w),LENGTH(ds_tipo_vagas_w))=',' THEN 'S'  ELSE 'N' END )
into STRICT		ie_possui_virgula_w
;

if (ie_possui_virgula_w = 'N') then
	ds_tipo_vagas_w := ds_tipo_vagas_w ||',';
end if;

nr_seq_gestao_vaga_w  	:= 0;
ds_retorno_p		:= null;
if (ie_consiste_sem_pf_dup_w = 'S') and (coalesce(cd_pessoa_fisica_w::text, '') = '') then
	select 	obter_seq_gestao_vaga_tipo(nr_seq_agenda_w, cd_tipo_agenda_w)
	into STRICT	nr_seq_gestao_vaga_w
	;
end if;

if (coalesce(ie_espec_medico_w,'N') = 'S') then
	cd_especialidade_medica_w := obter_especialidade_medica(nr_seq_agenda_p);
end if;

if (nr_seq_gestao_vaga_w = 0) then

	ie_existe_w 		:= consistir_solicitacao_vaga(cd_pessoa_fisica_w, cd_estabelecimento_p, nm_usuario_p, 0, dt_agenda_w);
	ie_consiste_internado_w := consistir_atend_internado(cd_pessoa_fisica_w, cd_estabelecimento_p, nm_usuario_p);
	
	if (ie_estab_agenda_w = 'S') then
		select	max(a.cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
		from	agenda a,
			agenda_paciente b
		where	a.cd_agenda 	= b.cd_agenda
		and	b.nr_sequencia 	= nr_seq_agenda_p;
	end if;	
	
	
	if (coalesce(nr_atendimento_w,0) > 0 ) then
		nr_seq_atepacu_w	:= Obter_Atepacu_paciente(nr_atendimento_w, 'IA');
		
		if (coalesce(nr_seq_atepacu_w,0) > 0) then
			select	cd_setor_atendimento
			into STRICT	cd_setor_atendimento_w
			from	atend_paciente_unidade
			where	nr_seq_interno = nr_seq_atepacu_w;
		end if;
	end if;
	
	select	max(x.cd_tipo_acomod_desej)
	into STRICT	cd_tipo_acomod_autor_w
	from	autorizacao_convenio x
	where	x.nr_seq_agenda = nr_seq_agenda_p
	and	exists (SELECT	1
			from	tipo_acomodacao a
			where	a.cd_tipo_acomodacao = x.cd_tipo_acomod_desej);
			
	if (coalesce(cd_tipo_acomod_autor_w,0) > 0) then
		cd_tipo_acomodacao_w := cd_tipo_acomod_autor_w;
	end if;

	
	ie_consiste_tipo_acom_w := obter_se_acomodacao_desej_disp(cd_tipo_acomodacao_w,dt_agenda_w,coalesce(cd_estabelecimento_w,cd_estabelecimento_p));
	
	ie_reserva_vaga_w := Obter_Param_Usuario(871, 433, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_reserva_vaga_w);	
	ie_gerar_autor_w := Obter_Param_Usuario(871, 739, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_autor_w);
	ie_ver_solic_ambulatorial_w := obter_param_usuario(871, 532, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_ver_solic_ambulatorial_w);

	if (coalesce(ie_ver_solic_ambulatorial_w,'N') = 'S') and (ie_tipo_atendimento_w = 8) then
		ie_solicitacao_w := 'A';
	else
		ie_solicitacao_w := 'I';
	
	end if;	

	if (ie_existe_w = 'N') and (ie_consiste_internado_w = 'S') and (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') and
		((ie_consiste_tipo_acom_w = 'S') or (ie_reserva_vaga_w = 'S')) then
		
		k := 1;
		for i in k..length(ds_tipo_vagas_w) loop
		begin
		
		ds_codigo_aux_w	:= substr(ds_tipo_vagas_w,i,1);
		
		if (ds_codigo_aux_w = ',') then
			
			select	nextval('gestao_vaga_seq')
			into STRICT	nr_sequencia_w
			;
		
			select substr(obter_unidade_atendimento(nr_atendimento_w,'IAA','UB'),1,40)
			into STRICT 	cd_unid_basica_atual_w
			;
				
			select substr(obter_unidade_atendimento(nr_atendimento_w,'IAA','UC'),1,40)
			into STRICT 	cd_unid_compl_atual_w
			;

			insert into gestao_vaga(
				nr_sequencia,
				cd_estabelecimento,
				cd_pessoa_fisica,
				dt_atualizacao,
				nm_usuario,
				dt_solicitacao,
				dt_prevista,
				ie_solicitacao,
				cd_convenio,
				cd_categoria,
				ie_status,
				ie_tipo_vaga,
				nr_atendimento,
				cd_tipo_acomod_desej,
				cd_medico,
				ie_clinica,
				cd_procedimento,
				ie_origem_proced,
				cd_cid_principal,
				nr_seq_agenda,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				cd_plano_convenio,
				nm_paciente,
				cd_tipo_agenda,
				nr_telefone,
				ds_observacao,
				qt_dia,
				nr_seq_proc_interno,
				cd_setor_atual,
				cd_especialidade,
				ie_tipo_atendimento,
				nr_seq_classif_atend,
				cd_unid_basica_atual,
				cd_unid_compl_atual)
			values (
				nr_sequencia_w,
				coalesce(cd_estabelecimento_w,cd_estabelecimento_p),
				cd_pessoa_fisica_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				coalesce(dt_chegada_prev_w,dt_agenda_w),
				ie_solicitacao_w,
				cd_convenio_w,
				cd_categoria_w,
				'A',
				trim(both ds_codigo_temp_w),
				nr_atendimento_w,
				cd_tipo_acomodacao_w,
				cd_medico_resp_w,
				2,
				cd_procedimento_w,
				ie_origem_proced_w,
				cd_doenca_cid_w,
				nr_seq_agenda_w,
				nm_usuario_p,
				clock_timestamp(),
				cd_plano_w,
				nm_paciente_w,
				cd_tipo_agenda_w,
				nr_telefone_w,
				ds_observacao_w,
				qt_diaria_prev_w,
				nr_seq_proc_interno_w,
				cd_setor_atendimento_w,
				cd_especialidade_medica_w,
				ie_tipo_atendimento_w,
				nr_seq_classif_atend_w,
				cd_unid_basica_atual_w,
				cd_unid_compl_atual_w);

			SELECT * FROM obter_reg_regulacao_gest_vagas(ie_solicitacao_w, ds_codigo_aux_w, ie_espec_valid_w, ie_cid_valid_w) INTO STRICT ie_espec_valid_w, ie_cid_valid_w;

			if ((coalesce(ie_espec_valid_w, 'N') = 'N') or ((coalesce(ie_espec_valid_w, 'N') = 'S') and (coalesce(cd_especialidade_medica_w, 0) > 0)))
				and ((coalesce(ie_cid_valid_w, 'N') = 'N') or ((coalesce(ie_cid_valid_w, 'N') = 'S') and (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> ''))) then
				ie_consistencia_w := CONSISTIR_REGULACAO(nr_atendimento_w, nr_sequencia_w, 'GESTAO_VAGA', ie_consistencia_w);
			end if;

			if (coalesce(ie_gerar_autor_w,'N') = 'S') then		
				CALL gerar_autor_regra(null, null, null, null, null, null, 'GVE', nm_usuario_p, null,null, nr_sequencia_w,null,null,null,'','','');
			end if;
			
			ds_codigo_temp_w	:= '';
				
			commit;
		else
			ds_codigo_temp_w := ds_codigo_temp_w||ds_codigo_aux_w;
		end if;
		end;
		end loop;
		
	end if;
			
	if	(nr_sequencia_w > 0 AND ie_consiste_tipo_acom_w = 'S') then
	ds_retorno_p := WHEB_MENSAGEM_PCK.get_texto(280482,null);

	elsif  ((nr_sequencia_w > 0) and (ie_consiste_tipo_acom_w = 'N') and (ie_reserva_vaga_w = 'S')) then
		ds_retorno_p := WHEB_MENSAGEM_PCK.get_texto(280483,'CD_TIPO_ACOMODACAO='||obter_desc_tipo_acomodacao(cd_tipo_acomodacao_w));

	elsif	(ie_consiste_tipo_acom_w = 'N' AND  ie_reserva_vaga_w = 'N') then
		ds_retorno_p := WHEB_MENSAGEM_PCK.get_texto(280485,'CD_TIPO_ACOMODACAO='||obter_desc_tipo_acomodacao(cd_tipo_acomodacao_w));
	
	elsif (nr_seq_agenda_p > 0) and (ie_existe_w = 'S') then
		ds_retorno_p	:= wheb_mensagem_pck.get_texto(733570);
	end if;	
	
end if;	

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_vaga_agenda_cirur_tipos ( nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_tipo_vagas_p text, ds_retorno_p INOUT text) FROM PUBLIC;

