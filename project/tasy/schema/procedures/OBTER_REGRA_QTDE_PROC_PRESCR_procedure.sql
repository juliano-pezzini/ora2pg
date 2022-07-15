-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_qtde_proc_prescr (nr_prescricao_p bigint, nr_atendimento_p bigint, ds_erro_p INOUT text, cd_procedimento_p bigint default null) AS $body$
DECLARE



/*	ie_tipo_qtde =		D - Dia
				H - Horas (período)
				A - Atendimento 	*/
cd_convenio_w			integer;
ie_tipo_atendimento_w		smallint;
qt_permitida_w			double precision;
qt_procedimento_w		double precision;
ie_acao_excesso_w		varchar(1);
qt_horas_intervalo_w		integer;
qt_registros_w			integer;

qt_executada_w			double precision;
qt_executada_dia_w		double precision;
qt_executada_mes_w		double precision;
qt_executada_ano_w		double precision;
qt_executada_atend_w		double precision;
qt_executada_periodo_w		double precision;
ds_erro_w			varchar(255);
ie_tipo_qtde_w			varchar(1);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;

ie_tipo_uso_w			varchar(01);
cd_proc_referencia_w		bigint;
ie_origem_proc_refer_w		bigint;
pr_permitida_w			double precision;


cd_area_procedimento_w		bigint;
cd_especialidade_w              bigint;
cd_grupo_proc_w			bigint;

cd_pessoa_fisica_w		varchar(10);
qt_exec_paciente_w		bigint;
cd_estabelecimento_w		smallint;
qt_dias_internacao_w		bigint;
dt_prev_execucao_w		timestamp;
cd_tipo_acomod_w		smallint;
ds_mensagem_w			varchar(255);
qt_exec_pac_mes_w		bigint;
qt_idade_w			double precision;

nr_seq_forma_org_w		bigint;
nr_seq_grupo_w			bigint;
nr_seq_subgrupo_w		bigint;
qt_executado_aih_w			bigint;

nr_seq_proc_interno_w		prescr_procedimento.nr_seq_proc_interno%type;
nr_seq_proc_int_regra_w		prescr_procedimento.nr_seq_proc_interno%type;
nr_seq_exame_w			prescr_procedimento.nr_seq_exame%type;
nr_seq_exame_regra_w		prescr_procedimento.nr_seq_exame%type;

C01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	qt_procedimento,
	nr_seq_proc_interno,
	dt_prev_execucao,
	nr_seq_exame
from	prescr_procedimento
where	nr_prescricao	= nr_prescricao_p
and	cd_procedimento = coalesce(cd_procedimento_p,cd_procedimento);

c02 CURSOR FOR
SELECT 	coalesce(a.qt_permitida,0),
	coalesce(a.ie_acao_excesso,'@'),
	coalesce(a.qt_horas_intervalo,0),
	coalesce(a.ie_tipo_qtde,'@'),
	coalesce(a.ie_tipo_uso,0),
	coalesce(a.cd_proced_referencia,0),
	coalesce(a.ie_origem_proc_ref,0),
	coalesce(a.pr_permitida,0),
	a.nr_seq_proc_interno,
	a.nr_seq_exame,
	a.ds_mensagem
from 	convenio_regra_qtde_proc a
where	coalesce(a.cd_procedimento, cd_procedimento_w)		= cd_procedimento_w
and	coalesce(a.ie_origem_proced, ie_origem_proced_w)		= ie_origem_proced_w
and	coalesce(cd_area_procedimento, cd_area_procedimento_w)	= cd_area_procedimento_w
and	coalesce(cd_especialidade, cd_especialidade_w)		= cd_especialidade_w
and	coalesce(cd_grupo_proc, cd_grupo_proc_w)			= cd_grupo_proc_w
and	coalesce(a.nr_seq_proc_interno,coalesce(nr_seq_proc_interno_w,0)) = coalesce(nr_seq_proc_interno_w,0)
and	a.cd_convenio						= cd_convenio_w
and 	coalesce(a.ie_tipo_atendimento,ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,0)) 	= coalesce(cd_estabelecimento_w,0)
and	qt_dias_internacao_w between coalesce(qt_dias_inter_inicio, qt_dias_internacao_w) and coalesce(qt_dias_inter_final, qt_dias_internacao_w)
and	coalesce(qt_idade_w,1) between coalesce(obter_idade_regra_uso(a.nr_sequencia,'MIN','P'),0) and coalesce(obter_idade_regra_uso(a.nr_sequencia,'MAX','P'),9999999)
and	coalesce(cd_tipo_acomodacao, coalesce(cd_tipo_acomod_w,0)) = coalesce(cd_tipo_acomod_w,0)
and	coalesce(a.ie_situacao,'A') = 'A'
and	coalesce(cd_perfil, coalesce(obter_perfil_ativo, 0)) = coalesce(obter_perfil_ativo, 0)
and	coalesce(nr_seq_grupo,nr_seq_grupo_w) 			= nr_seq_grupo_w
and	coalesce(nr_seq_forma_org,nr_seq_forma_org_w) 		= nr_seq_forma_org_w
and	coalesce(nr_seq_subgrupo,nr_seq_subgrupo_w) 			= nr_seq_subgrupo_w
and	coalesce(a.nr_seq_proc_interno,coalesce(nr_seq_proc_interno_w,0)) = coalesce(nr_seq_proc_interno_w,0)
and	coalesce(a.nr_seq_exame,coalesce(nr_seq_exame_w,0))		= coalesce(nr_seq_exame_w,0)
order by	coalesce(cd_procedimento,0),
	coalesce(nr_seq_proc_interno,0),
	coalesce(nr_seq_exame,0),
	coalesce(cd_grupo_proc,0),
	coalesce(cd_especialidade,0),
	coalesce(cd_area_procedimento,0),
	coalesce(cd_estabelecimento,0),
	coalesce(cd_perfil, 0);


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	convenio_regra_qtde_proc a where		coalesce(a.ie_situacao,'A') = 'A' LIMIT 1;

if (qt_registros_w > 0) then
	open C01;
	loop
	fetch c01 into 	cd_procedimento_w,
			ie_origem_proced_w,
			qt_executada_w,
			nr_seq_proc_interno_w,
			dt_prev_execucao_w,
			nr_seq_exame_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	select	cd_area_procedimento,
			cd_especialidade,
			cd_grupo_proc
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	begin
	select	coalesce(nr_seq_grupo,0),
		coalesce(nr_seq_forma_org,0),
		coalesce(nr_seq_subgrupo,0)
	into STRICT	nr_seq_grupo_w,
		nr_seq_forma_org_w,
		nr_seq_subgrupo_w
	from	sus_estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;
	exception
	when others then
		nr_seq_grupo_w	:= 0;
		nr_seq_forma_org_w := 0;
		nr_seq_subgrupo_w := 0;
	end;

	ds_erro_w		:= '';

	select	coalesce(max(obter_convenio_atendimento(nr_atendimento_p)),0),
		coalesce(max((obter_tipo_acomod_atend(nr_atendimento_p,'C'))::numeric ),0)
	into STRICT	cd_convenio_w,
		cd_tipo_acomod_w
	;

	select 	coalesce(max(ie_tipo_atendimento),0),
		coalesce(max(cd_estabelecimento),0),
		coalesce(trunc(max(coalesce(dt_alta, clock_timestamp()) - dt_entrada)),0),
		max(cd_pessoa_fisica)
	into STRICT	ie_tipo_atendimento_w,
		cd_estabelecimento_w,
		qt_dias_internacao_w,
		cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;

	begin
	select	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA'))
	into STRICT	qt_idade_w
	from	pessoa_fisica b
	where	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	exception
	when others then
		qt_idade_w	:= 0;
	end;

		open	c02;
		loop
		fetch	c02 into
			qt_permitida_w,
			ie_acao_excesso_w,
			qt_horas_intervalo_w,
			ie_tipo_qtde_w,
			ie_tipo_uso_w,
			cd_proc_referencia_w,
			ie_origem_proc_refer_w,
			pr_permitida_w,
			nr_seq_proc_int_regra_w,
			nr_seq_exame_regra_w,
			ds_mensagem_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			qt_permitida_w	:= qt_permitida_w;

			if (ie_tipo_uso_w	= 'Q') then
				begin

				if (ie_tipo_qtde_w = 'D') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_dia_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	trunc(dt_procedimento)	= trunc(coalesce(DT_PREV_EXECUCAO_w,clock_timestamp()))
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if (qt_executada_dia_w + qt_executada_w) > qt_permitida_w then
						begin
						ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)|| WHEB_MENSAGEM_PCK.get_texto(281633);

						end;
					end if;
					end;
				end if;


				if (ie_tipo_qtde_w = 'A') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_atend_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if (qt_executada_atend_w + qt_executada_w) > qt_permitida_w then
						begin
						ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)|| WHEB_MENSAGEM_PCK.get_texto(281634);
						end;
					end if;
					end;
				end if;

				if (ie_tipo_qtde_w = 'P') then -- Paciente
					select 	coalesce(max(cd_pessoa_fisica),'0')
					into STRICT	cd_pessoa_fisica_w
					from 	atendimento_paciente
					where 	nr_atendimento = nr_atendimento_p;

					select 	coalesce(sum(a.qt_procedimento),0)
					into STRICT	qt_exec_paciente_w
					from	procedimento_paciente 	a,
						conta_paciente		b,
						atendimento_paciente	c
					where	b.nr_interno_conta 	= a.nr_interno_conta
					and 	c.nr_atendimento	= b.nr_atendimento
					and 	c.cd_pessoa_fisica	= cd_pessoa_fisica_w
					and	a.cd_procedimento	= cd_procedimento_w
					and	a.ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

					if	((qt_exec_paciente_w + qt_executada_w) > qt_permitida_w ) then
						ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(281635);
					end if;

				end if;


				if (ie_tipo_qtde_w = 'H') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_periodo_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	coalesce(cd_motivo_exc_conta::text, '') = ''
					and	dt_procedimento between
						(clock_timestamp() - (qt_horas_intervalo_w * 60 /1440)) and clock_timestamp();

					if (qt_executada_periodo_w > qt_permitida_w) then
						begin
						ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)|| WHEB_MENSAGEM_PCK.get_texto(281636);
						end;
					end if;
					end;
				end if;

				if (ie_tipo_qtde_w = 'N') then -- Mês/Paciente
					select 	coalesce(max(cd_pessoa_fisica),'0')
					into STRICT	cd_pessoa_fisica_w
					from 	atendimento_paciente
					where 	nr_atendimento = nr_atendimento_p;

					select 	coalesce(sum(a.qt_procedimento),0)
					into STRICT	qt_exec_pac_mes_w
					from	procedimento_paciente a,
						conta_paciente b,
						atendimento_paciente c
					where	b.nr_interno_conta = a.nr_interno_conta
					and 	c.nr_atendimento = b.nr_atendimento
					and	a.cd_procedimento = cd_procedimento_w
					and	a.ie_origem_proced = ie_origem_proced_w
					and 	c.cd_pessoa_fisica = cd_pessoa_fisica_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	trunc(a.dt_procedimento,'Month') = trunc(clock_timestamp(),'Month')
					and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

					if	((qt_exec_pac_mes_w + qt_executada_w) > qt_permitida_w ) then
						ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(1018531);
					end if;
				end if;

				if (ie_tipo_qtde_w = 'I') then

					if	((obter_dados_atendimento(nr_atendimento_p, 'TA') = 1) and (obter_tipo_convenio_atend(nr_atendimento_p) = 3)) then
						begin

						select	coalesce(sum(p.qt_procedimento),0)
						into STRICT	qt_executado_aih_w
						from	sus_aih_unif a,
								conta_paciente c,
								procedimento_paciente p
						where	c.nr_interno_conta = a.nr_interno_conta
						and	p.nr_interno_conta = c.nr_interno_conta
						and	coalesce(p.cd_motivo_exc_conta::text, '') = ''
						and	c.nr_atendimento = nr_atendimento_p
						and	p.cd_procedimento = cd_procedimento_w
						and	p.ie_origem_proced = ie_origem_proced_w
						and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (p.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
						and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (p.nr_seq_exame = nr_seq_exame_regra_w))
						and	c.ie_status_acerto = 1;

						if (qt_executado_aih_w = 0) then

							select	coalesce(sum(p.qt_procedimento),0)
							into STRICT	qt_executado_aih_w
							from	conta_paciente c,
									procedimento_paciente p
							where	p.nr_interno_conta = c.nr_interno_conta
							and	coalesce(p.cd_motivo_exc_conta::text, '') = ''
							and	c.nr_atendimento = nr_atendimento_p
							and	p.cd_procedimento = cd_procedimento_w
							and	p.ie_origem_proced = ie_origem_proced_w
							and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (p.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
							and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (p.nr_seq_exame = nr_seq_exame_regra_w))
							and	c.ie_status_acerto = 1;

						end if;

						if	((qt_executado_aih_w + qt_executada_w) > qt_permitida_w) then
							begin
							ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)|| WHEB_MENSAGEM_PCK.get_texto(281638);
							end;
						end if;
						end;
					end if;

				end if;

				if (ie_tipo_qtde_w = 'J') then -- Dia/Paciente
					select 	coalesce(max(cd_pessoa_fisica),'0')
					into STRICT	cd_pessoa_fisica_w
					from 	atendimento_paciente
					where 	nr_atendimento = nr_atendimento_p;

					select 	coalesce(sum(a.qt_procedimento),0)
					into STRICT	qt_exec_pac_mes_w
					from	procedimento_paciente a,
						conta_paciente b,
						atendimento_paciente c
					where	b.nr_interno_conta = a.nr_interno_conta
					and 	c.nr_atendimento = b.nr_atendimento
					and	a.cd_procedimento = cd_procedimento_w
					and	a.ie_origem_proced = ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and 	c.cd_pessoa_fisica = cd_pessoa_fisica_w
					and	trunc(a.dt_procedimento,'dd') = trunc(clock_timestamp(),'dd')
					and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

					if	((qt_exec_pac_mes_w + qt_executada_w) > qt_permitida_w ) then
						ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(1018531);
					end if;
				end if;

				end;
			elsif (pr_permitida_w	> 0) then
				begin

				if (ie_tipo_qtde_w = 'D') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	trunc(dt_procedimento)	= trunc(clock_timestamp())
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_dia_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_proc_referencia_w
					and	ie_origem_proced	= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	trunc(dt_procedimento)	= trunc(clock_timestamp())
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_dia_w)  >= pr_permitida_w) then
						ds_erro_w 	:=  WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281639);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;
				end if;


				if (ie_tipo_qtde_w = 'T') then
					begin
					select 	coalesce(sum(a.qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	conta_paciente b,
						procedimento_paciente a
					where	a.nr_atendimento		= b.nr_atendimento
					and	a.cd_procedimento		= cd_procedimento_w
					and	a.ie_origem_proced		= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	a.nr_interno_conta		= b.nr_interno_conta
					and	b.cd_convenio_parametro		= cd_convenio_w
					and	trunc(a.dt_procedimento)	= trunc(clock_timestamp())
					and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

					select 	coalesce(sum(a.qt_procedimento),0)
					into STRICT	qt_executada_dia_w
					from	conta_paciente b,
					procedimento_paciente a
					where	a.nr_atendimento		= b.nr_atendimento
					and	a.cd_procedimento		= cd_proc_referencia_w
					and	a.ie_origem_proced		= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	coalesce(cd_motivo_exc_conta::text, '') = ''
					and	a.nr_interno_conta		= b.nr_interno_conta
					and	b.cd_convenio_parametro		= cd_convenio_w
					and	trunc(a.dt_procedimento)	= trunc(clock_timestamp())
					and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_dia_w)  >= pr_permitida_w) then
						ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281639);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;
				end if;

				if (ie_tipo_qtde_w = 'M') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	trunc(dt_procedimento, 'month')	= trunc(clock_timestamp(), 'month')
					and	coalesce(cd_motivo_exc_conta::text, '') = '';


					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_mes_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_proc_referencia_w
					and	ie_origem_proced	= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	trunc(dt_procedimento, 'month')	= trunc(clock_timestamp(), 'month')
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_mes_w)  >= pr_permitida_w) then
						ds_erro_w 	:=  WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281640);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;
				end if;

				if (ie_tipo_qtde_w = 'Y') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	trunc(dt_procedimento, 'year')	= trunc(clock_timestamp(), 'year')
					and	coalesce(cd_motivo_exc_conta::text, '') = '';


					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_ano_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_proc_referencia_w
					and	ie_origem_proced	= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	trunc(dt_procedimento, 'year')	= trunc(clock_timestamp(), 'year')
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_ano_w)  >= pr_permitida_w) then
						ds_erro_w 	:=  WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281641);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;
				end if;

				if (ie_tipo_qtde_w = 'Z') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	conta_paciente b,
						procedimento_paciente a
					where	a.nr_atendimento		= b.nr_atendimento
					and	a.cd_procedimento		= cd_procedimento_w
					and	a.ie_origem_proced		= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	a.nr_interno_conta 		= b.nr_interno_conta
					and	trunc(dt_procedimento, 'month')	= trunc(clock_timestamp(), 'month')
					and	b.cd_convenio_parametro		= cd_convenio_w
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_mes_w
					from	conta_paciente b,
						procedimento_paciente a
					where	a.nr_atendimento		= b.nr_atendimento
					and	cd_procedimento			= cd_proc_referencia_w
					and	ie_origem_proced		= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	coalesce(cd_motivo_exc_conta::text, '') = ''
					and	a.nr_interno_conta 		= b.nr_interno_conta
					and	b.cd_convenio_parametro		= cd_convenio_w
					and	b.cd_convenio_parametro		= cd_convenio_w
					and	trunc(dt_procedimento, 'month')	= trunc(clock_timestamp(), 'month')
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_mes_w)  >= pr_permitida_w) then
						ds_erro_w 	:=  WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281640);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;
				end if;


				if (ie_tipo_qtde_w = 'A') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_atend_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_proc_referencia_w
					and	ie_origem_proced	= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_atend_w)  >= pr_permitida_w) then
						ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281642);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;

				end if;


				if (ie_tipo_qtde_w = 'H') then
					begin
					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_procedimento_w
					from	procedimento_paciente
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
					and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
					and	dt_procedimento between
						(clock_timestamp() - (qt_horas_intervalo_w * 60 /1440)) and clock_timestamp()
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					select 	coalesce(sum(qt_procedimento),0)
					into STRICT	qt_executada_periodo_w
					from	procedimento_paciente a
					where	nr_atendimento		= nr_atendimento_p
					and	cd_procedimento		= cd_proc_referencia_w
					and	ie_origem_proced	= ie_origem_proc_refer_w
					and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (a.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
					and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (a.nr_seq_exame = nr_seq_exame_regra_w))
					and	dt_procedimento between
						(clock_timestamp() - (qt_horas_intervalo_w * 60 /1440)) and clock_timestamp()
					and	coalesce(cd_motivo_exc_conta::text, '') = '';

					if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_periodo_w)  >= pr_permitida_w) then
						ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281643);
					end if;
					exception
						when others then
				     			qt_procedimento_w := qt_procedimento_w;
					end;
				end if;

				if (ie_tipo_qtde_w = 'I') then

					if	((obter_dados_atendimento(nr_atendimento_p, 'TA') = 1) and (obter_tipo_convenio_atend(nr_atendimento_p) = 3)) then
						begin

						select	coalesce(sum(p.qt_procedimento),0)
						into STRICT	qt_procedimento_w
						from	sus_aih_unif a,
								conta_paciente c,
								procedimento_paciente p
						where	c.nr_interno_conta = a.nr_interno_conta
						and	p.nr_interno_conta = c.nr_interno_conta
						and	coalesce(p.cd_motivo_exc_conta::text, '') = ''
						and	(p.nr_interno_conta IS NOT NULL AND p.nr_interno_conta::text <> '')
						and	c.nr_atendimento = nr_atendimento_p
						and	p.cd_procedimento = cd_procedimento_w
						and	p.ie_origem_proced = ie_origem_proced_w
						and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (p.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
						and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (p.nr_seq_exame = nr_seq_exame_regra_w))
						and	c.ie_status_acerto = 1;

						if (qt_procedimento_w = 0) then
							select	coalesce(sum(p.qt_procedimento),0)
							into STRICT	qt_procedimento_w
							from	conta_paciente c,
									procedimento_paciente p
							where	p.nr_interno_conta = c.nr_interno_conta
							and	coalesce(p.cd_motivo_exc_conta::text, '') = ''
							and	c.nr_atendimento = nr_atendimento_p
							and	p.cd_procedimento = cd_procedimento_w
							and	p.ie_origem_proced = ie_origem_proced_w
							and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (p.nr_seq_proc_interno = nr_seq_proc_int_regra_w))
							and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (p.nr_seq_exame = nr_seq_exame_regra_w))
							and	c.ie_status_acerto = 1;
						end if;

						select 	coalesce(sum(qt_procedimento),0)
						into STRICT	qt_executada_atend_w
						from	procedimento_paciente
						where	nr_atendimento = nr_atendimento_p
						and	cd_procedimento = cd_proc_referencia_w
						and	ie_origem_proced = ie_origem_proc_refer_w
						and	((coalesce(nr_seq_proc_int_regra_w::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_int_regra_w))
						and	((coalesce(nr_seq_exame_regra_w::text, '') = '') or (nr_seq_exame = nr_seq_exame_regra_w))
						and	coalesce(cd_motivo_exc_conta::text, '') = ''
						and	obter_status_conta(nr_interno_conta,'C') = 1;

						if	(dividir(((qt_procedimento_w + qt_executada_w) * 100), qt_executada_atend_w)  >= pr_permitida_w) then
							ds_erro_w 	:= WHEB_MENSAGEM_PCK.get_texto(281632) ||to_char(cd_procedimento_w)||
							WHEB_MENSAGEM_PCK.get_texto(281644);
						end if;
						exception
							when others then
				     				qt_procedimento_w := qt_procedimento_w;
						end;
					end if;

				end if;

				end;
			end if;

			end;
		end loop;
		close c02;

		if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') and (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			ds_erro_w := ds_mensagem_w;
		end if;

		if (ds_erro_w <> '') or (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			ds_erro_p		:= substr(ds_erro_p || chr(13) || chr(10)|| ds_erro_w,1,255);
		end if;
	end loop;
	close c01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_qtde_proc_prescr (nr_prescricao_p bigint, nr_atendimento_p bigint, ds_erro_p INOUT text, cd_procedimento_p bigint default null) FROM PUBLIC;

