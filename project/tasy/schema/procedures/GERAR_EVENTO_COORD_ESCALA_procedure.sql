-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_coord_escala (nr_seq_evento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_laudo_p bigint, nm_usuario_p text, nr_seq_unidade_p text, cd_setor_atendimento_p text, ds_obs_alta_p text default '', nr_submotivo_alta_p bigint DEFAULT NULL, nm_medico_resp_p text DEFAULT NULL, ie_tipo_atendimento_p bigint DEFAULT NULL, cd_medico_atendimento_p bigint default null, cd_medico_resp_p bigint default null, cd_medico_referido_p bigint default null, ie_trigger_atend_p text default 'N', cd_motivo_alta_p bigint default null, ds_procedencia_p text default null, ds_estabelecimento_p text default null) AS $body$
DECLARE


ie_forma_ev_w		varchar(15);
ie_pessoa_destino_w	varchar(15);
cd_pf_destino_w		varchar(10);
ds_mensagem_w		varchar(4000);
ds_titulo_w		varchar(100);
cd_pessoa_destino_w	varchar(10);
nr_sequencia_w		bigint;
ds_maquina_w		varchar(80);
nm_paciente_w		varchar(60);
ds_unidade_w		varchar(60);
ds_setor_atendimento_w	varchar(60);
ie_usuario_aceite_w	varchar(1);
qt_corresp_w		integer;
cd_setor_atendimento_w	integer;
cd_perfil_w		integer;
cd_pessoa_regra_w	varchar(10);
nr_ramal_w		varchar(10);
nr_telefone_w		varchar(10);
cd_convenio_w		bigint;
ds_unidade_ww		varchar(60);
ds_setor_atendimento_ww	varchar(60);
dt_inicio_w		varchar(30);
nr_seq_sl_w		bigint;
cd_setor_atend_pac_w	integer;

nm_usuario_destino_w	varchar(15);
ds_cid_w		varchar(240);
cd_cid_w		varchar(10);
ds_convenio_w		varchar(255)	:= '';
ds_submotivo_alta_w	varchar(60);
nm_pessoa_resp_w	varchar(255);
ds_tipo_atend_w		varchar(60);
ds_classif_pessoa_w	varchar(4000);
ds_observacao_w		varchar(4000);
ds_endereco_compl_w	varchar(255);
ds_motivo_alta_w	varchar(80);
ie_excecao_alerta_pessoa_w		varchar(1);
ds_email_fixo_w		ev_evento_pac_destino.ds_email_fixo%type;
ds_data_nascimento_w 	varchar(30);
ds_email_fixo_regra_w		ev_evento_regra_dest.DS_EMAIL_FIXO%type;

C01 CURSOR FOR
	SELECT	ie_forma_ev,
		ie_pessoa_destino,
		cd_pf_destino,
		coalesce(ie_usuario_aceite,'N'),
		cd_setor_atendimento,
		cd_perfil,
		DS_EMAIL_FIXO
	from	ev_evento_regra_dest
	where	nr_seq_evento	= nr_seq_evento_p
	and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))	= coalesce(cd_convenio_w,0)
	and	coalesce(cd_setor_atend_pac, coalesce(cd_setor_atend_pac_w,0))	= coalesce(cd_setor_atend_pac_w,0)
	order by ie_forma_ev;

C02 CURSOR FOR
	SELECT	obter_dados_usuario_opcao(nm_usuario,'C')
	from	usuario_setor_v
	where	cd_setor_atendimento = cd_setor_atendimento_w
	and	ie_forma_ev_w in (2,3)
	and	(obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '');

C03 CURSOR FOR
	SELECT	obter_dados_usuario_opcao(nm_usuario,'C'),
			nm_usuario
	from	usuario_perfil
	where	cd_perfil = cd_perfil_w
	and	ie_forma_ev_w in (1,2,3)
	and	(obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '');
	

BEGIN
select	substr(obter_inf_sessao(0),1,80)
into STRICT	ds_maquina_w
;

select	coalesce(max(obter_convenio_atendimento(nr_atendimento_p)), 0)
into STRICT	cd_convenio_w
;

if (cd_convenio_w > 0) then
	ds_convenio_w := obter_desc_convenio(cd_convenio_w);
end if;

select	ds_titulo,
	ds_mensagem
into STRICT	ds_titulo_w,
	ds_mensagem_w
from	ev_evento
where	nr_sequencia	= nr_seq_evento_p;

ds_endereco_compl_w := substr(obter_compl_pf(cd_pessoa_fisica_p, 1, 'ECCT'),1,255);

select	substr(obter_nome_pf(cd_pessoa_fisica_p),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','U'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','RA'),1,10),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','TL'),1,10),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','S'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','CS'),1,10),
	max(substr(obter_nome_tipo_atend(ie_tipo_atendimento_p),1,60)),
	substr(obter_lista_dados_classif(cd_pessoa_fisica_p, 'D'),1,255),
	substr(obter_lista_dados_classif(cd_pessoa_fisica_p, 'O'),1,2000),
	substr(obter_dados_pf(cd_pessoa_fisica_p,'DN') ,1,30)
into STRICT	nm_paciente_w,
	ds_unidade_w,
	nr_ramal_w,
	nr_telefone_w,
	ds_setor_atendimento_w,
	cd_setor_atend_pac_w,
	ds_tipo_atend_w,
	ds_classif_pessoa_w,
	ds_observacao_w,
	ds_data_nascimento_w
;

if (nr_seq_unidade_p IS NOT NULL AND nr_seq_unidade_p::text <> '') then
	
	select	substr(cd_unidade_basica||' '||cd_unidade_compl,1,50),
		substr(obter_nome_setor(cd_setor_atendimento),1,100)
	into STRICT	ds_unidade_ww,
		ds_setor_atendimento_ww
	from	unidade_atendimento
	where	nr_seq_interno = nr_seq_unidade_p;
	
end if;

select	substr(obter_cid_atendimento(nr_atendimento_p, 'P'),1,10),
	substr(obter_desc_cid_doenca(obter_cid_atendimento(nr_atendimento_p, 'P')),1,240)
into STRICT	cd_cid_w,
	ds_cid_w
;

ds_motivo_alta_w	:= substr(obter_desc_motivo_alta(cd_motivo_alta_p),1,80);

if (nr_submotivo_alta_p IS NOT NULL AND nr_submotivo_alta_p::text <> '') then
	ds_submotivo_alta_w	:= substr(obter_desc_submotivo_alta(nr_submotivo_alta_p),1,60);
end if;

ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@atendimento',nr_atendimento_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ramal',nr_ramal_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@telefone',nr_telefone_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@convenio',ds_convenio_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@obs_alta',ds_obs_alta_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@data_atual',PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@data_hora_atual',PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@med_resp',nm_medico_resp_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@tipo_atendimento',ds_tipo_atend_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@classif_pf',ds_classif_pessoa_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@obs_classif_pessoa',ds_observacao_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_convenio',ds_convenio_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ENDERECO_COMPLETO',ds_endereco_compl_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nascimento',ds_data_nascimento_w),1,4000);

if (nr_seq_unidade_p IS NOT NULL AND nr_seq_unidade_p::text <> '') then
	begin
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@quarto',ds_unidade_ww),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@setor',ds_setor_atendimento_ww),1,4000);
	end;
else
	begin
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@quarto',ds_unidade_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@setor',ds_setor_atendimento_w),1,4000);
	end;
end if;

ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cd_cid',cd_cid_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_cid',ds_cid_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@submotivo_alta',ds_submotivo_alta_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_motivo_alta',ds_motivo_alta_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@procedencia',ds_procedencia_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_estab_atend',ds_estabelecimento_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nr_prontuario',obter_prontuario_paciente(cd_pessoa_fisica_p)),1,4000);

select	nextval('ev_evento_paciente_seq')
into STRICT	nr_sequencia_w
;

insert into ev_evento_paciente(
	nr_sequencia,
	nr_seq_evento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_pessoa_fisica,
	nr_atendimento,
	ds_titulo,
	ds_mensagem,
	ie_status,
	ds_maquina,
	dt_evento,
	dt_liberacao)
values (	nr_sequencia_w,
	nr_seq_evento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_pessoa_fisica_p,
	nr_atendimento_p,
	ds_titulo_w,
	ds_mensagem_w,
	'G',
	ds_maquina_w,
	clock_timestamp(),
	clock_timestamp());

open C01;
loop
fetch C01 into
	ie_forma_ev_w,
	ie_pessoa_destino_w,
	cd_pf_destino_w,
	ie_usuario_aceite_w,
	cd_setor_atendimento_w,
	cd_perfil_w,
	ds_email_fixo_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_pessoa_destino_w	:= null;
	ds_email_fixo_w := null;
	qt_corresp_w	:= 1;
	if (ie_pessoa_destino_w = '9') then /* Médico do atendimento */
		begin
		if (ie_trigger_atend_p = 'N') then
			begin
			select	max(cd_pessoa_fisica)
			into STRICT	cd_pessoa_destino_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
			end;
		end if;
		end;
	elsif (ie_pessoa_destino_w = '1') then /* Médico do atendimento */
		begin
		if (ie_trigger_atend_p = 'N') then
			begin
			select	max(cd_medico_atendimento)
			into STRICT	cd_pessoa_destino_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
			end;
		else
			cd_pessoa_destino_w := cd_medico_atendimento_p;
		end if;
		end;
	elsif (ie_pessoa_destino_w = '2') then /*Médico responsável pelo paciente*/
		begin
		if (ie_trigger_atend_p = 'N') then
			begin
			select	max(cd_medico_resp)
			into STRICT	cd_pessoa_destino_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
			end;
		else
			cd_pessoa_destino_w := cd_medico_resp_p;
		end if;
		end;
	elsif (ie_pessoa_destino_w = '3') then /*Médico laudante*/
		begin
		select	max(cd_medico_resp)
		into STRICT	cd_pessoa_destino_w
		from	laudo_paciente
		where	nr_sequencia	= nr_seq_laudo_p;
		end;
	elsif (ie_pessoa_destino_w = '4') then /*Médico referido*/
		begin
		if (ie_trigger_atend_p = 'N') then
			begin
			select	max(cd_medico_referido)
			into STRICT	cd_pessoa_destino_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
			end;
		else
			cd_pessoa_destino_w := cd_medico_referido_p;
		end if;
		end;
	elsif (ie_pessoa_destino_w = '5') or (ie_pessoa_destino_w = '12') then /*Pessoa fixa ou Usuário fixo*/
		cd_pessoa_destino_w	:= cd_pf_destino_w;
	elsif (ie_pessoa_destino_w = '8') then /* Funcionário de higiene, de acordo o serviço que esta executando */
		begin
		
		select	distinct min(f.cd_pessoa_fisica)
		into STRICT	cd_pessoa_destino_w
		FROM escala_grupo g, escala_diaria_adic f, escala_diaria d, escala_classif c, escala e
LEFT OUTER JOIN escala_setor h ON (e.nr_sequencia = h.nr_seq_escala)
WHERE c.nr_sequencia = g.nr_seq_classif and g.nr_sequencia = e.nr_seq_grupo and e.nr_sequencia = d.nr_seq_escala and f.nr_seq_escala_diaria = d.nr_sequencia  and obter_tipo_classif_escala(e.nr_sequencia) = 'S' and clock_timestamp() between dt_inicio and dt_fim and substr(obter_se_prof_ocup_livre(f.cd_pessoa_fisica,trunc(clock_timestamp())),1,1) = 'L' and ((exists ( SELECT	1
				   from		escala_setor h
				   where	h.nr_seq_escala = e.nr_sequencia
				   and		h.cd_setor_atendimento = cd_setor_atendimento_p)) or (coalesce(h.cd_setor_atendimento::text, '') = '')) order by substr(sl_obter_ult_serv_prof(f.cd_pessoa_fisica,clock_timestamp(), null, 'DI'),1,90);
		
		if (coalesce(cd_pessoa_destino_w::text, '') = '') then
			begin
			select	min(substr(sl_obter_ult_serv_prof(f.cd_pessoa_fisica,clock_timestamp(), null, 'DI'),1,90))
			into STRICT	dt_inicio_w
			FROM escala_grupo g, escala_diaria_adic f, escala_diaria d, escala_classif c, escala e
LEFT OUTER JOIN escala_setor h ON (e.nr_sequencia = h.nr_seq_escala)
WHERE c.nr_sequencia = g.nr_seq_classif and g.nr_sequencia = e.nr_seq_grupo and e.nr_sequencia = d.nr_seq_escala and f.nr_seq_escala_diaria = d.nr_sequencia  and obter_tipo_classif_escala(e.nr_sequencia) = 'S' and clock_timestamp() between dt_inicio and dt_fim and substr(obter_se_prof_ocup_livre(f.cd_pessoa_fisica,trunc(clock_timestamp())),1,1) = 'O' and ((exists ( SELECT	1
					   from		escala_setor h
					   where	h.nr_seq_escala = e.nr_sequencia
				           and		h.cd_setor_atendimento = cd_setor_atendimento_p)) or (coalesce(h.cd_setor_atendimento::text, '') = ''));
					
			select	max(substr(sl_obter_ult_serv_prof(f.cd_pessoa_fisica,clock_timestamp(), null, 'SEQ'),1,90))
			into STRICT	nr_seq_sl_w
			FROM escala_grupo g, escala_diaria_adic f, escala_diaria d, escala_classif c, escala e
LEFT OUTER JOIN escala_setor h ON (e.nr_sequencia = h.nr_seq_escala)
WHERE c.nr_sequencia = g.nr_seq_classif and g.nr_sequencia = e.nr_seq_grupo and e.nr_sequencia = d.nr_seq_escala and f.nr_seq_escala_diaria = d.nr_sequencia  and obter_tipo_classif_escala(e.nr_sequencia) = 'S' and clock_timestamp() between dt_inicio and dt_fim and substr(obter_se_prof_ocup_livre(f.cd_pessoa_fisica,trunc(clock_timestamp())),1,1) = 'O' and ((exists ( SELECT	1
					   from		escala_setor h
					   where	h.nr_seq_escala = e.nr_sequencia
				           and		h.cd_setor_atendimento = cd_setor_atendimento_p)) or (coalesce(h.cd_setor_atendimento::text, '') = '')) and sl_obter_ult_serv_prof(f.cd_pessoa_fisica,clock_timestamp(), null, 'DI') = dt_inicio_w;
			
			select	max(a.cd_executor)
			into STRICT 	cd_pessoa_destino_w
			from	sl_unid_atend a
			where	a.nr_sequencia = nr_seq_sl_w;
						
			end;
			
		end if;
		
		end;
	elsif (ie_pessoa_destino_w = '19') then /*Pessoa fisica do atendimento*/
		cd_pf_destino_w	:= cd_pessoa_fisica_p;
		
		select	substr(max(coalesce(obter_compl_pf(cd_pf_destino_w,2,'M'), obter_compl_pf(cd_pf_destino_w,1,'M'))),1,100)
		into STRICT	ds_email_fixo_w
		;
		
	elsif (ie_pessoa_destino_w = '22') then /*Email fixo*/
		ds_email_fixo_w := ds_email_fixo_regra_w;
	end if;
	
	if (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '1') then
		begin
		select	count(*)
		into STRICT	qt_corresp_w
		from	pessoa_fisica_corresp
		where	cd_pessoa_fisica	= cd_pessoa_destino_w
		and	ie_tipo_corresp		= 'MCel'
		and	ie_tipo_doc		= 'AE';
		end;
	elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '3') then
		begin
		select	count(*)
		into STRICT	qt_corresp_w
		from	pessoa_fisica_corresp
		where	cd_pessoa_fisica	= cd_pessoa_destino_w
		and	ie_tipo_corresp		= 'CI'
		and	ie_tipo_doc		= 'AE';
		end;
	elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '4') then
		begin
		select	count(*)
		into STRICT	qt_corresp_w
		from	pessoa_fisica_corresp
		where	cd_pessoa_fisica	= cd_pessoa_destino_w
		and	ie_tipo_corresp		= 'Email'
		and	ie_tipo_doc		= 'AE';
		end;
	end if;
	
	
	
	
	
	if (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (qt_corresp_w > 0) then
		begin	
		ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_destino_w, ie_forma_ev_w);
		--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta)
		if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then
			insert into ev_evento_pac_destino(
				nr_sequencia,
				nr_seq_ev_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_pessoa_fisica,
				ie_forma_ev,
				ie_status,
				dt_ciencia,
				ie_pessoa_destino,
				dt_evento,
				ds_email_fixo)
			values (	nextval('ev_evento_pac_destino_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_destino_w,
				ie_forma_ev_w,
				'G',
				null,
				ie_pessoa_destino_w,
				clock_timestamp(),
				ds_email_fixo_w);	
		end if;
		end;	
		
	elsif (cd_pf_destino_w IS NOT NULL AND cd_pf_destino_w::text <> '') and (coalesce(cd_setor_atendimento_w::text, '') = '') and (coalesce(cd_perfil_w::text, '') = '') then
		begin	
		ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pf_destino_w, ie_forma_ev_w);

		--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta)
		if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then
			
			insert into ev_evento_pac_destino(
				nr_sequencia,
				nr_seq_ev_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_pessoa_fisica,
				ie_forma_ev,
				ie_status,
				dt_ciencia,
				ie_pessoa_destino,
				dt_evento,
				ds_email_fixo)
			values (	nextval('ev_evento_pac_destino_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_pf_destino_w,
				ie_forma_ev_w,
				'G',
				null,
				ie_pessoa_destino_w,
				clock_timestamp(),
				ds_email_fixo_w);	
		end if;
		end;			
	end if;
		
	
	open C02;
	loop
	fetch C02 into
		cd_pessoa_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then
		ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_regra_w, ie_forma_ev_w);

		--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta)
		if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then		
			insert into ev_evento_pac_destino(
				nr_sequencia,
				nr_seq_ev_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_pessoa_fisica,
				ie_forma_ev,
				ie_status,
				dt_ciencia,
				ie_pessoa_destino,
				dt_evento,
				ds_email_fixo)
			values (	nextval('ev_evento_pac_destino_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_regra_w,
				ie_forma_ev_w,
				'G',
				null,
				ie_pessoa_destino_w,
				clock_timestamp(),
				ds_email_fixo_w);
		end if;
		
		end if;
		end;
	end loop;
	close C02;

	open C03;
	loop
	fetch C03 into
		cd_pessoa_regra_w,
		nm_usuario_destino_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then
		ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_regra_w, ie_forma_ev_w);

		--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta)
		if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then	
		
			insert into ev_evento_pac_destino(
				nr_sequencia,
				nr_seq_ev_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_pessoa_fisica,
				ie_forma_ev,
				ie_status,
				dt_ciencia,
				nm_usuario_Dest,
				ie_pessoa_destino,
				dt_evento,
				ds_email_fixo)
			values (	nextval('ev_evento_pac_destino_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_regra_w,
				ie_forma_ev_w,
				'G',
				null,
				nm_usuario_destino_w,
				ie_pessoa_destino_w,
				clock_timestamp(),
				ds_email_fixo_w);
		end if;
		
		end if;
		end;
	end loop;
	close C03;

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_coord_escala (nr_seq_evento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_laudo_p bigint, nm_usuario_p text, nr_seq_unidade_p text, cd_setor_atendimento_p text, ds_obs_alta_p text default '', nr_submotivo_alta_p bigint DEFAULT NULL, nm_medico_resp_p text DEFAULT NULL, ie_tipo_atendimento_p bigint DEFAULT NULL, cd_medico_atendimento_p bigint default null, cd_medico_resp_p bigint default null, cd_medico_referido_p bigint default null, ie_trigger_atend_p text default 'N', cd_motivo_alta_p bigint default null, ds_procedencia_p text default null, ds_estabelecimento_p text default null) FROM PUBLIC;

