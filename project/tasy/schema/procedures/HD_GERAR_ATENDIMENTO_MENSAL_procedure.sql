-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_gerar_atendimento_mensal ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


dt_mes_ant_w			timestamp;
nr_atend_novo_w			bigint;
dt_alta_w			timestamp;
nr_atend_ant_w			bigint;
cd_pessoa_fisica_w		varchar(10);
nm_pessoa_fisica_w		varchar(255);
cd_estabelecimento_w		integer;
cd_motivo_alta_w		smallint;
ds_erro_w			varchar(2000);
ds_mensagem_w			varchar(2000);
cd_perfil_atend_w		integer;
ds_titulo_w			varchar(255);
nr_atend_mes_w			bigint;
cd_estab_w			integer;
cd_estab_unidade_w		integer;
ds_unidade_w			varchar(90);
qt_existe_atend_auto_w		bigint;
ie_tipo_atendimento_w		smallint;
cd_procedencia_w		integer;
ie_clinica_w			integer;
nr_seq_interno_w		bigint;
nr_seq_atual_atend_auto_w	bigint;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);
cd_setor_atendimento_w		integer;
nr_sequencia_ultimo_aten_w	bigint;
nr_atendimento_ocup_setor_w	bigint;
ds_erro_teste_w			varchar(255);
qt_apac_w			bigint;
ie_gerar_alta_fim_apac_w	varchar(15) := 'N';
nr_seq_queixa_w			bigint;
ie_gera_atend_conservador_w	varchar(1);
qt_trat_conservador_w		bigint;
qt_trat_w			bigint;
ie_gerar_atend_w		varchar(1);
ds_log_w_novo     pessoa_fisica.ds_observacao%type;

c01 CURSOR FOR /* Pacientes que tem prescricoes a ser geradas */
	SELECT	cd_pessoa_fisica,
		substr(obter_nome_pf(cd_pessoa_fisica),1,80),
		hd_obter_estab_unidade(hd_obter_unidade_prc(cd_pessoa_fisica,'C')),
		substr(hd_obter_desc_unid_dialise(hd_obter_unidade_prc(cd_pessoa_fisica,'C')),1,90)
	from	hd_pac_renal_cronico a
	where	hd_obter_se_paciente_ativo(cd_pessoa_fisica) = 'S'
	and (not exists (SELECT	1
				from	paciente_tratamento b
				where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
				and	coalesce(b.dt_final_tratamento::text, '') = ''
				and	b.ie_tratamento = 'CO') or (ie_gera_atend_conservador_w = 'S'));


BEGIN

dt_mes_ant_w := pkg_date_utils.add_month(pkg_date_utils.start_of(dt_referencia_p,'MONTH', 0),-1, 0);

ie_gera_atend_conservador_w := obter_param_usuario(7009, 207, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_gera_atend_conservador_w);

open c01;
	loop
	fetch c01 into
		cd_pessoa_fisica_w,
		nm_pessoa_fisica_w,
		cd_estab_unidade_w,
		ds_unidade_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	ds_mensagem_w		:= null;
	ie_gerar_atend_w	:= 'S';
	
	if (ie_gera_atend_conservador_w = 'S') then
	
		select	count(*)
		into STRICT	qt_trat_conservador_w
		from	paciente_tratamento b
		where	b.cd_pessoa_fisica = cd_pessoa_fisica_w
		and	coalesce(b.dt_final_tratamento::text, '') = ''
		and	b.ie_tratamento = 'CO';
		
		select 	count(*)
		into STRICT	qt_trat_w
		from	paciente_tratamento b
		where	b.cd_pessoa_fisica = cd_pessoa_fisica_w
		and	coalesce(b.dt_final_tratamento::text, '') = ''
		and	b.ie_tratamento <> 'CO';
	
		if (qt_trat_conservador_w > 0) and (qt_trat_w = 0) then
			ie_gerar_atend_w	:= 'N';		
		end if;
	
	end if;
	
	
	select 	coalesce(max(nr_atendimento),0),
		max(dt_alta),
		max(cd_estabelecimento)
	into STRICT	nr_atend_ant_w,
		dt_alta_w,
		cd_estabelecimento_w
	from 	atendimento_paciente a
	where	pkg_date_utils.start_of(dt_entrada,'MONTH', 0)	<= pkg_date_utils.start_of(dt_mes_ant_w,'MONTH', 0)
	and	cd_pessoa_fisica		= cd_pessoa_fisica_w
	and	cd_estabelecimento		= cd_estab_unidade_w
	and 	coalesce(a.dt_cancelamento::text, '') = ''
	and	exists (	SELECT 	1
			from 	hd_log_geracao_atend x 
			where 	a.nr_atendimento = x.nr_atendimento_nov)
	and	hd_obter_se_regra_atend(a.nr_atendimento) = 'S';

	if (nr_atend_ant_w = 0) then

		select 	coalesce(max(nr_atendimento),0),
			max(dt_alta),
			max(cd_estabelecimento)
		into STRICT	nr_atend_ant_w,
			dt_alta_w,
			cd_estabelecimento_w
		from 	atendimento_paciente a
		where	pkg_date_utils.start_of(dt_entrada,'MONTH', 0)	<= pkg_date_utils.start_of(dt_mes_ant_w,'MONTH', 0)
		and	cd_pessoa_fisica 		= cd_pessoa_fisica_w
		and	cd_estabelecimento		= cd_estab_unidade_w
		and 	coalesce(a.dt_cancelamento::text, '') = ''
		and	hd_obter_se_regra_atend(a.nr_atendimento) = 'S';
	end if;


	select 	coalesce(max(nr_atendimento),0)
	into STRICT	nr_atend_mes_w
	from 	atendimento_paciente a
	where	pkg_date_utils.start_of(dt_entrada,'MONTH', 0)	= pkg_date_utils.start_of(dt_referencia_p,'MONTH', 0)
	and	cd_pessoa_fisica 		= cd_pessoa_fisica_w
	and 	coalesce(a.dt_cancelamento::text, '') = ''
	and	exists (	SELECT	1
			from 	hd_log_geracao_atend x 
			where	a.nr_atendimento = x.nr_atendimento_nov)
	and	hd_obter_se_regra_atend(a.nr_atendimento) = 'S';

	if (nr_atend_mes_w = 0) and (ie_gerar_atend_w = 'S') then

		select 	coalesce(max(nr_atendimento),0)
		into STRICT	nr_atend_mes_w
		from 	atendimento_paciente a
		where	pkg_date_utils.start_of(dt_entrada,'MONTH', 0)	= pkg_date_utils.start_of(dt_referencia_p,'month')
		and	cd_pessoa_fisica		= cd_pessoa_fisica_w
		and 	coalesce(a.dt_cancelamento::text, '') = ''
		and	hd_obter_se_regra_atend(a.nr_atendimento) = 'S';

	end if;

	select 	max(cd_perfil_atend),
		coalesce(max(ie_gerar_alta_fim_apac),'N')
	into STRICT	cd_perfil_atend_w,
		ie_gerar_alta_fim_apac_w
	from	hd_parametro
	where	cd_estabelecimento = coalesce(cd_estabelecimento_w,cd_estabelecimento);
	
	if (ie_gerar_alta_fim_apac_w = 'S') 	then
		begin
		
		select	count(*)
		into STRICT	qt_apac_w
		from	sus_apac_unif a,
			atendimento_paciente b
		where	a.nr_atendimento	= b.nr_atendimento
		and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
		and 	coalesce(b.dt_cancelamento::text, '') = '';
			
		if (qt_apac_w > 0) then
			begin
			
			begin
			select	coalesce(max(a.nr_atendimento),0),
				max(b.dt_alta),
				max(b.cd_estabelecimento)
			into STRICT	nr_atend_ant_w,
				dt_alta_w,
				cd_estabelecimento_w
			from	sus_apac_unif a,
				atendimento_paciente b
			where	a.nr_atendimento 	= b.nr_atendimento
			and 	coalesce(b.dt_cancelamento::text, '') = ''
			and	b.cd_pessoa_fisica 	= cd_pessoa_fisica_w
			and	pkg_date_utils.start_of(a.dt_fim_validade,'MONTH', 0) <= pkg_date_utils.start_of(dt_referencia_p,'MONTH', 0);
			exception
			when others then
				nr_atend_ant_w := nr_atend_ant_w;
			end;
			
			end;
		end if;	
		
		end;
	end if;

	if (nr_atend_ant_w > 0) and (nr_atend_mes_w = 0) then

		select	coalesce(cd_motivo_alta_automatica,0)
		into STRICT	cd_motivo_alta_w
		from	hd_parametro
		where	cd_estabelecimento = cd_estabelecimento_w;

		if (coalesce(dt_alta_w::text, '') = '') and (cd_motivo_alta_w > 0 ) then
			ds_erro_w := gerar_estornar_alta(	nr_atend_ant_w, 'A', null, cd_motivo_alta_w, clock_timestamp(), nm_usuario_p, ds_erro_w, null, null, wheb_mensagem_pck.get_texto(309053, 'DT_REFERENCIA_P=' ||  to_char(dt_referencia_p))); --Gerado automaticamente no dia: #@DT_REFERENCIA_P#@
			if (ds_erro_w <> '') then
				ds_mensagem_w := wheb_mensagem_pck.get_texto(309055,	'NR_ATEND_ANT_W=' || nr_atend_ant_w || ';' ||
																		'DS_ERRO_W=' || ds_erro_w || ';' ||
																		'DS_UNIDADE_W=' || ds_unidade_w);
							/*
								Nao possivel gerar alta para o atendimento #@NR_ATEND_ANT_W#@
								Motivo #@DS_ERRO_W#@
								Unidade: #@DS_UNIDADE_W#@
								
							*/
			end if;

		end if;
		begin
			nr_atend_novo_w := duplicar_atendimento(nr_atend_ant_w, nm_usuario_p, nr_atend_novo_w);
			insert into hd_log_geracao_atend values (nextval('hd_log_geracao_atend_seq'),
							 clock_timestamp(),
							 nm_usuario_p,
							 clock_timestamp(),
							 nm_usuario_p,
							 nr_atend_ant_w,
							 nr_atend_novo_w,
							 cd_estab_unidade_w,
							dt_referencia_p);

			nr_atend_mes_w	:= nr_atend_novo_w;
			exception
			when unique_violation then
					ds_log_w_novo := substr('cd_pessoa_fisica_w: ' || cd_pessoa_fisica_w || ' SLQ Error_valid: ' || SQLERRM(SQLSTATE) ,1,2000);
					insert into log_atendimento(dt_atualizacao,nm_usuario,cd_log,ds_log,nr_atendimento)
					values (clock_timestamp(),NM_USUARIO_P,1836,ds_log_w_novo,nr_atend_novo_w);
		end;
		begin

		select 	count(*)
		into STRICT 	qt_existe_atend_auto_w
		from 	hd_regra_atual_atend_auto
		where	cd_estabelecimento = cd_estab_unidade_w;

		if (qt_existe_atend_auto_w > 0) then

			select 	max(nr_sequencia)
			into STRICT 	nr_seq_atual_atend_auto_w
			from 	hd_regra_atual_atend_auto
			where	cd_estabelecimento = cd_estab_unidade_w;

			select	max(ie_tipo_atendimento),
				max(cd_procedencia),
				max(ie_clinica),
				max(nr_seq_interno),
				max(nr_seq_queixa)
			into STRICT	ie_tipo_atendimento_w,
				cd_procedencia_w,
				ie_clinica_w,
				nr_seq_interno_w,
				nr_seq_queixa_w
			from	hd_regra_atual_atend_auto
			where	nr_sequencia = nr_seq_atual_atend_auto_w;

			update 	atendimento_paciente
			set	ie_tipo_atendimento = ie_tipo_atendimento_w,
				cd_procedencia 	= cd_procedencia_w,
				ie_clinica 	= ie_clinica_w,
				nr_seq_queixa   = nr_seq_queixa_w
			where 	nr_atendimento 	= nr_atend_novo_w;

			select	cd_unidade_basica,
				cd_unidade_compl,
				cd_setor_atendimento
			into STRICT	cd_unidade_basica_w,
				cd_unidade_compl_w,
				cd_setor_atendimento_w
			from	unidade_atendimento
			where 	nr_seq_interno = nr_seq_interno_w;

			select	max(nr_seq_interno)
			into STRICT 	nr_sequencia_ultimo_aten_w
			from	atend_paciente_unidade
			where	nr_atendimento = nr_atend_novo_w;

			if (nr_sequencia_ultimo_aten_w > 0) then
				begin
					update	atend_paciente_unidade
					set	cd_unidade_basica = cd_unidade_basica_w,
						cd_unidade_compl = cd_unidade_compl_w,
						cd_setor_atendimento = cd_setor_atendimento_w,
						dt_entrada_unidade 	= clock_timestamp(),
						dt_saida_unidade	= CASE WHEN dt_saida_unidade = NULL THEN null  ELSE clock_timestamp() END
					where	nr_seq_interno = nr_sequencia_ultimo_aten_w
					and	nr_atendimento = nr_atend_novo_w;
				exception
				when unique_violation then
					ds_log_w_novo := substr('cd_pessoa_fisica_w: ' || cd_pessoa_fisica_w || ' SLQ Error_valid: ' || SQLERRM(SQLSTATE) ,1,2000);
					insert into log_atendimento(dt_atualizacao,nm_usuario,cd_log,ds_log,nr_atendimento)
					values (clock_timestamp(),NM_USUARIO_P,1836,ds_log_w_novo,nr_atend_novo_w);
				end;
			end if;

		end if;

		exception
		when others then

			ds_erro_teste_w		:= substr(sqlerrm(SQLSTATE),1,255);

			select	max(nr_atendimento)
			into STRICT	nr_atendimento_ocup_setor_w
			from	atend_paciente_unidade
			where	cd_unidade_basica = cd_unidade_basica_w
			and	cd_unidade_compl = cd_unidade_compl_w
			and 	cd_setor_atendimento = cd_setor_atendimento_w;

		end;

		ds_titulo_w	:= wheb_mensagem_pck.get_texto(309061); -- Atendimento de Dialise gerado 
		ds_mensagem_w := ds_mensagem_w || wheb_mensagem_pck.get_texto(309065,	'NR_ATEND_NOVO_W=' || nr_atend_novo_w || ';' ||
																				'DS_UNIDADE_W=' || ds_unidade_w);
										/*
											Atendimento Gerado #@NR_ATEND_NOVO_W#@
											Unidade: #@DS_UNIDADE_W#@
											
										*/
	else

		if (nr_atend_ant_w = 0) then
			ds_titulo_w	:= wheb_mensagem_pck.get_texto(309062); -- Atendimento de Dialise nao gerado 
			ds_mensagem_w	:= wheb_mensagem_pck.get_texto(309079,	'DT_MES_ANT_W=' || to_char(dt_mes_ant_w,'dd/mm/yyyy') || ';' ||
																	'DS_UNIDADE_W=' || ds_unidade_w);
							/*
								Atendimento no mes #@DT_MES_ANT_W#@ nao encontrado.Unidade: #@DS_UNIDADE_W#@
								
							*/
		end if;

	end if;

	if (coalesce(nr_atend_mes_w,0) > 0) then
		begin
			select	cd_estabelecimento
			into STRICT	cd_estab_w
			from 	atendimento_paciente
			where	nr_atendimento = nr_atend_mes_w;

			update 	prescr_medica
			set 	nr_atendimento = nr_atend_mes_w,
			dt_prescricao  = clock_timestamp(),
			dt_liberacao   = CASE WHEN dt_liberacao = NULL THEN null  ELSE clock_timestamp() END
			where 	coalesce(nr_atendimento::text, '') = ''
			and	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	cd_estabelecimento = cd_estab_w
			and	pkg_date_utils.start_of(dt_prescricao,'MONTH', 0) = pkg_date_utils.start_of(dt_mes_ant_w,'MONTH', 0);
		exception
		when unique_violation then
			ds_log_w_novo := substr('cd_pessoa_fisica_w: ' || cd_pessoa_fisica_w || ' SLQ Error_valid: ' || SQLERRM(SQLSTATE) ,1,2000);
			insert into log_atendimento(dt_atualizacao,nm_usuario,cd_log,ds_log,nr_atendimento)
			values (clock_timestamp(),NM_USUARIO_P,1836,ds_log_w_novo,nr_atend_mes_w);
		end;

	end if;

	if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') and (coalesce(cd_perfil_atend_w,0) > 0) then

		insert into comunic_interna(
			dt_comunicado,
			ds_titulo,
			ds_comunicado,
			nm_usuario,
			dt_atualizacao,
			ie_geral,
			nm_usuario_destino,
			ds_perfil_adicional,
			nr_sequencia,
			ie_gerencial,
			dt_liberacao,
			cd_estab_destino
		) values (
			clock_timestamp(),
			ds_titulo_w ||cd_pessoa_fisica_w||' - '||nm_pessoa_fisica_w,
			ds_mensagem_w,
			nm_usuario_p,
			clock_timestamp(),
			'N',
			'',
			cd_perfil_atend_w ||', ',
			nextval('comunic_interna_seq'),
			'N',
			clock_timestamp(),
			cd_estabelecimento_w
		);

	end if;
	end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_gerar_atendimento_mensal ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
