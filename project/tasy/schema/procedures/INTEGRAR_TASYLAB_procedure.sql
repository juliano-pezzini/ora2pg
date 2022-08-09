-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function integrar_tasylab as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE integrar_tasylab ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_evento_p bigint, cd_material_exame_p text, nr_seq_lote_externo_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_alter_p bigint, nm_tabela_p text, ie_operacao_p bigint default null, --operação em tabela (Insert, Update or Delete)
 ie_commit_p text default 'S', ds_alteracao_p text default null) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL integrar_tasylab_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(nr_seq_prescr_p) || ',' || quote_nullable(nr_seq_evento_p) || ',' || quote_nullable(cd_material_exame_p) || ',' || quote_nullable(nr_seq_lote_externo_p) || ',' || quote_nullable(cd_funcao_p) || ',' || quote_nullable(cd_perfil_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(cd_estabelecimento_p) || ',' || quote_nullable(nr_sequencia_alter_p) || ',' || quote_nullable(nm_tabela_p) || ',' || quote_nullable(ie_operacao_p) || ',' || quote_nullable(
) || ',' || quote_nullable(ds_alteracao_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE integrar_tasylab_atx ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_evento_p bigint, cd_material_exame_p text, nr_seq_lote_externo_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_alter_p bigint, nm_tabela_p text, ie_operacao_p bigint default null,
 ie_commit_p text default 'S', ds_alteracao_p text default null) AS $body$
DECLARE


ds_sep_bv_w			varchar(100);
ds_param_integ_hl7_w		varchar(4000);
ds_param_temp_w			varchar(4000);
nr_seq_agend_integ_w		agendamento_integracao.nr_sequencia%type;

ie_VarInformaMotivoRecoleta_w	varchar(2);
ie_VarRetiraDtIntegracao_w	varchar(2);
ds_VarStatusRecoleta_w		varchar(255);
cd_exame_integr_w		varchar(255);

ie_gerar_mensagem_w		varchar(1);
ie_existe_w			varchar(1);
ds_msg_w			varchar(255);

C01 CURSOR FOR
	SELECT	a.nr_seq_externo
	from	lab_tasylab_cliente a
	where	(a.ds_url_webservice IS NOT NULL AND a.ds_url_webservice::text <> '');

c02 CURSOR FOR
	SELECT	a.nr_prescricao,
			b.cd_pessoa_fisica
	from	prescr_procedimento a,
			prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and		a.nr_seq_lote_externo = nr_seq_lote_externo_p
	--and		a.dt_envio_integracao is null
	group by a.nr_prescricao, b.cd_pessoa_fisica;

/*cursor c03 is
	select	a.nr_sequencia
	from	agendamento_integracao a
	where	a.nr_seq_evento = nr_seq_evento_p
	and		substr(a.ds_parametros, 1, length(ds_param_integ_hl7_w)) = ds_param_integ_hl7_w;*/
c01_w	c01%rowtype;
c02_w	c02%rowtype;
--c03_w	c03%rowtype;
procedure job_gravar_agend_integracao(
		nr_seq_evento_p 		 bigint,
		ds_parametros_p 		 text,
		cd_estabelecimento_p 	 bigint := 1,
		cd_setor_atendimento_p	 bigint := null) as

ret_w 			varchar(4000);
pos_w 			integer;
nr_seq_log_w 		bigint;
nm_usuario_w 		varchar(15);
desc_evento_w 		varchar(4000);
ie_situacao_w 		varchar(1);
nr_controle_w 		bigint;
cd_estabelecimento_w  	bigint;
cd_setor_atendimento_w	bigint;
ie_status_w		varchar(1) := 'T';
qt_ocorrencias_w	integer := 0;
query				varchar(2000);
BEGIN

	nr_controle_w := 0;
	--desc_evento_w := Wheb_mensagem_pck.get_texto(308849) /*'Evento:'*/ || nr_seq_evento_p || '. ' || Wheb_mensagem_pck.get_texto(308850) || ':' /*'. Parametros utilizados:'*/ || ds_parametros_p;
	desc_evento_w := 'Evento:' || nr_seq_evento_p || '. Parametros utilizados:' || ds_parametros_p;

	--nm_usuario_w :=  nvl(wheb_usuario_pck.get_nm_usuario,'SYSTEM');
	nm_usuario_w	:= 'SYSTEM';

	ret_w := gravar_log_integracao(nm_usuario_w, nr_seq_evento_p, ds_parametros_p, 'N', 'S', ret_w, cd_estabelecimento_p, cd_setor_atendimento_p);
	ret_w := ret_w || ';';

	while( position(';' in ret_w) > 0 ) and ( nr_controle_w < 1000)  loop
		nr_controle_w := nr_controle_w + 1;
		pos_w := position(';' in ret_w);
		nr_seq_log_w := (substr(ret_w, 0, pos_w-1))::numeric;
		ret_w := substr(ret_w, pos_w+1, length(ret_w));

		if (nr_seq_log_w IS NOT NULL AND nr_seq_log_w::text <> '') then

			insert into log_integracao_evento(
				nr_sequencia,
				nr_seq_log,
				ie_tipo_evento,
				ie_envio_retorno,
				cd_evento,
				ds_observacao,
				dt_atualizacao,
				nm_usuario
			) VALUES (
				nextval('log_integracao_evento_seq'),
				nr_seq_log_w,
				'I',
				'E',
				'GM',
				desc_evento_w,
				clock_timestamp(),
				'Gerenciador' /* Wheb_mensagem_pck.get_texto(308851) */
			);

			begin

			select 	c.ie_situacao
			into STRICT 	ie_situacao_w
			from  	cliente_integracao c,
					log_integracao l
			where 	l.nr_seq_informacao = c.nr_seq_inf_integracao
			and   	l.nr_sequencia = nr_seq_log_w
			and   	coalesce(c.cd_estabelecimento_destino, cd_estabelecimento_p) = cd_estabelecimento_p
			and   	coalesce(c.cd_setor_atendimento, 9999) = coalesce(cd_setor_atendimento_p,9999);

			cd_setor_atendimento_w := cd_setor_atendimento_p;

			exception

			when no_data_found  then
				begin

				cd_setor_atendimento_w := null;

				select 	c.ie_situacao
				into STRICT 	ie_situacao_w
				from  	cliente_integracao c,
						log_integracao l
				where 	l.nr_seq_informacao = c.nr_seq_inf_integracao
				and   	l.nr_sequencia = nr_seq_log_w
				and   	coalesce(c.cd_estabelecimento_destino, cd_estabelecimento_p) = cd_estabelecimento_p
				and		coalesce(c.cd_setor_atendimento::text, '') = '';

				end;

			end;

			if (ie_situacao_w = 'P') then
			begin

			  update log_integracao set ie_status = 'I';

			  insert into log_integracao_evento(
			    nr_sequencia,
			    nr_seq_log,
			    ie_tipo_evento,
			    ie_envio_retorno,
			    cd_evento,
			    ds_observacao,
			    dt_atualizacao,
			    nm_usuario
			  ) VALUES (
			    nextval('log_integracao_evento_seq'),
			    nr_seq_log_w,
			    'I',
			    'E',
			    'I',
			    'Integração Parada', /* Wheb_mensagem_pck.get_texto(308853), */
			    clock_timestamp(),
			    'Gerenciador' /* Wheb_mensagem_pck.get_texto(308851) */
			  );
			end;
			else
			begin

			cd_estabelecimento_w := cd_estabelecimento_p;
			if ((cd_estabelecimento_w = 1) or (cd_estabelecimento_w = 0)) then

				select 	coalesce(max(cd_estabelecimento),0)
				into STRICT	cd_estabelecimento_w
				from	estabelecimento
				where	cd_estabelecimento = cd_estabelecimento_w;

				if (cd_estabelecimento_w = 0) then
					select 	coalesce(min(cd_estabelecimento),1)
					into STRICT	cd_estabelecimento_w
					from	estabelecimento;

				end if;
			end if;

			ie_status_w := 'T';

			begin
				select count(1)
				  into STRICT qt_ocorrencias_w
				  from log_integracao_evento
				 where nr_seq_log     = nr_seq_log_w
				   and ie_tipo_evento = 'O'
				   and cd_evento      = 'ER';
			exception
				when others then
					qt_ocorrencias_w := 0;
			end;

			if (qt_ocorrencias_w > 0) then
				ie_status_w := 'O';
			end if;

			insert into agendamento_integracao(
				nr_sequencia,
				nr_seq_evento,
				ds_parametros,
				nr_seq_log,
				ie_status,
				id_processo,
				nr_processo_debug,
				dt_atualizacao,
				nm_usuario,
				cd_estabelecimento,
				cd_setor_atendimento
			) values (
				nextval('agendamento_integracao_seq'),
				nr_seq_evento_p,
				ds_parametros_p,
				nr_seq_log_w,
				ie_status_w,
				'P',
				'0',
				clock_timestamp(),
				nm_usuario_w,
				cd_estabelecimento_w,
				cd_setor_atendimento_w
			);
			end;
			end if;
		end if;
	end loop;

	commit;


end;


BEGIN

ds_param_integ_hl7_w	:= '0';

IF 	((nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') or (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') or (nr_seq_lote_externo_p IS NOT NULL AND nr_seq_lote_externo_p::text <> '') or (nr_sequencia_alter_p IS NOT NULL AND nr_sequencia_alter_p::text <> '') or (ds_alteracao_p IS NOT NULL AND ds_alteracao_p::text <> '')) AND (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') THEN

	ds_sep_bv_w := ';'; --obter_separador_bv;
	if (nr_seq_evento_p = 221) then

		/*select	decode(count(*),0,'N','S')
		into	ie_gerar_mensagem_w
		from	prescr_procedimento
		where	nr_prescricao = nr_prescricao_p
		and		nr_sequencia = nr_seq_prescr_p;*/
		--if	(ie_gerar_mensagem_w = 'S') then
		ds_param_integ_hl7_w :=	'nr_prescricao=' || nr_prescricao_p || ds_sep_bv_w ||
						'nr_seq_prescricao=' || nr_seq_prescr_p || ds_sep_bv_w ||
						'cd_estabelecimento=' || cd_estabelecimento_p || ds_sep_bv_w;
		--end if;
		/*open c03;
		loop
		fetch c03 into c03_w;
			exit when c03%notfound;
			begin
			ds_param_integ_hl7_w	:= '0';

			select	decode(count(*), 0, 'N', 'S')
			into	ie_existe_w
			from	agendamento_integracao a
			where	a.nr_sequencia = c03_w.nr_sequencia
			and		a.nr_seq_log is not null;

			if	(ie_existe_w = 'S') then
				REGERAR_XML_INTEGRACAO(c03_w.nr_sequencia);
			end if;

			update	agendamento_integracao
			set		ie_status = 'T'
			where	nr_sequencia = c03_w.nr_sequencia;

			if (ie_commit_p = 'S') then
				COMMIT;
			end if;

			end;
		end loop;
		close c03;
		*/
		if (ds_param_integ_hl7_w IS NOT NULL AND ds_param_integ_hl7_w::text <> '') and (ds_param_integ_hl7_w <> '0') then
			CALL gravar_agend_integracao(nr_seq_evento_p, ds_param_integ_hl7_w);
		end if;
		ds_param_integ_hl7_w	:= '0';
		ie_gerar_mensagem_w	:= 'N';

		CALL gravar_log_lab(90001,'integrar_tasylab(221) - nr_prescricao_p: '||nr_prescricao_p||' nr_seq_prescr_p: '||nr_seq_prescr_p||' cd_material_exame_p: '||cd_material_exame_p||' nr_seq_evento_p: '||nr_seq_evento_p||' cd_estabelecimento_p: '||cd_estabelecimento_p||' ds_param_integ_hl7_w: '||ds_param_integ_hl7_w||'  ie_gerar_mensagem_w: '||ie_gerar_mensagem_w,'TasyLab',nr_prescricao_p,'TASYLAB');

	elsif (nr_seq_evento_p = 224) then

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_mensagem_w
		from	lab_tasylab_cli_prescr a
		where	a.nr_prescricao = nr_prescricao_p;

		if (ie_gerar_mensagem_w = 'S') then
			ie_VarInformaMotivoRecoleta_w	:= Obter_Valor_Param_Usuario(cd_funcao_p, 29, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p);
			ie_VarRetiraDtIntegracao_w	:= Obter_Valor_Param_Usuario(cd_funcao_p, 60, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p);
			ds_VarStatusRecoleta_w		:= coalesce(Obter_Valor_Param_Usuario(cd_funcao_p, 12, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p),'20');

			ds_param_integ_hl7_w :=	'nr_prescricao=' || nr_prescricao_p || ds_sep_bv_w ||
						'nr_seq_prescricao=' || nr_seq_prescr_p || ds_sep_bv_w ||
						'cd_material_exame=' || cd_material_exame_p || ds_sep_bv_w ||
						'cd_estabelecimento=' || cd_estabelecimento_p || ds_sep_bv_w||
						'ie_informa_motivo_recoleta=' || ie_VarInformaMotivoRecoleta_w || ds_sep_bv_w ||
						'ie_retira_dt_integracao=' || ie_VarRetiraDtIntegracao_w || ds_sep_bv_w ||
						'ds_status_recoleta=' || ds_VarStatusRecoleta_w || ds_sep_bv_w;

			CALL gravar_log_lab(90001,
				'integrar_tasylab(224) - nr_prescricao_p: '||nr_prescricao_p||
				' nr_seq_prescr_p: '||nr_seq_prescr_p||
				' cd_material_exame_p: '||cd_material_exame_p||
				' nr_seq_evento_p: '||nr_seq_evento_p||
				' cd_estabelecimento_p: '||cd_estabelecimento_p||
				' ie_informa_motivo_recoleta='|| ie_VarInformaMotivoRecoleta_w ||
				' ie_retira_dt_integracao=' || ie_VarRetiraDtIntegracao_w ||
				'ds_status_recoleta_w=' || ds_VarStatusRecoleta_w ||
				' ds_param_integ_hl7_w: '||ds_param_integ_hl7_w,'TasyLab',nr_prescricao_p,'TASYLAB');
		end if;

	elsif (nr_seq_evento_p = 230) then

		ie_gerar_mensagem_w	:= 'N';

		open c02;
		loop
		fetch c02 into c02_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			ds_param_integ_hl7_w :=	'nr_seq_lote=' || nr_seq_lote_externo_p || ds_sep_bv_w ||
									'nr_prescricao=' || c02_w.nr_prescricao || ds_sep_bv_w ||
									'cd_estabelecimento=' || cd_estabelecimento_p || ds_sep_bv_w||
									'cd_pessoa_fisica=' || c02_w.cd_pessoa_fisica || ds_sep_bv_w||
									'ultimo_parametro=0'||ds_sep_bv_w;
									--Obs, o parâmetro "ultimo_parametro" é para controle, qualquer parâmetro adicional deve ser inserido antes dele.
			CALL gravar_agend_integracao(nr_seq_evento_p, ds_param_integ_hl7_w);

			/*open c03;
			loop
			fetch c03 into c03_w;
				exit when c03%notfound;
				begin
				ds_param_integ_hl7_w	:= '0';

				select	decode(count(*), 0, 'N', 'S')
				into	ie_existe_w
				from	agendamento_integracao a
				where	a.nr_sequencia = c03_w.nr_sequencia
				and		a.nr_seq_log is not null;

				if	(ie_existe_w = 'S') then
					REGERAR_XML_INTEGRACAO(c03_w.nr_sequencia);
				end if;

				update	agendamento_integracao
				set		ie_status = 'T'
				where	nr_sequencia = c03_w.nr_sequencia;

				if (ie_commit_p = 'S') then
					COMMIT;
				end if;

				end;
			end loop;
			close c03;

			if	(ds_param_integ_hl7_w is not null) and
				(ds_param_integ_hl7_w <> '0') then
				gravar_agend_integracao(nr_seq_evento_p, ds_param_integ_hl7_w);
				ds_param_integ_hl7_w	:= '0';
				ie_gerar_mensagem_w	:= 'N';
			end if;*/
			end;
		end loop;
		close c02;

		/*open c02;
		loop
		fetch c02 into c02_w;
			exit when c02%notfound;
			begin

			ds_param_temp_w	:=	'nr_seq_lote=' || nr_seq_lote_externo_p || ds_sep_bv_w ||
								'cd_estabelecimento=' || cd_estabelecimento_p || ds_sep_bv_w ||
								'nr_prescricao=' || to_char(c02_w.nr_prescricao) || ds_sep_bv_w ||
								'nr_seq_prescricao=' || to_char(c02_w.nr_sequencia) || ds_sep_bv_w;

			select	max(a.nr_sequencia)
			into	nr_seq_agend_integ_w
			from	agendamento_integracao a
			where	a.nr_seq_evento = 230
			and		substr(a.ds_parametros,1,length(ds_param_temp_w)) = ds_param_temp_w;

			if (nr_seq_agend_integ_w is not null) then

				select	decode(count(*), 0, 'N', 'S')
				into	ie_existe_w
				from	agendamento_integracao a
				where	a.nr_sequencia = nr_seq_agend_integ_w
				and		a.nr_seq_log is not null;

				if	(ie_existe_w = 'S') then
					REGERAR_XML_INTEGRACAO(nr_seq_agend_integ_w);
				end if;

				update	agendamento_integracao
				set		ie_status = 'T'
				where	nr_sequencia = nr_seq_agend_integ_w;

			else
				gravar_agend_integracao(230, ds_param_temp_w);
			end if;

			gravar_log_lab(90001,'integrar_tasylab(230) - nr_seq_evento_p: '||nr_seq_evento_p||' cd_estabelecimento_p: '||cd_estabelecimento_p||' - Lote externo: '||nr_seq_lote_externo_p||' ds_param_integ_hl7_w: '||ds_param_integ_hl7_w,'TasyLab',nr_prescricao_p,'TASYLAB');

			if (ie_commit_p = 'S') then
				COMMIT;
			end if;

			end;
		end loop;
		close c02;*/
		/*select	decode(count(*), 0, 'N', 'S')
		into	ie_existe_w
		from	prescr_procedimento
		where	nr_seq_lote_externo = nr_seq_lote_externo_p
		and		dt_envio_integracao IS NULL;

		if	(ie_existe_w = 'S') then

			ds_param_integ_hl7_w :=	'nr_seq_lote=' || nr_seq_lote_externo_p || ds_sep_bv_w ||
									'cd_estabelecimento=' || cd_estabelecimento_p || ds_sep_bv_w;

			select	max(a.nr_sequencia)
			into	nr_seq_agend_integ_w
			from	agendamento_integracao a
			where	a.nr_seq_evento = 230
			and		substr(a.ds_parametros,1,length(ds_param_integ_hl7_w)) = ds_param_integ_hl7_w;

			if (nr_seq_agend_integ_w is not null) then

				ds_param_integ_hl7_w	:= '0';

				select	decode(count(*), 0, 'N', 'S')
				into	ie_existe_w
				from	agendamento_integracao a
				where	a.nr_sequencia = nr_seq_agend_integ_w
				and		a.nr_seq_log is not null;

				if	(ie_existe_w = 'S') then
					REGERAR_XML_INTEGRACAO(nr_seq_agend_integ_w);
				end if;

				update	agendamento_integracao
				set		ie_status = 'T'
				where	nr_sequencia = nr_seq_agend_integ_w;

			end if;

		end if;
		*/
		CALL gravar_log_lab(90001,'integrar_tasylab(230) - nr_seq_evento_p: '||nr_seq_evento_p||' cd_estabelecimento_p: '||cd_estabelecimento_p||' - Lote externo: '||nr_seq_lote_externo_p||' - item: '||ie_existe_w||' - ds_param_integ_hl7_w: '||ds_param_integ_hl7_w,'TasyLab',nr_prescricao_p,'TASYLAB');

		/*if (ie_commit_p = 'S') then
			COMMIT;
		end if;*/
	elsif (nr_seq_evento_p = 265) then

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_mensagem_w
		from	lab_tasylab_cli_prescr a
		where	a.nr_prescricao = nr_prescricao_p;

		if (ie_gerar_mensagem_w = 'S') then
			ds_param_integ_hl7_w :=	'nr_prescricao=' || nr_prescricao_p || ds_sep_bv_w ||
									'nr_seq_prescricao=' || nr_seq_prescr_p || ds_sep_bv_w;

			CALL gravar_log_lab(90001,'integrar_tasylab(265) - '||'nr_prescricao: ' || nr_prescricao_p || ' - nr_seq_prescricao: ' || nr_seq_prescr_p, 'TasyLab',nr_prescricao_p,'TASYLAB');
		end if;
	end if;

	if (ie_gerar_mensagem_w = 'S') or (coalesce(ds_param_integ_hl7_w,'0') <> '0') then
		CALL gravar_agend_integracao(nr_seq_evento_p, ds_param_integ_hl7_w);
	end if;

	if (ie_commit_p = 'S') then
		
	end if;

	if (nr_seq_evento_p = 281) then

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_mensagem_w
		FROM	exame_historico a,
				lab_exame_equip b,
				equipamento_lab c
		WHERE	a.nr_seq_exame = b.nr_seq_exame
		AND		b.cd_equipamento = c.cd_equipamento
		AND		c.ds_sigla = 'TLAB'
		AND		a.nr_sequencia = nr_sequencia_alter_p;

		if (ie_gerar_mensagem_w = 'S') then
			open c01;
			loop
			fetch c01 into c01_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				CALL job_gravar_agend_integracao(281, 	'NR_SEQ_HISTORICO='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||
												'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w, coalesce(obter_estabelecimento_ativo, 1));
				CALL gravar_log_lab(90001,substr('integrar_tasylab(281) - '||'NR_SEQ_HISTORICO='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w,1,1000), 'TasyLab',null,'TASYLAB');

				if (ie_commit_p = 'S') then
					COMMIT;
				end if;
				end;
			end loop;
			close c01;
		end if;
	end if;

	if (nr_seq_evento_p = 296) then

		/*open c01;
		loop
		fetch c01 into c01_w;
			exit when c01%notfound;
			begin
			gravar_agend_integracao(296, 	'NR_SEQUENCIA='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||
											'IE_TABELA_ALTERADA='||to_char(ie_tipo_p)||ds_sep_bv_w||
											'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w);
			gravar_log_lab(90001,substr('integrar_tasylab(296) - '||'NR_SEQUENCIA='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||'IE_TABELA_ALTERADA='||to_char(ie_tipo_p)||ds_sep_bv_w||'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w,1,1000), 'TasyLab',null,'TASYLAB');

			if (ie_commit_p = 'S') then
				COMMIT;
			end if;
			end;
		end loop;
		close c01;*/
		/*if	(ie_tipo_p = 1) then
			nm_tabela_w	:= 'LAB_EQUIP_MAQUINA';
		elsif	(ie_tipo_p = 2) then
			nm_tabela_w	:= 'LAB_EQUIP_MAQUINA_EXAME';
		end if;*/
		open c01;
		loop
		fetch c01 into c01_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			 if (wheb_usuario_pck.is_evento_ativo(nr_seq_evento_p) = 'S') then

				if (ie_operacao_p = 1) or (ie_operacao_p = 2) then
					CALL gravar_agend_integracao(nr_seq_evento_p,
						'NM_TABELA='||nm_tabela_p||ds_sep_bv_w||
						'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w||
						'NR_SEQUENCIA='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||
						'IE_OPERACAO='||to_char(coalesce(ie_operacao_p,'0'))||ds_sep_bv_w||
						'pck_cd_estabelecimento=' || wheb_usuario_pck.get_cd_estabelecimento || obter_separador_bv  ||
						'pck_nm_usuario=' || wheb_usuario_pck.get_nm_usuario || obter_separador_bv, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
				else
					CALL job_gravar_agend_integracao(nr_seq_evento_p,
						'NM_TABELA='||nm_tabela_p||ds_sep_bv_w||
						'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w||
						'NR_SEQUENCIA='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||
						'IE_OPERACAO='||to_char(coalesce(ie_operacao_p,'0'))||ds_sep_bv_w||
						'pck_cd_estabelecimento=' || wheb_usuario_pck.get_cd_estabelecimento || obter_separador_bv  ||
						'pck_nm_usuario=' || wheb_usuario_pck.get_nm_usuario || obter_separador_bv, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
				end if;
				/*gravar_agend_integracao(nr_seq_evento_p,
					'NM_TABELA='||nm_tabela_p||ds_sep_bv_w||
					'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w||
					'NR_SEQUENCIA='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||
					'IE_OPERACAO='||to_char(nvl(ie_operacao_p,'0'))||ds_sep_bv_w||
					'pck_cd_estabelecimento=' || wheb_usuario_pck.get_cd_estabelecimento || obter_separador_bv  ||
					'pck_nm_usuario=' || wheb_usuario_pck.get_nm_usuario || obter_separador_bv);*/
					--insert into andrey(ds) values('teste');
					--tmp2(296, 'NM_TABELA=LAB_EXAME_DIA;CD_ORIGEM=1;NR_SEQUENCIA=1721;IE_OPERACAO=2;pck_cd_estabelecimento=2#@#@pck_nm_usuario=Wheb#@#@',2);
					--gravar_agend_integracao(296, 'NM_TABELA=LAB_EXAME_DIA;CD_ORIGEM=1;NR_SEQUENCIA=1721;IE_OPERACAO=2;pck_cd_estabelecimento=2#@#@pck_nm_usuario=Wheb#@#@',2);
				/*tmp(nr_seq_evento_p,
					'NM_TABELA='||nm_tabela_p||ds_sep_bv_w||
					'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w||
					'NR_SEQUENCIA='||to_char(nr_sequencia_alter_p)||ds_sep_bv_w||
					'IE_OPERACAO='||to_char(nvl(ie_operacao_p,'0'))||ds_sep_bv_w||
					'pck_cd_estabelecimento=' || wheb_usuario_pck.get_cd_estabelecimento || obter_separador_bv  ||
					'pck_nm_usuario=' || wheb_usuario_pck.get_nm_usuario || obter_separador_bv, nvl(wheb_usuario_pck.get_cd_estabelecimento,1));*/
			 end if;

			end;
		end loop;
		close c01;
	end if;

	if (nr_seq_evento_p = 308) then

		open c01;
		loop
		fetch c01 into c01_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			CALL gravar_agend_integracao(nr_seq_evento_p, 	'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w||
											'DS_ALTERACAO_P='||ds_alteracao_p||ds_sep_bv_w);
			CALL gravar_log_lab(90001,substr('integrar_tasylab(308) - '||'CD_ORIGEM='||to_char(c01_w.nr_seq_externo)||ds_sep_bv_w||
										'DS_ALTERACAO_P='||ds_alteracao_p||ds_sep_bv_w,1,1000), 'TasyLab',null,'TASYLAB');

			if (ie_commit_p = 'S') then
				COMMIT;
			end if;
			end;
		end loop;
		close c01;
	end if;

END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integrar_tasylab ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_evento_p bigint, cd_material_exame_p text, nr_seq_lote_externo_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_alter_p bigint, nm_tabela_p text, ie_operacao_p bigint default null, ie_commit_p text default 'S', ds_alteracao_p text default null) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE integrar_tasylab_atx ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_evento_p bigint, cd_material_exame_p text, nr_seq_lote_externo_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_alter_p bigint, nm_tabela_p text, ie_operacao_p bigint default null, ie_commit_p text default 'S', ds_alteracao_p text default null) FROM PUBLIC;
