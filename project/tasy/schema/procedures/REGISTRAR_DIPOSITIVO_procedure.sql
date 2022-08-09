-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_dipositivo ( dt_registro_p timestamp, nr_seq_registro_p bigint, nr_seq_dispositivo_p bigint, nr_seq_acao_disp_p bigint, nr_seq_acao_instal_p bigint, nr_seq_outra_acao_p bigint, nr_seq_evento_p bigint, nr_seq_classif_evento_p bigint, ds_evento_p text, nr_atendimento_p bigint, nr_seq_topografia_p bigint, ie_lado_p text, ds_titulo_p text, nm_usuario_p text, ie_opcao_p text, ds_compl_topo_p text, dt_retirada_p timestamp, hr_permanencia_p bigint, dt_ret_prev_p timestamp, cd_profissional_p text, nr_cirurgia_p bigint default null, dt_retirada_curativo_p timestamp DEFAULT NULL, qt_horas_cur_p bigint DEFAULT NULL, nr_seq_motivo_ret_p bigint DEFAULT NULL, qt_tentativas_p bigint DEFAULT NULL, qt_dispositivos_p bigint DEFAULT NULL, ie_liberar_p text DEFAULT NULL, ie_retirar_alta_p text DEFAULT NULL, ie_opcao_disp_p text DEFAULT NULL, nr_seq_disp_atend_p INOUT bigint DEFAULT NULL, nr_seq_calibre_p bigint default null, nr_seq_pepo_p bigint DEFAULT NULL, nr_seq_assinatura_p bigint default null, ie_bronco_p text default 'N', ie_Inconsciente_p text default 'N', ie_sne_p text default 'N', ie_sucesso_p text default 'S', cd_setor_atendimento_p bigint default null, ds_observacao_p text default null, nr_seq_qua_evento_p INOUT bigint DEFAULT NULL, ds_acao_imediata_p text default null, nr_seq_complemento_p bigint default null, ds_justificativa_retro_p text default null) AS $body$
DECLARE



cd_pessoa_fisica_w		varchar(10);
ie_classificacao_w		varchar(10);
ds_compl_topo_w			varchar(2000);
ds_evento_w				varchar(4000);
ds_titulo_w				varchar(2000);
nr_sequencia_w			bigint;
nr_seq_dispositivo_w	bigint;
cd_estabelecimento_w	smallint;
cd_setor_atendimento_w	integer;
ie_acao_w				varchar(15);
ds_motivo_w				varchar(255);
ds_dispositivo_w		varchar(255);
ie_gerar_evolucao_w		varchar(1);
ie_troca_curativo_w		varchar(1);
ie_retirar_evento_w		varchar(1);
qt_hora_perm_curat_w	smallint;
nr_seq_evento_w			bigint;
dt_liberacao_w			timestamp;
nr_seq_disp_proc_w		bigint;
ds_hint_w				varchar(4000);
cd_evolucao_w			bigint;
nr_seq_proc_interno_w	bigint;
nr_seq_proc_SAE_w	bigint;
ds_observacao_w			varchar(255);


BEGIN

if (nr_atendimento_p > 0) then

	select	Obter_Dados_Usuario_Opcao(nm_usuario_p,'C')
	into STRICT	cd_pessoa_fisica_w
	;

	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento	=	nr_atendimento_p;

	if (coalesce(cd_setor_atendimento_p,0) > 0) then
		cd_setor_atendimento_w := cd_setor_atendimento_p;
	else
		select	max(Obter_Setor_Atendimento(nr_atendimento_p))
		into STRICT	cd_setor_atendimento_w
		;
	end if;

	select	coalesce(max(ie_gerar_evolucao),'S')
	into STRICT	ie_gerar_evolucao_w
	from	DISPOSITIVO
	where	nr_sequencia	= nr_seq_dispositivo_p;


	if (coalesce(ie_opcao_disp_p,'P') = 'SAE') then

		select	max(nr_seq_proc_interno)
		into STRICT	nr_seq_proc_SAE_w
		from	pe_proc_dispositivo
		where	nr_seq_dispositivo = nr_seq_dispositivo_p
		and		nr_seq_proc = nr_seq_acao_disp_p
		and		ie_acao in ('I','U','R');

	end if;

	Select CASE WHEN ie_opcao_disp_p='SAE' THEN nr_seq_proc_SAE_w  ELSE nr_seq_acao_disp_p END
	into STRICT	nr_seq_proc_interno_w
	;

	if (ie_opcao_p = 'N') then
		begin

		ie_acao_w	:= obter_acao_procedimento(nr_seq_acao_disp_p, nr_seq_dispositivo_p,coalesce(ie_opcao_disp_p,'P'));

		select	nextval('atend_pac_dispositivo_seq')
		into STRICT	nr_sequencia_w
		;

		ds_compl_topo_w	:= substr(ds_compl_topo_p,1,80);
		ds_titulo_w	:= substr(ds_titulo_p,1,100);

		insert into atend_pac_dispositivo(
			nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_dispositivo,
			dt_instalacao,
			nr_seq_topografia,
			ie_lado,
			ds_titulo,
			dt_retirada,
			qt_hora_permanencia,
			dt_retirada_prev,
			ds_compl_topografia,
			nr_cirurgia,
			dt_retir_prev_curat,
			qt_hora_perm_curat,
			qt_tentativas,
			qt_disp_utilizados,
			ie_acao,
			cd_profissional,
			nr_seq_calibre,
			nr_seq_pepo,
			nr_seq_assinatura,
			ie_bronco,
			ie_Inconsciente,
			ie_sne,
			ie_sucesso,
			ds_observacao,
			nr_seq_complemento,
			ds_justificativa_retro)
		values (
			nr_sequencia_w,
			nr_atendimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_dispositivo_p,
			dt_registro_p,
			CASE WHEN nr_seq_topografia_p=0 THEN null  ELSE nr_seq_topografia_p END ,
			ie_lado_p,
			ds_titulo_w,
			CASE WHEN ie_sucesso_p='N' THEN clock_timestamp()  ELSE CASE WHEN ie_acao_w='U' THEN dt_registro_p  ELSE dt_retirada_p END  END ,
			CASE WHEN ie_acao_w='U' THEN 0  ELSE hr_permanencia_p END ,
			CASE WHEN ie_acao_w='U' THEN dt_registro_p  ELSE dt_ret_prev_p END ,
			ds_compl_topo_w,
			nr_cirurgia_p,
			dt_retirada_curativo_p,
			qt_horas_cur_p,
			qt_tentativas_p,
			qt_dispositivos_p,
			ie_acao_w,
			cd_profissional_p,
			CASE WHEN nr_seq_calibre_p=0 THEN null  ELSE nr_seq_calibre_p END ,
			nr_seq_pepo_p,
			CASE WHEN nr_seq_assinatura_p=0 THEN null  ELSE nr_seq_assinatura_p END ,
			ie_bronco_p,
			ie_inconsciente_p,
			ie_sne_p,
			ie_sucesso_p,
			ds_observacao_p,
			nr_seq_complemento_p,
			ds_justificativa_retro_p);

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

		if (coalesce(nr_seq_acao_disp_p,0) > 0) and
			((coalesce(ie_opcao_disp_p,'P') <> 'SAE') or
			((coalesce(ie_opcao_disp_p,'P') = 'SAE')and (coalesce(nr_seq_proc_SAE_w,0) > 0))) and (campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')) > 0)then
			begin
			Select	nextval('atend_pac_disp_proc_seq')
			into STRICT	nr_seq_disp_proc_w
			;

			insert into atend_pac_disp_proc(
				nr_sequencia,
				nr_seq_disp_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				dt_procedimento,
				cd_pessoa_fisica,
				cd_setor_atendimento,
        ds_observacao)
			values (
				nr_seq_disp_proc_w,
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_interno_w,
				dt_registro_p,
				cd_profissional_p,
				campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')),
        ds_observacao_p);
			end;

			select	coalesce(substr(obter_descricao_padrao('DISPOSITIVO','DS_DISPOSITIVO',max(a.nr_seq_dispositivo)),1,80),obter_desc_expressao(342959)) ds_dispositivo,
					substr(obter_hint_graf_niss_adep(max(a.nr_sequencia)),1,4000) ds_hint
			into STRICT	ds_dispositivo_w,
					ds_hint_w
			from	atend_pac_dispositivo a
			where	((coalesce(a.dt_retirada::text, '') = '') or (coalesce(ie_acao_w,'xpt') = 'U'))
			and		obter_se_exibe_graf_disp(a.nr_sequencia) = 'S'
			and		a.nr_atendimento = nr_atendimento_p
			and		a.nr_sequencia = nr_sequencia_w;

			if (ie_gerar_evolucao_w = 'S') then
				cd_evolucao_w := Gerar_evolPaci_automa('DISP', nm_usuario_p, nr_atendimento_p, ds_dispositivo_w, null, 'A', ds_hint_w, dt_registro_p, null, null, null, null, cd_evolucao_w, 'S', null, nr_sequencia_w, ie_opcao_disp_p, nr_seq_acao_disp_p);
			end if;
		end if;


		CALL ADEP_cobranca_dispositivo(nr_atendimento_p,nr_seq_dispositivo_p,nr_seq_disp_proc_w ,nm_usuario_p,'I',ie_acao_w, nr_sequencia_w);

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
		end;


	elsif (ie_opcao_p = 'R') and (nr_seq_proc_interno_w > 0) and (campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')) > 0)then
		begin

		CALL Retirar_dispositivo_adep(nr_seq_proc_interno_w, nr_seq_dispositivo_p, ie_opcao_disp_p, dt_registro_p, nr_seq_motivo_ret_p, nr_seq_registro_p, nr_atendimento_p, nm_usuario_p, ds_evento_p);

		update	atend_pac_dispositivo
		set		nr_seq_calibre			=	coalesce(nr_seq_calibre_p,nr_seq_calibre),
				ds_descricao_retirada 	= ds_evento_p
		where	nr_sequencia			=	nr_seq_registro_p;

		nr_sequencia_w 	:= nr_seq_registro_p;

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
		end;
	elsif (ie_opcao_p = 'O') and (nr_seq_outra_acao_p > 0) and (nr_seq_registro_p > 0) and (campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')) > 0) then
		begin

		select	ds_observacao
		into STRICT	ds_observacao_w
		from	atend_pac_dispositivo a
		where	a.nr_atendimento = nr_atendimento_p
			and		a.nr_sequencia = nr_seq_registro_p;

		if (coalesce(ds_evento_p,'N') = 'N') then
			ds_evento_w := ds_observacao_w;
		else
			if (coalesce(ds_observacao_w,'N') = 'N') then
				ds_evento_w := substr(wheb_mensagem_pck.get_texto(1108060,'DS_EVENTO_P=' || ds_evento_p),1,255);
			else
				ds_evento_w := substr(wheb_mensagem_pck.get_texto(1108059,'DS_OBSERVACAO_P=' || ds_observacao_w ||';DS_EVENTO_P=' || ds_evento_p),1,255);
			end if;
		end if;

		update	atend_pac_dispositivo
		set	ds_observacao	=	ds_evento_w
		where	nr_sequencia		=	nr_seq_registro_p;

		if (ie_retirar_alta_p	= 'S') then
			select	obter_acao_procedimento_alta(nr_seq_outra_acao_p, nr_seq_dispositivo_p)
			into STRICT	ie_acao_w
			;

			if (ie_acao_w	= 'A') then
				update	atend_pac_dispositivo
				set	dt_retirada		=	dt_registro_p,
					ie_acao			=	ie_acao_w
				where	nr_sequencia		=	nr_seq_registro_p;
			end if;
		end if;

		insert into atend_pac_disp_proc(
			nr_sequencia,
			nr_seq_disp_pac,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_proc_interno,
			dt_procedimento,
			cd_pessoa_fisica,
			cd_setor_atendimento,
      ds_observacao)
		values (
			nextval('atend_pac_disp_proc_seq'),
			nr_seq_registro_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_outra_acao_p,
			dt_registro_p,
			cd_pessoa_fisica_w,
			campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')),
      ds_evento_p);

			nr_sequencia_w := nr_seq_registro_p;

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

		end;
	elsif (ie_opcao_p = 'E') and (nr_seq_evento_p > 0) and (nr_seq_registro_p > 0) then
		begin

		dt_liberacao_w	:= null;
		if (ie_liberar_p	= 'S') then
			dt_liberacao_w	:= clock_timestamp();
		end if;

		ds_evento_w	:= substr(ds_evento_p,1,4000);

		select	nextval('qua_evento_paciente_seq')
		into STRICT	nr_seq_qua_evento_p
		;

		insert into qua_evento_paciente(
			nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			nr_atendimento,
			nr_seq_evento,
			dt_evento,
			ds_evento,
			cd_setor_atendimento,
			dt_cadastro,
			nm_usuario_origem,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nm_usuario_reg,
			nr_seq_disp_pac,
			nr_seq_classif_evento,
			dt_liberacao,
			cd_pessoa_fisica,
			ie_status,
			ie_origem,
			ie_situacao,
			nr_seq_assinatura,
			ie_tipo_evento,
			cd_profissional,
			ds_disposicao_imediata)
		values (
			nr_seq_qua_evento_p,
			cd_estabelecimento_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_atendimento_p,
			nr_seq_evento_p,
			dt_registro_p,
			ds_evento_w,
			cd_setor_atendimento_w,
			dt_registro_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_registro_p,
			nr_seq_classif_evento_p,
			dt_liberacao_w,
			Obter_pessoa_atendimento(nr_atendimento_p,'C'),
			'1',
			'S',
			'A',
			CASE WHEN nr_seq_assinatura_p=0 THEN null  ELSE nr_seq_assinatura_p END ,
			'E',
			cd_profissional_p,
			ds_acao_imediata_p);

		select	coalesce(max(ie_troca_curativo),'N')
		into STRICT	ie_troca_curativo_w
		from	qua_evento
		where	nr_sequencia = nr_seq_evento_p;

		select	coalesce(max(qt_hora_perm_curat),0)
		into STRICT	qt_hora_perm_curat_w
		from	atend_pac_dispositivo
		where	nr_sequencia = nr_seq_registro_p;

		if	(ie_troca_curativo_w = 'S' AND qt_hora_perm_curat_w > 0) then
			update	atend_pac_dispositivo
			set 	dt_retir_prev_curat = clock_timestamp() + (qt_hora_perm_curat_w / 24)
			where	nr_sequencia = nr_seq_registro_p;
		end if;

		ie_retirar_evento_w := Obter_Param_Usuario(-2010, 1, Obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_retirar_evento_w);

		if (ie_retirar_evento_w = 'S') then
			CALL Retirar_dispositivo_adep(nr_seq_proc_interno_w, nr_seq_dispositivo_p, ie_opcao_disp_p, dt_registro_p, nr_seq_motivo_ret_p, nr_seq_registro_p, nr_atendimento_p, nm_usuario_p, ds_evento_w);
		end if;

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

		end;
	elsif (ie_opcao_p = 'S') then
		begin

		ie_acao_w	:= obter_acao_procedimento(nr_seq_acao_disp_p, nr_seq_dispositivo_p,coalesce(ie_opcao_disp_p,'P'));

		update	atend_pac_dispositivo
		set	dt_retirada		=	dt_registro_p,
			nr_seq_motivo_ret	=	nr_seq_motivo_ret_p,
			ie_acao			=	coalesce(ie_acao_w, ie_acao)
		where	nr_sequencia		=	nr_seq_registro_p;

		if (ie_gerar_evolucao_w = 'S') then
			select	coalesce(substr(obter_descricao_padrao('DISPOSITIVO','DS_DISPOSITIVO',max(a.nr_seq_dispositivo)),1,80),obter_desc_expressao(342959)) 			    		ds_dispositivo, substr(obter_hint_graf_niss_adep(max(a.nr_sequencia)),1,4000) ds_hint
			into STRICT	ds_dispositivo_w,
				ds_hint_w
			from	atend_pac_dispositivo a
			where	obter_se_exibe_graf_disp(a.nr_sequencia) = 'S'
			and	a.nr_atendimento = nr_atendimento_p
			and	a.nr_sequencia 	= nr_seq_registro_p;
			--ds_hint_w := substr(ds_hint_w || chr(13) || ' Retirado em: ' || to_char(dt_registro_p,'dd/mm/yyyy hh24:mi:ss') || ' por ' || 					substr(obter_nome_pf(cd_pessoa_fisica_w),1,80),1,4000);
			ds_hint_w := substr(ds_hint_w || chr(13) || WHEB_MENSAGEM_PCK.get_texto(458429,'dt_registro_p='|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_registro_p, 'timestamp', cd_estabelecimento_w, nm_usuario_p) ||';nm_pessoa_fisica='|| substr(obter_nome_pf(cd_pessoa_fisica_w),1,80)),1,4000);

			cd_evolucao_w := Gerar_evolPaci_automa('DISP', nm_usuario_p, nr_atendimento_p, ds_dispositivo_w, null, 'D', ds_hint_w, dt_registro_p, null, null, null, null, cd_evolucao_w, 'S', null, nr_seq_registro_p, ie_opcao_disp_p, nr_seq_acao_disp_p);
		end if;

		if (nr_seq_acao_disp_p > 0 ) and
			((coalesce(ie_opcao_disp_p,'P') <> 'SAE') or
			((coalesce(ie_opcao_disp_p,'P') = 'SAE') and (coalesce(nr_seq_proc_SAE_w,0) > 0))) and (campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')) > 0) then
			begin

			Select	nextval('atend_pac_disp_proc_seq')
			into STRICT	nr_seq_disp_proc_w
			;

			insert into atend_pac_disp_proc(
				nr_sequencia,
				nr_seq_disp_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				dt_procedimento,
				cd_pessoa_fisica,
				cd_setor_atendimento,
        ds_observacao)
			values (
				nr_seq_disp_proc_w,
				nr_seq_registro_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_interno_w,
				dt_registro_p,
				cd_pessoa_fisica_w,
				campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')),
        ds_observacao_p);
			end;
		end if;

		select	nr_seq_dispositivo
		into STRICT	nr_seq_dispositivo_w
		from	atend_pac_dispositivo
		where	nr_sequencia		= nr_seq_registro_p;

		select	nextval('atend_pac_dispositivo_seq')
		into STRICT	nr_sequencia_w
		;

		ie_acao_w	:= obter_acao_procedimento(nr_seq_acao_instal_p, nr_seq_dispositivo_w,coalesce(ie_opcao_disp_p,'P'));

		insert into atend_pac_dispositivo(
			nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_dispositivo,
			nr_seq_topografia,
			dt_instalacao,
			nr_cirurgia,
			qt_tentativas,
			qt_disp_utilizados,
			dt_retirada_prev,
			ie_acao,
			cd_profissional,
			nr_seq_pepo,
			nr_seq_assinatura,
			ie_bronco,
			ie_inconsciente,
			ie_sne,
			ie_sucesso,
			nr_seq_calibre,
			ds_observacao,
			dt_retirada,
			ie_lado,
			nr_seq_motivo_ret,
			ds_justificativa_retro)
		values (
			nr_sequencia_w,
			nr_atendimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_dispositivo_w,
			CASE WHEN nr_seq_topografia_p=0 THEN null  ELSE nr_seq_topografia_p END ,
			dt_registro_p,
			nr_cirurgia_p,
			qt_tentativas_p,
			qt_dispositivos_p,
			dt_ret_prev_p,
			ie_acao_w,
			cd_profissional_p,
			nr_seq_pepo_p,
			CASE WHEN nr_seq_assinatura_p=0 THEN null  ELSE nr_seq_assinatura_p END ,
			ie_bronco_p,
			ie_inconsciente_p,
			ie_sne_p,
			ie_sucesso_p,
			nr_seq_calibre_p,
			ds_observacao_p,
			CASE WHEN ie_sucesso_p='N' THEN clock_timestamp()  ELSE null END ,
			ie_lado_p,
			nr_seq_motivo_ret_p,
			ds_justificativa_retro_p);

		if (nr_seq_acao_instal_p > 0) and (campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')) > 0) then
			begin

			Select	nextval('atend_pac_disp_proc_seq')
			into STRICT	nr_seq_disp_proc_w
			;

			insert into atend_pac_disp_proc(
				nr_sequencia,
				nr_seq_disp_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				dt_procedimento,
				cd_pessoa_fisica,
				cd_setor_atendimento,
        ds_observacao)
			values (
				nr_seq_disp_proc_w,
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_acao_instal_p,
				dt_registro_p,
				cd_pessoa_fisica_w,
				campo_numerico(Obter_Unidade_Atendimento(nr_atendimento_p,'A','CS')),
        ds_observacao_p);
			end;
		end if;

		select	coalesce(substr(obter_descricao_padrao('DISPOSITIVO','DS_DISPOSITIVO',max(a.nr_seq_dispositivo)),1,80),obter_desc_expressao(342959)) ds_dispositivo,
				substr(obter_hint_graf_niss_adep(max(a.nr_sequencia)),1,4000) ds_hint
		into STRICT	ds_dispositivo_w,
				ds_hint_w
		from	atend_pac_dispositivo a
		where	((coalesce(a.dt_retirada::text, '') = '') or (coalesce(ie_acao_w,'xpt') = 'U'))
		and		obter_se_exibe_graf_disp(a.nr_sequencia) = 'S'
		and		a.nr_atendimento = nr_atendimento_p
		and		a.nr_sequencia = nr_sequencia_w;

		if (ie_gerar_evolucao_w = 'S') then
			cd_evolucao_w := Gerar_evolPaci_automa('DISP', nm_usuario_p, nr_atendimento_p, ds_dispositivo_w, null, 'A', ds_hint_w, dt_registro_p, null, null, null, null, cd_evolucao_w, 'S', null, nr_sequencia_w, ie_opcao_disp_p, nr_seq_acao_disp_p);
		end if;

		CALL ADEP_cobranca_dispositivo(nr_atendimento_p,nr_seq_dispositivo_p,nr_seq_disp_proc_w ,nm_usuario_p,'S',ie_acao_w, nr_sequencia_w);

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

		end;
	end if;

	if (nr_seq_motivo_ret_p > 0) then
		select	coalesce(max(nr_seq_evento),0)
		into STRICT	nr_seq_evento_w
		from	motivo_retirada_disp
		where	nr_sequencia = nr_seq_motivo_ret_p;

		if (nr_seq_evento_w > 0) then
			begin

			dt_liberacao_w	:= null;
			if (ie_liberar_p	= 'S') then
				dt_liberacao_w	:= clock_timestamp();
			end if;

			select	max(ds_motivo)
			into STRICT	ds_motivo_w
			from    motivo_retirada_disp
			where   ie_situacao = 'A'
			and	nr_sequencia	= nr_seq_motivo_ret_p;

			select	max(substr(obter_descricao_padrao('DISPOSITIVO','DS_DISPOSITIVO',nr_seq_dispositivo),1,80))
			into STRICT	ds_dispositivo_w
			from	atend_pac_dispositivo
			where	nr_sequencia	= nr_seq_registro_p;

			select	max(ie_classificacao)
			into STRICT	ie_classificacao_w
			from	qua_classif_evento a
			where	nr_sequencia	= (	SELECT	nr_seq_classif
										from	qua_evento x
										where	x.nr_sequencia = nr_seq_evento_w);

			select	nextval('qua_evento_paciente_seq')
			into STRICT	nr_seq_qua_evento_p
			;

			insert into qua_evento_paciente(
				nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				nr_atendimento,
				nr_seq_evento,
				dt_evento,
				ds_evento,
				cd_setor_atendimento,
				dt_cadastro,
				nm_usuario_origem,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nm_usuario_reg,
				nr_seq_disp_pac,
				nr_seq_classif_evento,
				dt_liberacao,
				cd_pessoa_fisica,
				ie_status,
				ie_origem,
				ie_situacao,
				nr_seq_assinatura,
				ie_tipo_evento,
				ie_classificacao,
				cd_profissional,
				ds_disposicao_imediata,
				cd_funcao_ativa)
			values (
				nr_seq_qua_evento_p,
				cd_estabelecimento_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_atendimento_p,
				nr_seq_evento_w,
				dt_registro_p,
				/*'Evento gerado pelo sistema por motivo da retirada de dispositivo' || chr(13) ||
				'Motivo Retirada: ' || ds_motivo_w || chr(13) ||
				'Dispositivo: ' || ds_dispositivo_w || chr(13)||
				ds_evento_p,*/
				WHEB_MENSAGEM_PCK.get_texto(458434,'ds_motivo_w='|| ds_motivo_w ||
				';ds_dispositivo_w='|| ds_dispositivo_w ||
				';ds_evento_p='|| ds_evento_p),
				cd_setor_atendimento_w,
				dt_registro_p,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_registro_p,
				nr_seq_classif_evento_p,
				dt_liberacao_w,
				Obter_pessoa_atendimento(nr_atendimento_p,'C'),
				'1',
				'S',
				'A',
				CASE WHEN nr_seq_assinatura_p=0 THEN null  ELSE nr_seq_assinatura_p END ,
				'E',
				ie_classificacao_w,
				cd_profissional_p,
				ds_acao_imediata_p,
				obter_funcao_ativa);

			end;
		end if;
	end if;
end if;
nr_seq_disp_atend_p	:= nr_sequencia_w;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

CALL ATUALIZAR_EV_LINHA_CUIDADO('DI', 'DISPOSITIVO', nr_seq_dispositivo_p,
  'nr_seq_dispositivo_w=' || coalesce(nr_seq_dispositivo_p, 0) || ';ie_acao_w=' || coalesce(ie_opcao_p, 0),
  Obter_pessoa_atendimento(nr_atendimento_p,'C'), nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_dipositivo ( dt_registro_p timestamp, nr_seq_registro_p bigint, nr_seq_dispositivo_p bigint, nr_seq_acao_disp_p bigint, nr_seq_acao_instal_p bigint, nr_seq_outra_acao_p bigint, nr_seq_evento_p bigint, nr_seq_classif_evento_p bigint, ds_evento_p text, nr_atendimento_p bigint, nr_seq_topografia_p bigint, ie_lado_p text, ds_titulo_p text, nm_usuario_p text, ie_opcao_p text, ds_compl_topo_p text, dt_retirada_p timestamp, hr_permanencia_p bigint, dt_ret_prev_p timestamp, cd_profissional_p text, nr_cirurgia_p bigint default null, dt_retirada_curativo_p timestamp DEFAULT NULL, qt_horas_cur_p bigint DEFAULT NULL, nr_seq_motivo_ret_p bigint DEFAULT NULL, qt_tentativas_p bigint DEFAULT NULL, qt_dispositivos_p bigint DEFAULT NULL, ie_liberar_p text DEFAULT NULL, ie_retirar_alta_p text DEFAULT NULL, ie_opcao_disp_p text DEFAULT NULL, nr_seq_disp_atend_p INOUT bigint DEFAULT NULL, nr_seq_calibre_p bigint default null, nr_seq_pepo_p bigint DEFAULT NULL, nr_seq_assinatura_p bigint default null, ie_bronco_p text default 'N', ie_Inconsciente_p text default 'N', ie_sne_p text default 'N', ie_sucesso_p text default 'S', cd_setor_atendimento_p bigint default null, ds_observacao_p text default null, nr_seq_qua_evento_p INOUT bigint DEFAULT NULL, ds_acao_imediata_p text default null, nr_seq_complemento_p bigint default null, ds_justificativa_retro_p text default null) FROM PUBLIC;
