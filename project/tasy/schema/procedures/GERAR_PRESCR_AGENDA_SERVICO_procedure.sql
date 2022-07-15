-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_agenda_servico (nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_agenda_w			timestamp;
cd_paciente_w			varchar(10);
cd_medico_solic_w		varchar(10);
cd_medico_w			varchar(10);
nr_atendimento_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_proc_interno_w		bigint;
nr_seq_exame_w			bigint;
ds_observacao_w			varchar(2000);/* Rafael em 29/02/2007 OS51268 alterado o tamanho do campo para 2000 */
cd_setor_atendimento_w		integer;
cd_prescritor_w			varchar(10);
ie_funcao_prescritor_w		varchar(3);
cd_estabelecimento_w		smallint;
dt_entrada_w			timestamp;
cd_medico_atend_w		varchar(10);
dt_prim_horario_w		timestamp;
dt_atualizacao_w		timestamp	:= clock_timestamp();
nr_prescricao_w			bigint;
nr_sequencia_w			bigint;
nr_seq_interno_w		bigint;
qt_setor_w			bigint	:= 0;
cd_material_exame_w		varchar(20);
cd_setor_coleta_w		integer;
cd_setor_entrega_w		integer;
qt_procedimento_w		integer;
qt_procedimento_adic_w		integer;
cd_setor_exclusivo_w		bigint;
ie_adep_w			varchar(3);
cd_setor_atend_agendamento_w	bigint;
dt_passagem_w			timestamp;

ie_obter_setor_agecons_w	varchar(1):=null;
cd_setor_agenda_w		integer:=null;
cd_pessoa_fisica_w		varchar(10);
ie_medico_w			varchar(1);
ie_liberar_w			varchar(10)	:= 'N';

ds_erro_w			varchar(4000);


ie_gerar_w			varchar(1);
qt_regra_geracao_w		bigint;
ie_setor_agenda_proc_w		varchar(1);
ie_gerar_passagem_w		varchar(1);
ie_unid_compl_agend_w		varchar(1);

ie_amostra_w			varchar(1);
nr_seq_forma_laudo_w		bigint;
nr_seq_unidade_basica_w		bigint;
qt_min_atraso_w		    	bigint;
ie_regra_setor_exame_w		varchar(1);
ds_hora_fixa_w			varchar(255);
qt_dia_entrega_w		numeric(20);
qt_min_entrega_w		bigint;
dt_resultado_w			timestamp;
ie_dia_semana_final_w 		bigint;
ie_data_resultado_w		varchar(255);
cd_setor_atend_w		varchar(255);
cd_setor_col_w			varchar(255);
cd_setor_entr_w			varchar(255):= null;
ie_emite_mapa_w			varchar(255);
ie_atualizar_recoleta_w 	varchar(255);
ie_urgencia_w			varchar(10);
ie_passagem_dt_agenda_w		varchar(1);
cd_material_exame_agend_w	varchar(20);
ie_Gerar_prescr_w		varchar(1);
ie_gerar_obs_prescr_w		varchar(1);
dt_entrega_w			timestamp;
ie_forma_data_w			varchar(10);
dt_alta_w			timestamp;
ie_forma_atual_dt_result_w	exame_lab_regra_setor.ie_atul_data_result%type;
qt_existe_setor_atend_w		bigint;

ie_setor_w			varchar(255);
nr_seq_proc_interno_uni_w	bigint;
ie_tipo_atendimento_w		smallint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
cd_setor_usuario_w		integer;
cd_setor_proced_w		integer;
ie_atualizar_setor_agenda_w	varchar(3);
ie_manter_medico_executor_w varchar(1);

ie_desconsidera_setor_exame	varchar(1);
ie_gerar_proc_adic_w	varchar(1);

ie_regra_passagem_setor_w 	varchar(3);
ie_tipo_passagem_w			regra_geracao_pass_prescr.ie_tipo_passagem%type;
ie_gerar_kit_proc_lib_w		varchar(1);

qt_pre_venda_w			bigint;

ds_material_especial_w  prescr_procedimento.ds_material_especial%type;
ie_medico_existente_w   varchar(1);

c01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	nr_seq_exame,
	qt_procedimento,
	cd_material_exame,
	ds_material_especial
from	agenda_consulta_proc
where	nr_seq_agenda		= nr_seq_agenda_p
and	ie_executar_proc	= 'S'
and coalesce(ie_dependente, 'N') = 'N';

C02 CURSOR FOR
	SELECT	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	nr_seq_exame,
	qt_procedimento,
	cd_material_exame
	from	agenda_consulta_proc
	where	nr_seq_agenda		= nr_seq_agenda_p
	and	ie_executar_proc	= 'S'
	and	ie_gerar_w		= 'N'
	and coalesce(ie_dependente, 'N') = 'N';

C03 CURSOR FOR
	SELECT	cd_setor_atendimento
	from	procedimento_setor_atend
	where	cd_procedimento			= cd_procedimento_w
	and	ie_origem_proced		= ie_origem_proced_w
	and	cd_estabelecimento		= cd_estabelecimento_w
	order	by ie_prioridade desc;


BEGIN

select	max(b.nr_atendimento),
	max(nr_seq_proc_interno)
into STRICT	nr_atendimento_w,
	nr_seq_proc_interno_uni_w
from	agenda a,
	agenda_consulta b
where	a.cd_agenda = b.cd_agenda
and	b.nr_sequencia = nr_seq_agenda_p;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

	select	max(a.cd_estabelecimento),
		max(ie_tipo_atendimento)
	into STRICT	cd_estabelecimento_w,
		ie_tipo_atendimento_w
	from	atendimento_paciente a
	where	a.nr_atendimento = nr_atendimento_w;

	select	coalesce(max(cd_convenio),0),
		coalesce(max(cd_categoria),0)
	into STRICT	cd_convenio_w,
		cd_categoria_w
	from 	atend_categoria_convenio
	WHERE	nr_atendimento = nr_atendimento_w;
else
	cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
end if;

select	obter_setor_usuario(nm_usuario_p)
into STRICT	cd_setor_usuario_w
;

ie_Gerar_prescr_w := Obter_param_usuario(866, 206, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_Gerar_prescr_w);
ie_gerar_obs_prescr_w := Obter_param_usuario(866, 259, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_obs_prescr_w);

ie_manter_medico_executor_w := Obter_param_usuario(866, 284, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_manter_medico_executor_w);


ie_forma_data_w := Obter_param_usuario(916, 45, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_forma_data_w);
ie_setor_w := Obter_param_usuario(916, 47, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_setor_w);
ie_gerar_proc_adic_w := Obter_Param_Usuario(916, 301, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_proc_adic_w);
ie_atualizar_setor_agenda_w := obter_param_usuario(916, 452, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualizar_setor_agenda_w);

IF (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and
	((obter_se_gerar_prescr_agenda(5, obter_codigo_agenda(nr_seq_agenda_p), nr_seq_agenda_p) = 'S') or (ie_Gerar_prescr_w	= 'S')) then
	/* obter dados da agenda */


	/* abreiter atender param 452 EUP -> OS188286*/

	select 	coalesce(max(obter_valor_param_usuario(916, 452, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)), 'N')
	into STRICT	ie_obter_setor_agecons_w
	;

	ie_liberar_w := Obter_param_usuario(916, 519, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_liberar_w);
	ie_adep_w := Obter_param_usuario(924, 246, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_adep_w);

	ie_regra_setor_exame_w := Obter_param_usuario(916, 770, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_regra_setor_exame_w);
	ie_passagem_dt_agenda_w := Obter_param_usuario(916, 879, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_passagem_dt_agenda_w);

	ie_desconsidera_setor_exame := Obter_param_usuario(916, 1147, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_desconsidera_setor_exame);

	select	max(cd_pessoa_Fisica)
	into STRICT	cd_pessoa_fisica_w
	from	usuario
	where	nm_usuario = nm_usuario_p;

	/*obter se e medico*/

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_medico_w
	from	medico
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and	ie_situacao	= 'A';


	/* abreiter atender param 452 EUP -> OS188286 */

	if (ie_obter_setor_agecons_w = 'S') then
		select 	max(coalesce(a.cd_setor_agenda,a.cd_setor_exclusivo))
		into STRICT	cd_setor_agenda_w
		from	agenda a,
			agenda_consulta b
		where	a.cd_agenda 	= b.cd_agenda
		and	b.nr_sequencia 	= nr_seq_agenda_p;
	end if;

	select	max(b.dt_agenda),
		max(b.cd_pessoa_fisica),
		max(b.cd_medico_solic),
		max(b.cd_medico),
		max(b.nr_atendimento),
		max(b.cd_procedimento),
		max(b.ie_origem_proced),
		max(b.nr_seq_proc_interno),
		max(b.ds_observacao),
		max(b.nr_seq_exame),
		max(b.cd_setor_coleta),
		max(b.cd_setor_entrega),
		max(qt_procedimento),
		max(b.nr_seq_unidade),
		max(b.cd_setor_atendimento),
		max(b.cd_material_exame)
	into STRICT	dt_agenda_w,
		cd_paciente_w,
		cd_medico_solic_w,
		cd_medico_w,
		nr_atendimento_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_proc_interno_w,
		ds_observacao_w,
		nr_seq_exame_w,
		cd_setor_coleta_w,
		cd_setor_entrega_w,
		qt_procedimento_w,
		nr_seq_unidade_basica_w,
		cd_setor_atend_agendamento_w,
		cd_material_exame_agend_w
	from	agenda a,
		agenda_consulta b
	where	a.cd_agenda = b.cd_agenda
	and	b.nr_sequencia = nr_seq_agenda_p;

	select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT   ie_medico_existente_w
	from medico
	where cd_pessoa_fisica = cd_medico_w;

	select	count(*)
	into STRICT	qt_regra_geracao_w
	from	agenda_regra_proc_prescr;

	if (qt_regra_geracao_w > 0) then

		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ie_gerar_w
		from	agenda_regra_proc_prescr
		where	((cd_procedimento = cd_procedimento_w) or (coalesce(cd_procedimento::text, '') = ''))
		and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = '')))
		and	((nr_seq_proc_interno = nr_seq_proc_interno_w) or (coalesce(nr_seq_proc_interno::text, '') = ''));

		if (ie_gerar_w = 'N') then

			open C02;
			loop
			fetch C02 into
				cd_procedimento_w,
				ie_origem_proced_w,
				nr_seq_proc_interno_w,
				nr_seq_exame_w,
				qt_procedimento_adic_w,
				cd_material_exame_agend_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
				into STRICT	ie_gerar_w
				from	agenda_regra_proc_prescr
				where	((cd_procedimento = cd_procedimento_w) or (coalesce(cd_procedimento::text, '') = ''))
				and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = '')))
				and	((nr_seq_proc_interno = nr_seq_proc_interno_w) or (coalesce(nr_seq_proc_interno::text, '') = ''));

				end;
			end loop;
			close C02;
		end if;

	else
		ie_gerar_w	:= 'S';
	end if;

	/* obter dados do usuario*/

	select	max(a.cd_setor_atendimento),
		max(a.cd_pessoa_fisica),
		max(a.ie_tipo_evolucao)
	into STRICT	cd_setor_atendimento_w,
		cd_prescritor_w,
		ie_funcao_prescritor_w
	from	usuario a
	where	a.nm_usuario = nm_usuario_p;

	ie_setor_agenda_proc_w := Obter_param_usuario(916, 680, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_setor_agenda_proc_w);

	if (ie_setor_agenda_proc_w = 'S') then
		select 	max(a.cd_setor_agenda)
		into STRICT	cd_setor_atendimento_w
		from	agenda a,
			agenda_consulta b
		where	a.cd_agenda 	= b.cd_agenda
		and	b.nr_sequencia 	= nr_seq_agenda_p;
	end if;

	if (ie_adep_w = 'DS') then
		select	coalesce(max(ie_adep),'S')
		into STRICT	ie_adep_w
		from	setor_atendimento
		where	cd_setor_atendimento = coalesce(cd_setor_agenda_w,cd_setor_atendimento_w);
	elsif (ie_adep_w = 'NV') then
		ie_adep_w := 'N';
	elsif (ie_adep_w = 'PV') then
		ie_adep_w := 'S';
	elsif (ie_adep_w =  'PNV') then
		ie_adep_w := 'N';
	else
		ie_adep_w := 'S';
	end if;

	/* obter dados do atendimento */

	select	max(a.cd_estabelecimento),
		max(a.dt_entrada),
		max(a.cd_medico_resp),
		max(a.dt_alta)
	into STRICT	cd_estabelecimento_w,
		dt_entrada_w,
		cd_medico_atend_w,
		dt_alta_w
	from	atendimento_paciente a
	where	a.nr_atendimento = nr_atendimento_w;

	if (ie_forma_data_w = 'E') then
		dt_entrega_w	:= dt_entrada_w;
	elsif (ie_forma_data_w = 'AE') and (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then
		dt_entrega_w	:= dt_entrada_w;
	else
		dt_entrega_w	:= dt_atualizacao_w;
	end if;
	/* obter dados da prescricao */

	select	coalesce(obter_prim_horario_setor(cd_Setor_atendimento_w), to_date((to_char(clock_timestamp(),'dd/mm/yyyy hh24')||':00:00'),'dd/mm/yyyy hh24:mi:ss') +1/24)
	into STRICT	dt_prim_horario_w
	;

	begin
		select	'N'
		into STRICT	ie_gerar_w
		from	prescr_medica a,
			prescr_procedimento b
		where 	a.nr_seq_agecons = nr_seq_agenda_p
		and	a.nr_prescricao = b.nr_prescricao
		and	b.cd_procedimento = cd_procedimento_w
		and	b.ie_origem_proced = ie_origem_proced_w  LIMIT 1;
	exception
	when others then
		ie_gerar_w := 'S';
	end;

	if (ie_gerar_w = 'S') then

		/* gerar sequencia */

		select	nextval('prescr_medica_seq')
		into STRICT	nr_prescricao_w
		;

		/* validar data da prescricaoo (primeira prescricao) */

		IF (dt_agenda_w < dt_entrada_w) then
			dt_agenda_w	:= dt_entrada_w + 1/1440;
		END IF;

		if (dt_entrega_w < dt_agenda_w) then
			dt_entrega_w := dt_agenda_w;
		end if;

		select	max(vl_default)
		into STRICT	nr_seq_forma_laudo_w
		from	tabela_atrib_regra
		where	nm_tabela					= 'PRESCR_MEDICA'
		and	nm_atributo					= 'NR_SEQ_FORMA_LAUDO'
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w)    = cd_estabelecimento_w
		and	coalesce(cd_perfil, obter_perfil_ativo)		= obter_perfil_ativo
		and	coalesce(nm_usuario_param, nm_usuario_p) 		= nm_usuario_p;

		/* inserir registro na tabela */

		insert into prescr_medica(
						nr_prescricao,
						cd_pessoa_fisica,
						nr_atendimento,
						cd_medico,
						dt_prescricao,
						dt_atualizacao,
						nm_usuario,
						nr_horas_validade,
						dt_primeiro_horario,
						cd_setor_atendimento,
						ie_recem_nato,
						ie_origem_inf,
						cd_setor_entrega,
						nm_usuario_original,
						cd_estabelecimento,
						cd_prescritor,
						ie_emergencia,
						ie_funcao_prescritor,
						nr_seq_agecons,
						ie_adep,
						nr_seq_forma_laudo,
						ds_observacao,
						dt_entrega
						)
					values (
						nr_prescricao_w,
						cd_paciente_w,
						nr_atendimento_w,
						coalesce(cd_medico_solic_w,cd_medico_atend_w),
						dt_agenda_w,
						dt_atualizacao_w,
						nm_usuario_p,
						24,
						dt_prim_horario_w,
						coalesce(cd_setor_agenda_w,cd_setor_atendimento_w),
						'N',
						'1',
						coalesce(cd_setor_agenda_w,cd_setor_atendimento_w),
						nm_usuario_p,
						cd_estabelecimento_w,
						cd_prescritor_w,
						'N',
						ie_funcao_prescritor_w,
						nr_seq_agenda_p,
						ie_adep_w,
						CASE WHEN coalesce(nr_seq_forma_laudo_w::text, '') = '' THEN null  ELSE nr_seq_forma_laudo_w END ,
						CASE WHEN ie_gerar_obs_prescr_w='S' THEN  ds_observacao_w  ELSE '' END ,
						dt_entrega_w);

		/* validar registros inseridos */

		COMMIT;

		/* obter dados do procedimento (se necessario) */

		IF (coalesce(cd_procedimento_w::text, '') = '') and (coalesce(ie_origem_proced_w::text, '') = '') then
			SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, nr_prescricao_w, nr_atendimento_w, 0, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
		END IF;

    SELECT MAX(VL_DEFAULT)INTO IE_AMOSTRA_W
      FROM TABELA_ATRIB_REGRA
     WHERE NM_TABELA = 'PRESCR_PROCEDIMENTO'
       AND NM_ATRIBUTO = 'IE_AMOSTRA'
       AND coalesce(CD_ESTABELECIMENTO, CD_ESTABELECIMENTO_W) = CD_ESTABELECIMENTO_W
       AND coalesce(CD_PERFIL, OBTER_PERFIL_ATIVO) = OBTER_PERFIL_ATIVO
       AND coalesce(NM_USUARIO_PARAM, NM_USUARIO_P) = NM_USUARIO_P;

		IF (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
			/* gerar sequencia */

			select	coalesce(max(a.nr_sequencia),0) + 1
			into STRICT	nr_sequencia_w
			from	prescr_procedimento a
			where	a.nr_prescricao = nr_prescricao_w;
			if (cd_material_exame_agend_w IS NOT NULL AND cd_material_exame_agend_w::text <> '') then
				cd_material_exame_w := cd_material_exame_agend_w;
			elsif (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
				select coalesce(max(cd_material_exame),'')
				into STRICT	cd_material_exame_w
				from (	SELECT b.cd_material_exame
						from	material_exame_lab b,
								exame_lab_material a
						where a.nr_seq_material	= b.nr_sequencia
						and a.nr_seq_exame		= nr_seq_exame_w
						and a.ie_situacao		= 'A'
						and  lab_obter_se_mat_lib_conv(a.nr_seq_exame,b.nr_sequencia,cd_estabelecimento_w) = 'S'
						order by a.ie_prioridade) alias4 LIMIT 1;
			END IF;

			/* gerar sequencia */

			select	nextval('prescr_procedimento_seq')
			into STRICT	nr_seq_interno_w
			;

			select	max(cd_setor_exclusivo)
			into STRICT	cd_setor_exclusivo_w
			from	procedimento
			where	cd_procedimento		= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w;

			dt_resultado_w := null;
			if (coalesce(ie_regra_setor_exame_w,'N') = 'S') and (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

				select	coalesce(max(OBTER_SE_PROC_URGENTE(cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, null, nr_seq_exame_w, 1)), 'N')
				into STRICT	ie_urgencia_w
				;

				SELECT * FROM obter_setor_exame_lab(	nr_prescricao_w, nr_seq_exame_w, cd_setor_exclusivo_w, cd_material_exame_w, null, 'S', cd_setor_atend_w, cd_setor_col_w, cd_setor_entr_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_urgencia_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w) INTO STRICT cd_setor_atend_w, cd_setor_col_w, cd_setor_entr_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w;

					if (ie_desconsidera_setor_exame = 'S' ) then

						cd_setor_atend_w := cd_setor_atendimento_w;

					else

						cd_setor_atend_w	:= gerar_setor_exame_lab(cd_setor_atend_w);
						cd_setor_atend_w := coalesce(somente_numero(cd_setor_atend_w),0);
						if (cd_setor_atend_w = 0) then
							cd_setor_atend_w := null;
						end if;
					end if;

					if (cd_setor_atend_w IS NOT NULL AND cd_setor_atend_w::text <> '') and (cd_setor_atend_w > 0) then

						select	count(*)
						into STRICT	qt_existe_setor_atend_w
						from	setor_atendimento
						where	cd_setor_atendimento = cd_setor_atend_w;

						if (qt_existe_setor_atend_w = 0) then
							cd_setor_atend_w	:= cd_setor_atendimento_w;
						end if;

					else
						--Validar param [47] da EUP
						if (ie_setor_w = 'Usuario') then
							cd_setor_atend_w	:= coalesce(cd_setor_usuario_w,cd_setor_atend_w);

						elsif (ie_setor_w = 'Paciente') then
							select coalesce(max(cd_setor_atendimento),coalesce(cd_setor_usuario_w,cd_setor_atend_w))
							into STRICT cd_setor_atend_w
							from atend_paciente_unidade
							where nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_w, 'A');

						elsif (ie_setor_w = 'Procedimento') then
							begin
							open	c03;
							loop
							fetch	c03 into cd_setor_proced_w;
							EXIT WHEN NOT FOUND; /* apply on c03 */
								begin
								cd_setor_atend_w	:= cd_setor_proced_w;
								end;
							end loop;
							close c03;
							if (cd_setor_atend_w = 0) then
								cd_setor_atend_w	:= coalesce(cd_setor_usuario_w,cd_setor_atend_w);
							end if;
							end;

						elsif (ie_setor_w = 'Proc Interno') then
							begin
							select	coalesce(max(Obter_Setor_exec_proc_interno(nr_seq_proc_interno_uni_w,null,ie_tipo_atendimento_w,cd_convenio_w,cd_categoria_w)),cd_setor_atend_w)
							into STRICT	cd_setor_atend_w
							;
							end;
						end if;

						if (ie_atualizar_setor_agenda_w = 'S') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')then
							select 	coalesce(max(obter_dados_agendamento(nr_seq_agenda_p,'CSA')),0)
							into STRICT	cd_setor_entrega_w
							;
						end if;

					end if;



				if	((ie_data_resultado_w = 'P') or (ie_data_resultado_w = 'N')) then
					if (ds_hora_fixa_w IS NOT NULL AND ds_hora_fixa_w::text <> '') then
						select	(trunc(coalesce(dt_entrada_unidade,dt_prescricao)) + (ds_hora_fixa_w/24)) + coalesce(qt_dia_entrega_w,0) + (CASE WHEN coalesce(qt_min_entrega_w,0)=0 THEN 0  ELSE qt_min_entrega_w/1440 END )
						into STRICT	dt_resultado_w
						from    prescr_medica
						where nr_prescricao = nr_prescricao_w;

					else
						select	coalesce(dt_entrada_unidade,dt_prescricao) + coalesce(qt_dia_entrega_w,0)  + (CASE WHEN coalesce(qt_min_entrega_w,0)=0 THEN 0  ELSE qt_min_entrega_w/1440 END )
						into STRICT	dt_resultado_w
						from	prescr_medica
						where nr_prescricao = nr_prescricao_w;

					end if;
				end if;
			elsif (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
				select	Obter_Setor_exec_lab(nr_seq_exame_w, null, cd_estabelecimento_w)
				into STRICT	cd_setor_exclusivo_w
				;
			elsif (coalesce(nr_seq_exame_w::text, '') = '') and (ie_setor_agenda_proc_w = 'R')  then
				--Validar param [47] da EUP
				if (ie_setor_w = 'Usuario') then
					cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_w,cd_setor_atendimento_w);

				elsif (ie_setor_w = 'Paciente') then
					select coalesce(max(cd_setor_atendimento),coalesce(cd_setor_usuario_w,cd_setor_atendimento_w))
					into STRICT cd_setor_atendimento_w
					from atend_paciente_unidade
					where nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_w, 'A');

				elsif (ie_setor_w = 'Procedimento') then
					begin
					open	c03;
					loop
					fetch	c03 into cd_setor_proced_w;
					EXIT WHEN NOT FOUND; /* apply on c03 */
						begin
						cd_setor_atendimento_w	:= cd_setor_proced_w;
						end;
					end loop;
					close c03;
					if (cd_setor_atendimento_w = 0) then
						cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_w,cd_setor_atendimento_w);
					end if;
					end;

				elsif (ie_setor_w = 'Proc Interno') then
					begin
					select	coalesce(max(Obter_Setor_exec_proc_interno(nr_seq_proc_interno_uni_w,null,ie_tipo_atendimento_w,cd_convenio_w,cd_categoria_w)),cd_setor_atendimento_w)
					into STRICT	cd_setor_atendimento_w
					;
					end;
				end if;

				if (ie_atualizar_setor_agenda_w = 'S') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')then
					select 	coalesce(max(obter_dados_agendamento(nr_seq_agenda_p,'CSA')),0)
					into STRICT	cd_setor_entrega_w
					;
				end if;
			end if;


			/* inserir registro na tabela */

			insert into prescr_procedimento(
								nr_prescricao,
								nr_sequencia,
								cd_procedimento,
								qt_procedimento,
								dt_atualizacao,
								nm_usuario,
								ds_horarios,
								cd_motivo_baixa,
								ie_origem_proced,
								cd_intervalo,
								ie_urgencia,
								cd_setor_atendimento,
								dt_prev_execucao,
								ie_suspenso,
								ie_amostra,
								ie_origem_inf,
								ie_executar_leito,
								nr_agrupamento,
								ie_se_necessario,
								ie_acm,
								nr_ocorrencia,
								ie_status_execucao,
								nr_seq_interno,
								ie_avisar_result,
								nr_seq_proc_interno,
								ds_observacao,
								cd_medico_exec,
								nr_Seq_exame,
								cd_material_exame,
								cd_setor_coleta,
								cd_setor_entrega,
								dt_resultado
								)
							values (
								nr_prescricao_w,
								nr_sequencia_w,
								cd_procedimento_w,
								coalesce(qt_procedimento_w,1),
								dt_atualizacao_w,
								nm_usuario_p,
								null,
								0,
								ie_origem_proced_w,
								null,
								coalesce(ie_urgencia_w,'N'),
								CASE WHEN coalesce(ie_regra_setor_exame_w,'N')='S' THEN  cd_setor_atend_w  ELSE coalesce(cd_setor_exclusivo_w,cd_setor_atendimento_w) END ,
								dt_agenda_w,
								'N',
								CASE WHEN coalesce(ie_amostra_w::text, '') = '' THEN 'N'  ELSE ie_amostra_w END ,
								'P',
								'N',
								1,
								'N',
								'N',
								1,
								'10',
								nr_seq_interno_w,
								'N',
								nr_seq_proc_interno_w,
								CASE WHEN ie_gerar_obs_prescr_w='N' THEN  ds_observacao_w  ELSE '' END ,
								coalesce(CASE WHEN ie_medico_existente_w='S' THEN  cd_medico_w  ELSE null END , CASE WHEN ie_manter_medico_executor_w='N' THEN cd_medico_atend_w  ELSE null END ),
								nr_seq_exame_w,
								coalesce(cd_material_exame_agend_w,cd_material_exame_w),
								cd_setor_coleta_w,
								cd_setor_entrega_w,
								dt_resultado_w
								);
			if (ie_gerar_proc_adic_w = 'S') then
				CALL Gerar_Prescr_Proc_Assoc(Nr_prescricao_w, nr_sequencia_w, nm_usuario_p);
			end if;

			CALL Gerar_med_mat_assoc(nr_prescricao_w, nr_sequencia_w);

		END IF;
		OPEN c01;
		LOOP
		FETCH c01 into	cd_procedimento_w,
				ie_origem_proced_w,
				nr_seq_proc_interno_w,
				nr_seq_exame_w,
				qt_procedimento_adic_w,
				cd_material_exame_agend_w,
				ds_material_especial_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
				BEGIN
				/* obter dados do procedimento (se necessario) */

				IF (coalesce(cd_procedimento_w::text, '') = '') and (coalesce(ie_origem_proced_w::text, '') = '') then
					SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, nr_prescricao_w, nr_atendimento_w, 0, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
				END IF;

				/* gerar sequencia */

				select	coalesce(max(a.nr_sequencia),0) + 1
				into STRICT	nr_sequencia_w
				from	prescr_procedimento a
				where	a.nr_prescricao = nr_prescricao_w;

				/* gerar sequencia */

				select	nextval('prescr_procedimento_seq')
				into STRICT	nr_seq_interno_w
				;


				select	max(cd_setor_exclusivo)
				into STRICT	cd_setor_exclusivo_w
				from	procedimento
				where	cd_procedimento		= cd_procedimento_w
				and	ie_origem_proced	= ie_origem_proced_w;

				select	count(*)
				into STRICT	qt_regra_geracao_w
				from	agenda_regra_proc_prescr;

				if (qt_regra_geracao_w > 0) then
					select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
					into STRICT	ie_gerar_w
					from	agenda_regra_proc_prescr
					where	((cd_procedimento = cd_procedimento_w) or (coalesce(cd_procedimento::text, '') = ''))
					and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = '')))
					and	((nr_seq_proc_interno = nr_seq_proc_interno_w) or (coalesce(nr_seq_proc_interno::text, '') = ''));
				else
					ie_gerar_w	:= 'S';
				end if;

				dt_resultado_w := null;
				if (coalesce(ie_regra_setor_exame_w,'N') = 'S') and (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then


					if (cd_material_exame_agend_w IS NOT NULL AND cd_material_exame_agend_w::text <> '') then
						cd_material_exame_w := cd_material_exame_agend_w;
					else
						select coalesce(max(cd_material_exame),'')
						into STRICT	cd_material_exame_w
						from (	SELECT b.cd_material_exame
							from	material_exame_lab b,
								exame_lab_material a
							where a.nr_seq_material	= b.nr_sequencia
							and a.nr_seq_exame		= nr_seq_exame_w
							and  lab_obter_se_mat_lib_conv(a.nr_seq_exame,b.nr_sequencia,cd_estabelecimento_w) = 'S'
							and a.ie_situacao		= 'A'
							order by a.ie_prioridade) alias3 LIMIT 1;
					end if;

					select	coalesce(max(OBTER_SE_PROC_URGENTE(cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, null, nr_seq_exame_w,1)), 'N')
					into STRICT	ie_urgencia_w
					;

					SELECT * FROM obter_setor_exame_lab(nr_prescricao_w, nr_seq_exame_w, cd_setor_exclusivo_w, cd_material_exame_w, null, 'S', cd_setor_atend_w, cd_setor_col_w, cd_setor_entr_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_urgencia_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w) INTO STRICT cd_setor_atend_w, cd_setor_col_w, cd_setor_entr_w, qt_dia_entrega_w, ie_emite_mapa_w, ds_hora_fixa_w, ie_data_resultado_w, qt_min_entrega_w, ie_atualizar_recoleta_w, ie_dia_semana_final_w, ie_forma_atual_dt_result_w, qt_min_atraso_w;


					if (ie_desconsidera_setor_exame = 'S' ) then

						cd_setor_atend_w := cd_setor_atendimento_w;

					else

						cd_setor_atend_w	:= gerar_setor_exame_lab(cd_setor_atend_w);
						cd_setor_atend_w := coalesce(somente_numero(cd_setor_atend_w),0);
						if (cd_setor_atend_w = 0) then
							cd_setor_atend_w := null;
						end if;

					end if;

					if (cd_setor_atend_w IS NOT NULL AND cd_setor_atend_w::text <> '') and (cd_setor_atend_w > 0) then

						select	count(*)
						into STRICT	qt_existe_setor_atend_w
						from	setor_atendimento
						where	cd_setor_atendimento = cd_setor_atend_w;

						if (qt_existe_setor_atend_w = 0) then
							cd_setor_atend_w	:= cd_setor_atendimento_w;
						end if;

					else
						--Validar param [47] da EUP
						if (ie_setor_w = 'Usuario') then
							cd_setor_atend_w	:= coalesce(cd_setor_usuario_w,cd_setor_atend_w);

						elsif (ie_setor_w = 'Paciente') then
							select coalesce(max(cd_setor_atendimento),coalesce(cd_setor_usuario_w,cd_setor_atend_w))
							into STRICT cd_setor_atend_w
							from atend_paciente_unidade
							where nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_w, 'A');

						elsif (ie_setor_w = 'Procedimento') then
							begin
							open	c03;
							loop
							fetch	c03 into cd_setor_proced_w;
							EXIT WHEN NOT FOUND; /* apply on c03 */
								begin
								cd_setor_atend_w	:= cd_setor_proced_w;
								end;
							end loop;
							close c03;
							if (cd_setor_atend_w = 0) then
								cd_setor_atend_w	:= coalesce(cd_setor_usuario_w,cd_setor_atend_w);
							end if;
							end;

						elsif (ie_setor_w = 'Proc Interno') then
							begin

							select	coalesce(max(Obter_Setor_exec_proc_interno(coalesce(nr_seq_proc_interno_uni_w, nr_seq_proc_interno_w),null,ie_tipo_atendimento_w,cd_convenio_w,cd_categoria_w)),cd_setor_atend_w)
							into STRICT	cd_setor_atend_w
							;
							end;

						end if;

						if (ie_atualizar_setor_agenda_w = 'S') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')then
							select 	coalesce(max(obter_dados_agendamento(nr_seq_agenda_p,'CSA')),0)
							into STRICT	cd_setor_entrega_w
							;
						end if;

					end if;

					if ((nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') and (coalesce(cd_setor_exclusivo_w::text, '') = '')) then
						select	Obter_Setor_exec_lab(nr_seq_exame_w, null, cd_estabelecimento_w)
						into STRICT	cd_setor_exclusivo_w
						;
					end if;

					if	((ie_data_resultado_w = 'P') or (ie_data_resultado_w = 'N')) then
						if (ds_hora_fixa_w IS NOT NULL AND ds_hora_fixa_w::text <> '') then
							select	(trunc(coalesce(dt_entrada_unidade,dt_prescricao)) + (ds_hora_fixa_w/24)) + coalesce(qt_dia_entrega_w,0) + (CASE WHEN coalesce(qt_min_entrega_w,0)=0 THEN 0  ELSE qt_min_entrega_w/1440 END )
							into STRICT	dt_resultado_w
							from    prescr_medica
							where nr_prescricao = nr_prescricao_w;
						else
							select	coalesce(dt_entrada_unidade,dt_prescricao) + coalesce(qt_dia_entrega_w,0)  + (CASE WHEN coalesce(qt_min_entrega_w,0)=0 THEN 0  ELSE qt_min_entrega_w/1440 END )
							into STRICT	dt_resultado_w
							from	prescr_medica
							where nr_prescricao = nr_prescricao_w;

						end if;
					end if;

				elsif (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
					select	Obter_Setor_exec_lab(nr_seq_exame_w, null, cd_estabelecimento_w)
					into STRICT	cd_setor_exclusivo_w
					;
				elsif (coalesce(nr_seq_exame_w::text, '') = '') and (ie_setor_agenda_proc_w = 'R') then
					--Validar param [47] da EUP
					if (ie_setor_w = 'Usuario') then
						cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_w,cd_setor_atendimento_w);

					elsif (ie_setor_w = 'Paciente') then
						select coalesce(max(cd_setor_atendimento),coalesce(cd_setor_usuario_w,cd_setor_atendimento_w))
						into STRICT cd_setor_atendimento_w
						from atend_paciente_unidade
						where nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_w, 'A');

					elsif (ie_setor_w = 'Procedimento') then
						begin
						open	c03;
						loop
						fetch	c03 into cd_setor_proced_w;
						EXIT WHEN NOT FOUND; /* apply on c03 */
							begin
							cd_setor_atendimento_w	:= cd_setor_proced_w;
							end;
						end loop;
						close c03;
						if (cd_setor_atendimento_w = 0) then
							cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_w,cd_setor_atendimento_w);
						end if;
						end;

					elsif (ie_setor_w = 'Proc Interno') then
						begin
						select	coalesce(max(Obter_Setor_exec_proc_interno(nr_seq_proc_interno_uni_w,null,ie_tipo_atendimento_w,cd_convenio_w,cd_categoria_w)),cd_setor_atendimento_w)
						into STRICT	cd_setor_atendimento_w
						;
						end;
					end if;

					if (ie_atualizar_setor_agenda_w = 'S') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')then
						select 	coalesce(max(obter_dados_agendamento(nr_seq_agenda_p,'CSA')),0)
						into STRICT	cd_setor_entrega_w
						;
					end if;
				end if;


				if (ie_gerar_w = 'S') then
					/* inserir registro na tabela */

					insert into prescr_procedimento(
										nr_prescricao,
										nr_sequencia,
										cd_procedimento,
										qt_procedimento,
										dt_atualizacao,
										nm_usuario,
										ds_horarios,
										cd_motivo_baixa,
										ie_origem_proced,
										cd_intervalo,
										ie_urgencia,
										cd_setor_atendimento,
										dt_prev_execucao,
										ie_suspenso,
										ie_amostra,
										ie_origem_inf,
										ie_executar_leito,
										nr_agrupamento,
										ie_se_necessario,
										ie_acm,
										nr_ocorrencia,
										ie_status_execucao,
										nr_seq_interno,
										ie_avisar_result,
										nr_seq_proc_interno,
										nr_seq_exame,
										ds_observacao,
										cd_medico_exec,
										cd_setor_coleta,
										cd_setor_entrega,
										dt_resultado,
										cd_material_exame,
										ds_material_especial
										)
									values (
										nr_prescricao_w,
										nr_sequencia_w,
										cd_procedimento_w,
										coalesce(qt_procedimento_adic_w,1),
										dt_atualizacao_w,
										nm_usuario_p,
										null,
										0,
										ie_origem_proced_w,
										null,
										coalesce(ie_urgencia_w,'N'),
										coalesce(cd_setor_exclusivo_w,CASE WHEN coalesce(ie_regra_setor_exame_w,'N')='S' THEN  cd_setor_atend_w  ELSE cd_setor_atendimento_w END ),
										dt_agenda_w,
										'N',
										CASE WHEN coalesce(ie_amostra_w::text, '') = '' THEN 'N'  ELSE ie_amostra_w END ,
										'P',
										'N',
										1,
										'N',
										'N',
										1,
										'10',
										nr_seq_interno_w,
										'N',
										nr_seq_proc_interno_w,
										nr_seq_exame_w,
										CASE WHEN ie_gerar_obs_prescr_w='N' THEN  ds_observacao_w  ELSE '' END ,
										coalesce(CASE WHEN ie_medico_existente_w='S' THEN  cd_medico_w  ELSE null END , CASE WHEN ie_manter_medico_executor_w='N' THEN cd_medico_atend_w  ELSE null END ),
										cd_setor_coleta_w,
										cd_setor_entrega_w,
										dt_resultado_w,
										coalesce(cd_material_exame_agend_w,cd_material_exame_w),
										ds_material_especial_w
										);
					if (ie_gerar_proc_adic_w = 'S') then
						CALL Gerar_Prescr_Proc_Assoc(Nr_prescricao_w, nr_sequencia_w, nm_usuario_p);
					end if;

					CALL Gerar_med_mat_assoc(nr_prescricao_w, nr_sequencia_w);
				end if;
				END;
		END LOOP;
		CLOSE c01;

		select	count(*)
		into STRICT	qt_pre_venda_w
		from	pre_venda_item
		where	nr_atendimento = nr_atendimento_w
		and 	coalesce(nr_prescricao::text, '') = '';

		if (qt_pre_venda_w > 0) then
			CALL gerar_prescr_proc_pre_venda(nr_prescricao_w, nm_usuario_p);
		end if;

		/* validar registros inseridos */

		COMMIT;

		ie_gerar_passagem_w := Obter_param_usuario(916, 685, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_passagem_w);
		ie_unid_compl_agend_w := Obter_param_usuario(916, 754, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_unid_compl_agend_w); /* tbyegmann OS 329660 em 13/06/2011 - buscar o parametro da EUP e
															verificar se vai gerar a unidade complementar do setor de acordo com o agendamento na Agenda de servicos*/
		ie_regra_passagem_setor_w := Obter_param_usuario(916, 1175, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_regra_passagem_setor_w);

		if (ie_gerar_passagem_w = 'S') then
			/*tvvieira - Na EUP era gerada a passagem antes dos eventos de post da tabela no delphi - OS 291469*/

			select	coalesce(count(*),0)
			into STRICT	qt_setor_w
			from	atend_paciente_unidade
			where	nr_atendimento = nr_atendimento_w;

			if ( coalesce(nr_atendimento_w, 0) <> 0) then

				if (coalesce(ie_regra_setor_exame_w,'N') = 'S') then
					cd_setor_agenda_w	:= cd_setor_atend_w;
				end if;

				IF (coalesce(qt_setor_w,0) = 0) then

					if (coalesce(ie_passagem_dt_agenda_w,'N') = 'S') and (dt_agenda_w IS NOT NULL AND dt_agenda_w::text <> '') then
						dt_passagem_w := dt_agenda_w;
					else
						dt_passagem_w := clock_timestamp();
					end if;

					ie_tipo_passagem_w	:= obter_tipo_passagem_regra(cd_setor_agenda_w);

					--[1175] - Ao gerar prescricao, de atendimentos gerados pela Agenda de servicos, respeitar a "Regra de passagem na prescricao por setor na EUP" do Shift + F11
					if (coalesce(ie_regra_passagem_setor_w,'N') = 'S')
					and (coalesce(ie_tipo_passagem_w, '0') = 'T') then
						CALL gerar_entrada_setor_prescr(nr_atendimento_w, coalesce(cd_setor_agenda_w,cd_setor_atendimento_w), coalesce(dt_passagem_w, clock_timestamp()), nm_usuario_p);
					else
						if (ie_unid_compl_agend_w = 'S') then
							CALL Ageserv_Gerar_Pass_Setor_Atend(nr_atendimento_w, cd_setor_atend_agendamento_w, clock_timestamp(), 'S', nr_seq_unidade_basica_w, nm_usuario_p);
						elsif (ie_unid_compl_agend_w = 'N') then
							CALL Gerar_Passagem_Setor_Atend(nr_atendimento_w, coalesce(cd_setor_agenda_w,cd_setor_atendimento_w), coalesce(dt_passagem_w, clock_timestamp()), 'S', nm_usuario_p);
						end if;
					end if;

				END IF;
			end if;
		end if;

		if (ie_liberar_w	= 'S') then
			ie_gerar_kit_proc_lib_w := Obter_param_Usuario(916, 291, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_gerar_kit_proc_lib_w);

			if (ie_gerar_kit_proc_lib_w = 'S') then
				CALL Gerar_kit_procedimento(cd_estabelecimento_w, nr_prescricao_w, null, nm_usuario_p);
			end if;

			ds_erro_w := liberar_prescricao(nr_prescricao_w, nr_atendimento_w, ie_medico_w, Obter_Perfil_Ativo, nm_usuario_p, 'N', ds_erro_w);
		end if;
	end if;
END IF;
COMMIT;
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_agenda_servico (nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;

