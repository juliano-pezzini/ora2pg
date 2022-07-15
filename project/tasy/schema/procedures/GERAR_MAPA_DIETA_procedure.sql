-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mapa_dieta ( cd_setor_atendimento_p bigint, nm_usuario_p text, dt_dieta_p timestamp, cd_refeicao_p text, qt_horas_p bigint, cd_estabelecimento_p bigint default null, ie_somente_com_prescr_p text default 'N') AS $body$
DECLARE


cd_setor_atendimento_w		integer;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);
cd_pessoa_fisica_w		varchar(10);
nr_sequencia_w			bigint;
nr_dietas_duplas_w		bigint;
ie_status_w			varchar(1)             := 'A';
ie_destino_dieta_w		varchar(1);
nr_atendimento_w		bigint;
vl_parametro_w			varchar(15);
ie_gera_mapa_cc_w		varchar(2);
qt_passagem_cc_w		bigint;
ie_parametro_w			varchar(1);
qt_dieta_acomp_w		smallint;
qt_dieta_w			smallint;
ie_gera_dieta_w			varchar(1);
ie_lib_dieta_w			varchar(1);
ie_gerar_dados_ant_w		varchar(1);
nr_atendimento_acomp_w		bigint;
ie_gera_acomp_sem_acomod_w	varchar(1);
ie_atualizar_obs_nula_w		varchar(1);
ie_permite_rec_nasc_w		varchar(1);
ie_consistir_todos_mapas_w	varchar(1);
qt_registro_w			bigint;
nr_seq_atecaco_w		bigint;
ie_copia_obs_tecnica_w		varchar(1);
dt_refeicao_w			timestamp;
ie_atualizar_local_ref_w	varchar(1);
ie_filtro_estabelecimento_w	varchar(10);
cd_estabelecimento_w		varchar(20);
cd_estab_param_w		varchar(20);
ie_gerar_retroativo_w		varchar(1);
ie_obter_dieta_prescr_w		varchar(1);
ie_liberar_dieta_w		varchar(1);
ie_regra_ref_lib_w		varchar(1);
nr_seq_mapa_lib_w		bigint;
qt_existente_w			integer;
cd_dieta_acomp_w		bigint;
ie_alta_sem_saida_real_w	varchar(1);
qt_dias_sem_saida_real_w	bigint;
ie_prescr_liberadas_enferm_w	varchar(1);
varPrescrRN_w			varchar(1);
ie_possui_prescricao_w		varchar(1);
dt_final_w			timestamp;
ie_copia_dieta_w		varchar(1);
qt_horas_w			bigint;
nm_acompanhante_w		varchar(40);
ie_gerar_dieta_acomp_uti_w varchar(1);
teste_w				varchar(255);

c010 CURSOR FOR
SELECT	d.cd_setor_atendimento,
	d.cd_unidade_basica,
	d.cd_unidade_compl,
	b.cd_pessoa_fisica,
	'P',
	b.nr_atendimento,
	null,
	null
from  	setor_atendimento c,
	atend_paciente_unidade d,
	atendimento_paciente b
where 	b.nr_atendimento = d.nr_atendimento
and 	d.nr_seq_interno = obter_atepacu_paciente(b.nr_atendimento, 'A')
and	trunc(dt_entrada) <= trunc(dt_dieta_p)
and 	c.cd_setor_atendimento = d.cd_setor_atendimento
and (c.cd_classif_setor = '9' or ie_alta_sem_saida_real_w = 'S')
and 	((c.cd_setor_atendimento = cd_setor_atendimento_p) or
	((cd_setor_atendimento_p = 0) and ((cd_classif_setor in (3,4,8)) or (ie_permite_rec_nasc_w = 'S' and cd_classif_setor = 9))))
and (coalesce(dt_alta::text, '') = '' or (ie_alta_sem_saida_real_w = 'S' and coalesce(dt_saida_real::text, '') = '' and (b.dt_alta > clock_timestamp()-qt_dias_sem_saida_real_w or coalesce(qt_dias_sem_saida_real_w,0) = 0)))
and	b.cd_estabelecimento = coalesce(cd_estabelecimento_w,b.cd_estabelecimento)

union all

select	a.cd_setor_atendimento,
	a.cd_unidade_basica,
	a.cd_unidade_compl,
	b.cd_pessoa_fisica,
	'P',
	b.nr_atendimento,
	null,
	null
from  	atendimento_paciente b,
	unidade_atendimento a
where 	a.nr_atendimento = b.nr_atendimento
and 	a.ie_status_unidade in ('P','A')
and	trunc(dt_entrada) <= trunc(dt_dieta_p)
and 	((a.cd_setor_atendimento = cd_setor_atendimento_p) or ((cd_setor_atendimento_p = 0) and ((obter_classif_setor(a.cd_setor_atendimento) in (3,4,8)) or (ie_permite_rec_nasc_w = 'S' and obter_classif_setor(a.cd_setor_atendimento) = 9))))
and	b.cd_estabelecimento = coalesce(cd_estabelecimento_w,b.cd_estabelecimento)

union

select	a.cd_setor_atendimento,
	a.cd_unidade_basica,
	a.cd_unidade_compl,
	a.cd_paciente_reserva,
	'A',
	nr_atendimento,
	nr_atendimento_acomp,
	null
from  	unidade_atendimento a,
	setor_atendimento c
where 	a.ie_status_unidade = 'M'
and	(a.cd_paciente_reserva IS NOT NULL AND a.cd_paciente_reserva::text <> '')
and	a.cd_setor_atendimento = c.cd_setor_atendimento
and	c.cd_estabelecimento = coalesce(cd_estabelecimento_w,c.cd_estabelecimento)
and ((a.cd_setor_atendimento = cd_setor_atendimento_p) or ((cd_setor_atendimento_p = 0) and ((obter_classif_setor(a.cd_setor_atendimento) in (3,4,8)) or (ie_permite_rec_nasc_w = 'S' and obter_classif_setor(a.cd_setor_atendimento) = 9))))
and (
  (ie_gerar_dieta_acomp_uti_w = 'S' and obter_classif_setor(a.cd_setor_atendimento) = 4)
   or (obter_classif_setor(a.cd_setor_atendimento) != 4)
)

union

select	a.cd_setor_atendimento,
	a.cd_unidade_basica,
	a.cd_unidade_compl,
	coalesce(c.cd_pessoa_fisica,b.cd_pessoa_fisica),
	'A',
	b.nr_atendimento,
	b.nr_atendimento,
	c.nm_acompanhante
from  	atendimento_paciente b,
	unidade_atendimento a,
	atendimento_acompanhante c
where 	a.nr_atendimento = b.nr_atendimento
and 	b.nr_atendimento = c.nr_atendimento
and	trunc(dt_entrada) <= trunc(dt_dieta_p)
and	a.ie_status_unidade = 'P'
and 	((a.cd_setor_atendimento = cd_setor_atendimento_p) or ((cd_setor_atendimento_p = 0) and ((obter_classif_setor(a.cd_setor_atendimento) in (3,4,8)) or (ie_permite_rec_nasc_w = 'S' and obter_classif_setor(a.cd_setor_atendimento) = 9))))
and	coalesce(c.dt_saida::text, '') = ''
and	((c.cd_pessoa_fisica IS NOT NULL AND c.cd_pessoa_fisica::text <> '') or (c.nm_acompanhante IS NOT NULL AND c.nm_acompanhante::text <> ''))
and     ie_gera_acomp_sem_acomod_w = 'S'
and	b.cd_estabelecimento = coalesce(cd_estabelecimento_w,b.cd_estabelecimento)
and (
  (ie_gerar_dieta_acomp_uti_w = 'S' and obter_classif_setor(a.cd_setor_atendimento) = 4)
   or (obter_classif_setor(a.cd_setor_atendimento) != 4)
)

union

select	b.cd_setor_atendimento,
	b.cd_unidade_basica,
	b.cd_unidade_compl,
	a.cd_pessoa_fisica,
	'P',
	a.nr_atendimento,
	null,
	null
from	pessoa_fisica c,
	atendimento_paciente a,
	atend_paciente_unidade b
where	a.nr_atendimento = b.nr_atendimento
and	a.cd_pessoa_fisica = c.cd_pessoa_fisica
and	coalesce(dt_obito::text, '') = ''
and	(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '')
and	trunc(dt_dieta_p) between trunc(a.dt_entrada) and trunc(a.dt_alta)
and	b.nr_seq_interno = obter_atepacu_paciente(a.nr_atendimento,'IAA')
and	(((ie_gerar_retroativo_w = 'S') and (trunc(dt_dieta_p) < trunc(clock_timestamp())))
or 	((ie_alta_sem_saida_real_w = 'S') and (coalesce(dt_saida_real::text, '') = '') and (a.dt_alta > clock_timestamp()-qt_dias_sem_saida_real_w or coalesce(qt_dias_sem_saida_real_w,0) = 0)))
and (b.cd_setor_atendimento = cd_setor_atendimento_p)
and	not exists (	select	1
			from	mapa_dieta x
			where	x.nr_atendimento = a.nr_atendimento
			and	trunc(x.dt_dieta) = trunc(dt_dieta_p)
			and	x.cd_refeicao = cd_refeicao_p)

union

select	d.cd_setor_atendimento,
	d.cd_unidade_basica,
	d.cd_unidade_compl,
	b.cd_pessoa_fisica,
	'P',
	b.nr_atendimento,
	null,
	null
from  	setor_atendimento c,
	atend_paciente_unidade d,
	atendimento_paciente b
where 	b.nr_atendimento = d.nr_atendimento
and 	d.cd_setor_atendimento = c.cd_setor_atendimento
and 	d.nr_seq_interno = obter_atepacu_paciente(b.nr_atendimento, 'A')
and	trunc(dt_entrada) <= trunc(dt_dieta_p)
and 	c.cd_classif_setor in ('1','2','5')
and 	((d.cd_setor_atendimento = cd_setor_atendimento_p) or
	((cd_setor_atendimento_p = 0) and (Obter_Regra_Geracao_Mapa_Setor(d.cd_setor_atendimento) = 'A')))
and	b.cd_estabelecimento = coalesce(cd_estabelecimento_w,b.cd_estabelecimento)
and (coalesce(dt_alta::text, '') = '' or (ie_alta_sem_saida_real_w = 'S' and coalesce(dt_saida_real::text, '') = '' and (b.dt_alta > clock_timestamp()-qt_dias_sem_saida_real_w or coalesce(qt_dias_sem_saida_real_w,0) = 0)))
and	dt_entrada >= trunc(dt_dieta_p) -30
order by 1;


BEGIN

cd_estab_param_w := coalesce(cd_estabelecimento_p,wheb_usuario_pck.get_cd_estabelecimento);

ie_copia_dieta_w := obter_param_usuario(1000, 2, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_copia_dieta_w);
ie_parametro_w := obter_param_usuario(1000, 4, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_parametro_w);
cd_dieta_acomp_w := obter_param_usuario(1000, 5, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, cd_dieta_acomp_w);
ie_gerar_retroativo_w := obter_param_usuario(1000, 12, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_gerar_retroativo_w);
varPrescrRN_w := obter_param_usuario(1000, 19, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, varPrescrRN_w);
ie_gerar_dieta_acomp_uti_w := obter_param_usuario(1000, 24, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_gerar_dieta_acomp_uti_w);
ie_permite_rec_nasc_w := obter_param_usuario(1000, 26, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_permite_rec_nasc_w);
ie_gerar_dados_ant_w := obter_param_usuario(1000, 27, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_gerar_dados_ant_w);
ie_atualizar_obs_nula_w := obter_param_usuario(1000, 38, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_atualizar_obs_nula_w);
ie_consistir_todos_mapas_w := obter_param_usuario(1000, 61, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_consistir_todos_mapas_w);
ie_copia_obs_tecnica_w := obter_param_usuario(1000, 64, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_copia_obs_tecnica_w);
ie_atualizar_local_ref_w := obter_param_usuario(1000, 74, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_atualizar_local_ref_w);
ie_filtro_estabelecimento_w := obter_param_usuario(1000, 75, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_filtro_estabelecimento_w);
ie_obter_dieta_prescr_w := obter_param_usuario(1000, 100, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_obter_dieta_prescr_w);
ie_prescr_liberadas_enferm_w := obter_param_usuario(1000, 114, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_prescr_liberadas_enferm_w);
ie_liberar_dieta_w := obter_param_usuario(1000, 128, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_liberar_dieta_w);
ie_alta_sem_saida_real_w := obter_param_usuario(1000, 129, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, ie_alta_sem_saida_real_w);
qt_dias_sem_saida_real_w := obter_param_usuario(1000, 130, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w, qt_dias_sem_saida_real_w);

if (ie_filtro_estabelecimento_w = 'S') then
	cd_estabelecimento_w := cd_estab_param_w;
else
	cd_estabelecimento_w := null;
end if;

vl_parametro_w	:= coalesce(obter_valor_param_usuario(1000, 8, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w),'N');

ie_gera_mapa_cc_w	:= coalesce(obter_valor_param_usuario(1000, 23, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w),'S');

ie_gera_acomp_sem_acomod_w	:= coalesce(obter_valor_param_usuario(1000, 36, obter_perfil_ativo, nm_usuario_p, cd_estab_param_w),'S');

if (ie_copia_dieta_w = 'S') or (ie_copia_dieta_w = 'R') then
	qt_horas_w := qt_horas_p;
else
	qt_horas_w := 0;
end if;

open c010;
loop
	fetch c010 into
		cd_setor_atendimento_w,
		cd_unidade_basica_w,
		cd_unidade_compl_w,
		cd_pessoa_fisica_w,
		ie_destino_dieta_w,
		nr_atendimento_w,
		nr_atendimento_acomp_w,
		nm_acompanhante_w;
	EXIT WHEN NOT FOUND; /* apply on c010 */

	dt_refeicao_w	:= obter_data_dieta_mapa(dt_dieta_p,null,cd_refeicao_p);

	if (dt_refeicao_w IS NOT NULL AND dt_refeicao_w::text <> '') then

		if (ie_consistir_todos_mapas_w = 'N') then
			begin
				select 	1
				into STRICT	qt_registro_w
				from 	mapa_dieta c
				where	c.cd_setor_atendimento	= cd_setor_atendimento_w
				and (c.cd_unidade_basica	= cd_unidade_basica_w and obter_tipo_acomodacao_atend(c.nr_atendimento,'C') <> '0')
				and 	c.cd_unidade_compl	= cd_unidade_compl_w
				and	c.ie_destino_dieta	= ie_destino_dieta_w
				and 	c.dt_dieta		= dt_dieta_p
				and 	c.cd_refeicao		= cd_refeicao_p
				and 	((obter_classif_setor(c.cd_setor_atendimento) <> 1
				and	ie_alta_sem_saida_real_w = 'N')
				or	c.nr_atendimento	= nr_atendimento_w)  LIMIT 1;

			exception
			when others then
				qt_registro_w := 0;
			end;
		elsif (ie_consistir_todos_mapas_w = 'S') then

			begin
				select 	1
				into STRICT	qt_registro_w
				from 	mapa_dieta c
				where	dt_refeicao_w 		>= clock_timestamp()
				and 	c.cd_setor_atendimento	= cd_setor_atendimento_w
				and (c.cd_unidade_basica	= cd_unidade_basica_w and obter_tipo_acomodacao_atend(c.nr_atendimento,'C') <> '0')
				and 	c.cd_unidade_compl	= cd_unidade_compl_w
				and	c.ie_destino_dieta	= ie_destino_dieta_w
				and 	c.dt_dieta		= dt_dieta_p
				and 	c.cd_refeicao		= cd_refeicao_p
				and 	((obter_classif_setor(c.cd_setor_atendimento) <> 1
				and	ie_alta_sem_saida_real_w = 'N')
				or	c.nr_atendimento	= nr_atendimento_w)  LIMIT 1;

			exception
			when others then
				qt_registro_w := 0;
			end;

			if (qt_registro_w = 0) then

				begin
					select 	1
					into STRICT	qt_registro_w
					from 	mapa_dieta c
					where 	c.nr_atendimento	= nr_atendimento_w
					and 	dt_refeicao_w 		< clock_timestamp()
					and	c.ie_destino_dieta	= ie_destino_dieta_w
					and 	c.dt_dieta		= dt_dieta_p
					and 	c.cd_refeicao		= cd_refeicao_p
					and	((obter_classif_setor(c.cd_setor_atendimento) <> 1
					and	ie_alta_sem_saida_real_w = 'N')
					or	c.nr_atendimento	= nr_atendimento_w)  LIMIT 1;

				exception
				when others then
					qt_registro_w	:= 0;
				end;
			end if;
		end if;
	else

		select 	count(*)
		into STRICT	qt_registro_w
		from 	mapa_dieta c
		where	c.cd_setor_atendimento	= cd_setor_atendimento_w
		and (c.cd_unidade_basica	= cd_unidade_basica_w and obter_tipo_acomodacao_atend(c.nr_atendimento,'C') <> '0')
		and 	c.cd_unidade_compl	= cd_unidade_compl_w
		and	c.ie_destino_dieta	= ie_destino_dieta_w
		and 	c.dt_dieta		= dt_dieta_p
		and 	c.cd_refeicao		= cd_refeicao_p
		and	((obter_classif_setor(c.cd_setor_atendimento) <> 1
		and	ie_alta_sem_saida_real_w = 'N')
		or	c.nr_atendimento	= nr_atendimento_w);


	end if;

	if (trunc(dt_dieta_p, 'dd') = trunc(clock_timestamp(), 'dd')) then
		dt_final_w	:= clock_timestamp();
	else
		dt_final_w	:= fim_dia(dt_dieta_p);
	end if;

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_possui_prescricao_w
	from 	prescr_dieta b,
		prescr_medica a
	where 	a.nr_prescricao 	= b.nr_prescricao
	and 	a.nr_atendimento	= nr_atendimento_w
	and 	cd_refeicao_p	= CASE WHEN coalesce(b.ie_refeicao,'T')='T' THEN  cd_refeicao_p  ELSE coalesce(b.ie_refeicao,'T') END 
	and	(((coalesce(a.dt_liberacao,a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao,a.dt_liberacao_medico))::text <> '') and ie_prescr_liberadas_enferm_w = 'N')
	or	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> ''))
	and 	coalesce(b.ie_suspenso,'N') = 'N'
	and 	a.dt_prescricao	> clock_timestamp() - (qt_horas_p / 24)
	and	a.dt_prescricao <= dt_final_w
	and	((coalesce(a.ie_recem_nato,'N') = 'N') or (a.ie_recem_nato = varPrescrRN_w));

	if (qt_registro_w	= 0) and ((ie_possui_prescricao_w = 'S') or (ie_somente_com_prescr_p = 'N')) then
		select nextval('mapa_dieta_seq')
		into STRICT nr_sequencia_w
		;

		ie_gera_dieta_w	:= 'S';

		if (ie_parametro_w = 'S') and (ie_destino_dieta_w = 'A') then

			ie_gera_dieta_w	:= 'N';
			nr_seq_atecaco_w	:= obter_atecaco_atendimento(nr_atendimento_acomp_w);

			select	max(ie_lib_dieta),
				max(qt_dieta_acomp)
			into STRICT	ie_lib_dieta_w,
				qt_dieta_acomp_w
			from	atend_categoria_convenio
			where	nr_atendimento	= nr_atendimento_acomp_w
			and	nr_seq_interno = nr_seq_atecaco_w;

			begin
			select	count(*)
			into STRICT	qt_dieta_w
			from	mapa_dieta
			where	nr_atendimento		= nr_atendimento_acomp_w
			and	ie_destino_dieta	= 'A'
			and	((cd_refeicao		= cd_refeicao_p) or (ie_lib_dieta_w = 'S'))
			and	trunc(dt_dieta,'dd') 	= trunc(dt_dieta_p,'dd');
			exception
				when no_data_found then
					qt_dieta_w 	:= 0;
			end;

			if (ie_lib_dieta_w = 'T') or
				(ie_lib_dieta_w = 'C' AND cd_refeicao_p = 'D') or
				(ie_lib_dieta_w = 'B' AND cd_refeicao_p = 'A') or
				(ie_lib_dieta_w = 'E' AND cd_refeicao_p = 'J') or
				((ie_lib_dieta_w = 'G') and (cd_refeicao_p = 'D') and (cd_refeicao_p = 'J')) or
				((ie_lib_dieta_w = 'L') and ((cd_refeicao_p = 'D') or (cd_refeicao_p = 'A') or (cd_refeicao_p = 'J'))) or
				((ie_lib_dieta_w = 'A') and ((cd_refeicao_p = 'A') or (cd_refeicao_p = 'J'))) or
				((ie_lib_dieta_w = 'D') and ((cd_refeicao_p = 'D') or (cd_refeicao_p = 'L') or (cd_refeicao_p = 'C'))) or
				((ie_lib_dieta_w = 'F') and ((cd_refeicao_p = 'D') or (cd_refeicao_p = 'A'))) or
				(ie_lib_dieta_w = 'S' AND qt_dieta_w < qt_dieta_acomp_w) then
				ie_gera_dieta_w	:= 'S';
			end if;
		end if;


		ie_regra_ref_lib_w := Obter_se_refeicao_lib_acomp(nr_atendimento_acomp_w);
		if (ie_regra_ref_lib_w = 'N') and (ie_destino_dieta_w = 'A') then
			ie_gera_dieta_w := 'N';
		end if;

		begin
			select	1
			into STRICT	qt_passagem_cc_w
			from	setor_atendimento b,
				atend_paciente_unidade a
			where	a.nr_atendimento	= nr_atendimento_w
			and	a.cd_setor_atendimento	= b.cd_setor_atendimento
			and	b.cd_classif_setor	= 2
			and	coalesce(a.dt_saida_unidade::text, '') = ''  LIMIT 1;
		exception
		when no_data_found then
			qt_passagem_cc_w := 0;
		end;



		if (ie_gera_dieta_w = 'S') and
			((ie_gera_mapa_cc_w = 'S') or (qt_passagem_cc_w = 0)) then
		  	begin

			insert into mapa_dieta(
				cd_pessoa_fisica,
				nr_sequencia,
				dt_dieta,
				cd_refeicao,
				dt_atualizacao,
				nm_usuario,
				cd_setor_atendimento,
				cd_unidade_basica,
				cd_unidade_compl,
				ie_destino_dieta,
				cd_dieta,
				nr_atendimento,
				ie_status,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				ie_recem_nato,
				nm_acompanhante)
			values (cd_pessoa_fisica_w,
				nr_sequencia_w,
				dt_dieta_p,
				cd_refeicao_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				cd_unidade_basica_w,
				cd_unidade_compl_w,
				ie_destino_dieta_w,
				CASE WHEN ie_destino_dieta_w='P' THEN null  ELSE CASE WHEN cd_dieta_acomp_w=0 THEN null  ELSE cd_dieta_acomp_w END  END ,
				nr_atendimento_w,
				ie_status_w,
				nm_usuario_p,
				clock_timestamp(),
				'N',
				nm_acompanhante_w);

			commit;

			nr_seq_mapa_lib_w := nr_sequencia_w;

			if (qt_horas_w > 0) and (ie_gerar_dados_ant_w <> 'N') and
				((ie_destino_dieta_w = 'P') or (coalesce(cd_dieta_acomp_w,0) = 0)) then
				CALL copiar_dieta_anterior(nr_sequencia_w, nm_usuario_p, qt_horas_w, cd_estabelecimento_w);
			end if;

			if (ie_copia_obs_tecnica_w = 'S') and
				(((vl_parametro_w in ('S','U')) and (qt_horas_w > 0)) or (vl_parametro_w in ('A','P','PU','IP','IPU'))) then
				CALL gerar_observacao_tecnica(cd_setor_atendimento_w, dt_dieta_p, cd_refeicao_p, vl_parametro_w, ie_atualizar_obs_nula_w, nm_usuario_p);
			end if;


			if (ie_atualizar_local_ref_w = 'S') then

				CALL gerar_local_refeicao(cd_setor_atendimento_w, dt_dieta_p, cd_refeicao_p, ie_atualizar_local_ref_w, nm_usuario_p);
			end if;

			--nut_copiar_anotacao_pac(nr_sequencia_w, dt_dieta_p, cd_pessoa_fisica_w, ie_destino_dieta_w, cd_refeicao_p);
			if (ie_obter_dieta_prescr_w = 'S') then
				CALL Obter_Dieta_Prescricao_pac(cd_setor_atendimento_w, qt_horas_p, dt_dieta_p, cd_refeicao_p, nm_usuario_p, cd_pessoa_fisica_w, nr_sequencia_w, cd_estabelecimento_w);
			end if;

			if (ie_liberar_dieta_w = 'S') then

				begin
				select	1
				into STRICT	qt_existente_w
				from	mapa_dieta
				where	nr_sequencia = nr_seq_mapa_lib_w  LIMIT 1;
				exception
				when no_data_found then
					qt_existente_w := 0;
				end;

				if (qt_existente_w = 0) then
					select	max(nr_sequencia)
					into STRICT	nr_seq_mapa_lib_w
					from 	mapa_dieta
					where 	cd_pessoa_fisica 	= cd_pessoa_fisica_w
					and 	dt_dieta 		= dt_dieta_p
					and 	cd_refeicao 		= cd_refeicao_p
					and	ie_destino_dieta 	= ie_destino_dieta_w
					and	cd_setor_atendimento 	= cd_setor_atendimento_w
					and	nr_atendimento 		= nr_atendimento_w
					and	coalesce(nr_seq_superior::text, '') = ''
					and 	coalesce(dt_liberacao::text, '') = '';
				end if;

				if (nr_seq_mapa_lib_w IS NOT NULL AND nr_seq_mapa_lib_w::text <> '') then
					CALL liberar_dieta(nr_seq_mapa_lib_w, nm_usuario_p);
				end if;
			end if;

			exception
				when others then
					nr_dietas_duplas_w := nr_dietas_duplas_w + 1;
			end;
		end if;

	else
		nr_sequencia_w := null;
	end if;

	if (ie_obter_dieta_prescr_w = 'T') then
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
			CALL Obter_Dieta_Prescricao_pac(cd_setor_atendimento_w, qt_horas_p, dt_dieta_p, cd_refeicao_p, nm_usuario_p, cd_pessoa_fisica_w, nr_sequencia_w, cd_estabelecimento_w);
		else
			select	max(nr_sequencia)
			into STRICT	nr_sequencia_w
			from	mapa_dieta
			where	cd_setor_atendimento = cd_setor_atendimento_w
			and	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	cd_unidade_basica = cd_unidade_basica_w
			and	cd_unidade_compl = cd_unidade_compl_w
			and	ie_destino_dieta = ie_destino_dieta_w
			and	nr_atendimento = nr_atendimento_w
			and	trunc(dt_dieta) = trunc(dt_dieta_p)
			and	cd_refeicao = cd_refeicao_p
			and	ie_status = 'A'
			and	ie_recem_nato = 'N'
			and	coalesce(nr_seq_superior::text, '') = '';

			if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
				CALL Obter_Dieta_Prescricao_pac(cd_setor_atendimento_w, qt_horas_p, dt_dieta_p, cd_refeicao_p, nm_usuario_p, cd_pessoa_fisica_w, nr_sequencia_w, cd_estabelecimento_w);
			end if;
		end if;
	end if;
end loop;
close c010;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mapa_dieta ( cd_setor_atendimento_p bigint, nm_usuario_p text, dt_dieta_p timestamp, cd_refeicao_p text, qt_horas_p bigint, cd_estabelecimento_p bigint default null, ie_somente_com_prescr_p text default 'N') FROM PUBLIC;

