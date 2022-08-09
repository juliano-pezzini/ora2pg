-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_gerar_dados_consulta ( nr_seq_pend_agenda_p bigint, hr_agenda_p text, cd_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_retorno_p INOUT text) AS $body$
DECLARE


ds_retorno_w		varchar(255);			
dt_agenda_w		timestamp;
hr_agenda_w		timestamp;
hr_agenda_ww		timestamp;
nr_seq_agenda_w		agenda_consulta.nr_sequencia%type;
cd_pessoa_fisica_w	varchar(10);
dt_prevista_w		timestamp;
ds_prot_medic_w		varchar(255);
ie_atualizar_obs_w	varchar(1);
cd_classif_agenda_w	varchar(5);

cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_usuario_convenio_w	varchar(30);
dt_validade_carteira_w	timestamp;
nr_doc_convenio_w	varchar(20);
cd_tipo_acomodacao_w	smallint;
cd_plano_w		varchar(10);
ds_obs_w		varchar(255);
ie_forma_convenio_w	varchar(5);
ie_gerar_consulta_w	varchar(1);
dt_agenda_ww		timestamp;
hr_prevista_w		timestamp;
--ds_retorno_w		varchar2(255);
ie_classif_agendamento_w	varchar(5);
qt_pendencia_w		bigint;
nr_seq_enxaixe_w	bigint;
ds_obs_agenda_w		agenda_consulta.ds_observacao%type := '';
ie_perm_gerar_enc_w varchar(1);

C01 CURSOR FOR
	SELECT	coalesce(b.dt_agenda_real, b.dt_agenda),
		a.cd_pessoa_Fisica,
		b.ie_gerar_consulta,
		b.hr_prevista,
		b.ie_classif_agenda,
		b.ie_encaixe
	from	agenda_quimio a,
		w_gerar_consulta_quimio b
	where	a.nr_seq_pend_agenda		= b.nr_seq_pend_agenda
	and	trunc(a.dt_agenda) = trunc(b.dt_agenda)
	and	b.nr_seq_pend_agenda 		= nr_seq_pend_agenda_p
	and	coalesce(b.ie_gerar_consulta,'N')	= 'S';
	

BEGIN
ie_atualizar_obs_w	:= coalesce(Obter_Valor_Param_Usuario(865, 51, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 'N');
cd_classif_agenda_w	:= Obter_Valor_Param_Usuario(865, 101, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_forma_convenio_w	:= Obter_Valor_Param_Usuario(821, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

if (nr_seq_pend_agenda_p IS NOT NULL AND nr_seq_pend_agenda_p::text <> '') then
		
	open C01;
	loop
	fetch C01 into	
		dt_agenda_w,
		cd_pessoa_fisica_w,
		ie_gerar_consulta_w,
		hr_prevista_w,
		ie_classif_agendamento_w,
		ie_perm_gerar_enc_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
	
		select 	count(*)
		into STRICT	qt_pendencia_w
		from	agenda_quimio a
		where	a.nr_seq_pend_agenda = nr_seq_pend_agenda_p;
		
		if (qt_pendencia_w > 0) then
			select 	substr(coalesce(Qt_Obter_Desc_Prot(nr_seq_pend_agenda,nr_seq_atend_sim,cd_protocolo,nr_seq_medicacao, nr_seq_atendimento), SUBSTR(coalesce(obter_desc_protocolo(cd_protocolo),' '),1,255)||'/'||SUBSTR(coalesce(obter_desc_protocolo_medic(nr_seq_medicacao, cd_protocolo),' '),1,255)),1,255)
			into STRICT	ds_prot_medic_w
			from	agenda_quimio a
			where	a.nr_seq_pend_agenda = nr_seq_pend_agenda_p  LIMIT 1;			
		else
			select 	substr(obter_desc_prot_medic(nr_seq_paciente),1,255)
			into STRICT	ds_prot_medic_w
			from 	paciente_atendimento
			where 	nr_seq_pend_agenda = nr_seq_pend_agenda_p  LIMIT 1;
		end if;
		
		if (dt_agenda_w IS NOT NULL AND dt_agenda_w::text <> '') and (ie_gerar_consulta_w = 'S')then			
			
			if (hr_prevista_w IS NOT NULL AND hr_prevista_w::text <> '') then
				hr_agenda_w	:= to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' || to_char(hr_prevista_w,'hh24:mi')||':00','dd/mm/yyyy hh24:mi:ss');
			elsif (hr_agenda_p IS NOT NULL AND hr_agenda_p::text <> '') then
				hr_agenda_w	:= to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' || hr_agenda_p||':00','dd/mm/yyyy hh24:mi:ss');
			else
				hr_Agenda_w 	:= null;
			end if;
			
			ds_retorno_w := horario_livre_consulta(cd_estabelecimento_p, cd_agenda_p, 'N', dt_agenda_w, nm_usuario_p, 'S', 'N', 'N', 0, ds_retorno_w);
			
			select	coalesce(max(nr_sequencia) ,0)				
			into STRICT	nr_seq_agenda_w				
			from	agenda_consulta
			where	cd_agenda		= cd_agenda_p
			and	dt_agenda 		= hr_agenda_w
			and	ie_status_agenda	= 'L';
			
			if (ie_atualizar_obs_w = 'S') then
				ds_obs_agenda_w := ie_atualizar_obs_w;
			end if;
			
			if (coalesce(hr_Agenda_w::text, '') = '') then
			
				if (ie_perm_gerar_enc_w = 'S') then
					hr_Agenda_w := hr_Agenda_w + (60 / 86400);

					nr_seq_enxaixe_w := qt_gerar_encaixe_agecons(
						cd_estabelecimento_p, cd_agenda_p, dt_agenda_w, hr_agenda_w, 1, cd_pessoa_fisica_w, substr(obter_nome_pf(cd_pessoa_fisica_w),1,40), cd_convenio_w, ds_obs_agenda_w, coalesce(ie_classif_agendamento_w, cd_classif_agenda_w), nm_usuario_p, nr_seq_enxaixe_w, cd_categoria_w, cd_plano_w
					);
				else				
					ds_retorno_w	:= ds_retorno_w || chr(10) ||to_char(dt_Agenda_w,'dd/mm/yyyy hh24:mi:ss');
				end if;
				
			elsif (nr_seq_agenda_w	> 0) and (hr_agenda_w IS NOT NULL AND hr_agenda_w::text <> '') then
				if (ie_forma_convenio_w IS NOT NULL AND ie_forma_convenio_w::text <> '') and (ie_forma_convenio_w <> 'N') then
					
					SELECT * FROM Gerar_Convenio_Agendamento(cd_pessoa_fisica_w, 3, nr_seq_agenda_w, ie_forma_convenio_w, cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_carteira_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, nm_usuario_p, ds_obs_w
								) INTO STRICT cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_carteira_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, ds_obs_w
								;
				end if;

				update	agenda_consulta
				set	cd_pessoa_fisica	= cd_pessoa_fisica_w,
					nm_paciente			= substr(obter_nome_pf(cd_pessoa_fisica_w),1,40),
					ie_status_agenda	= 'N',
					ds_observacao		= CASE WHEN ie_atualizar_obs_w='S' THEN ds_prot_medic_w  ELSE ds_observacao END ,
					ie_classif_agenda 	= coalesce(ie_classif_agendamento_w, CASE WHEN cd_classif_agenda_w = NULL THEN ie_classif_agenda  ELSE cd_classif_agenda_w END ),
					cd_convenio		= coalesce(cd_convenio_w,cd_convenio),
					cd_categoria		= coalesce(cd_categoria_w,cd_categoria),
					cd_plano		= coalesce(cd_plano_w,cd_plano),
					cd_usuario_convenio	= coalesce(cd_usuario_convenio_w,cd_usuario_convenio),
					dt_validade_carteira	= coalesce(dt_validade_carteira_w,dt_validade_carteira),
					nr_doc_convenio		= coalesce(nr_doc_convenio_w,nr_doc_convenio),
					cd_tipo_acomodacao	= coalesce(cd_tipo_acomodacao_w,cd_tipo_acomodacao)
				where	nr_sequencia		= nr_seq_agenda_w;
			
			else
				if (ie_perm_gerar_enc_w = 'S') then
					hr_Agenda_w := hr_Agenda_w + (60 / 86400);
					nr_seq_enxaixe_w := qt_gerar_encaixe_agecons(
						cd_estabelecimento_p, cd_agenda_p, dt_agenda_w, hr_agenda_w, 1, cd_pessoa_fisica_w, substr(obter_nome_pf(cd_pessoa_fisica_w),1,40), cd_convenio_w, ds_obs_agenda_w, coalesce(ie_classif_agendamento_w, cd_classif_agenda_w), nm_usuario_p, nr_seq_enxaixe_w, cd_categoria_w, cd_plano_w
					);
				else
					ds_retorno_w	:= ds_retorno_w || chr(10) ||to_char(hr_agenda_w,'dd/mm/yyyy hh24:mi:ss');			
				end if;
				
			end if;
		
		else
			ds_retorno_w	:= ds_retorno_w || chr(10) ||to_char(dt_prevista_w,'dd/mm/yyyy');		
		end if;
		
		end;
	end loop;
	close C01;
end if;

ds_Retorno_p	:= ds_retorno_w;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_gerar_dados_consulta ( nr_seq_pend_agenda_p bigint, hr_agenda_p text, cd_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_retorno_p INOUT text) FROM PUBLIC;
