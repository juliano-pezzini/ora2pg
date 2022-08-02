-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_regra_prestador (cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, ie_responsavel_credito_p text, ie_clinica_p bigint, cd_cgc_prestador_p text, cd_setor_atendimento_p bigint, cd_medico_executor_p text, cd_medico_atend_p text, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tiss_tipo_guia_p text, ie_honorario_p text, cd_cgc_prestador_tiss_p INOUT text, cd_prestador_tiss_p INOUT text, ds_prestador_tiss_p INOUT text, cd_medico_exec_tiss_p INOUT text, cd_cgc_prestador_solic_p INOUT text, nr_seq_regra_p INOUT bigint, ie_tipo_regra_p text, ie_solicitante_p INOUT text, cd_cgc_solic_prescr_p text, ie_medico_exec_p INOUT text, cd_prestador_solic_p INOUT text, ds_prestador_solic_p INOUT text, dt_procedimento_p timestamp, ie_fatur_medico_p text, cd_medico_referido_p text, cd_tipo_acomodacao_p bigint, cd_procedencia_p bigint, cd_plano_p text, nr_seq_classificacao_p bigint, ie_elegibilidade_p text, ie_solic_autor_p text, ie_tipo_atend_conta_p bigint, ie_tipo_protocolo_p bigint) AS $body$
DECLARE


/*
ie_tipo_prestador_p
"S" - Prestador solicitante
"E" - Prestador executante
*/
cd_cgc_prestador_tiss_w		varchar(255) := null;
cd_cgc_estab_w			varchar(255);
cd_prestador_tiss_w		varchar(255);
cd_cgc_prest_solic_w		varchar(255);
cd_medico_exec_tiss_w		varchar(255);
ds_prestador_tiss_w		varchar(255);
ie_solicitante_w			varchar(255);
cd_area_procedimento_w		bigint;
cd_especialidade_w		bigint;
cd_grupo_proc_w			bigint;
nr_seq_regra_w			bigint;
ie_medico_exec_w		varchar(2);
cd_prestador_solic_w		varchar(255);
ds_prestador_solic_w		varchar(255);
ie_vinculo_medico_w		smallint;
qt_regra_w			bigint;
nr_seq_agrup_classif_w		bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_cgc_prestador_tiss,
	cd_interno,
	CASE WHEN ie_tiss_tipo_guia_p='5' THEN  null  ELSE CASE WHEN ie_solicitante='S' THEN  cd_cgc_prestador_tiss  ELSE null END  END ,
	cd_medico_exec_tiss,
	ds_prestador_tiss,
	coalesce(ie_prestador,'N'),
	coalesce(ie_med_exec,'N'),
	CASE WHEN ie_tiss_tipo_guia_p='5' THEN  null  ELSE CASE WHEN ie_solicitante='S' THEN  cd_interno  ELSE null END  END ,
	CASE WHEN ie_tiss_tipo_guia_p='5' THEN  null  ELSE CASE WHEN ie_solicitante='S' THEN  ds_prestador_tiss  ELSE null END  END
from	tiss_regra_prestador
where	cd_convenio								= cd_convenio_p
and	cd_estabelecimento							= cd_estabelecimento_p
and	coalesce(ie_tipo_atendimento, 	ie_tipo_atendimento_p)			= ie_tipo_atendimento_p
and	coalesce(cd_procedimento,		coalesce(cd_procedimento_p, 0))		= coalesce(cd_procedimento_p, 0)
and (coalesce(ie_origem_proced,		coalesce(ie_origem_proced_p,0))		= coalesce(ie_origem_proced_p,0) or coalesce(cd_procedimento::text, '') = '') --Se não possui procedimento na regra, não precisa considerar a origem
and	coalesce(ie_clinica,			coalesce(ie_clinica_p, 0))			= coalesce(ie_clinica_p,0)
and	coalesce(cd_setor_atendimento,	coalesce(cd_setor_atendimento_p,0))		= coalesce(cd_setor_atendimento_p,0)
and	coalesce(cd_area_procedimento, 	coalesce(cd_area_procedimento_w,0))		= coalesce(cd_area_procedimento_w,0)
and	coalesce(cd_especialidade,		coalesce(cd_especialidade_w,0))		= coalesce(cd_especialidade_w,0)
and	coalesce(cd_grupo_proc,		coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
and	coalesce(ie_responsavel_credito,	coalesce(ie_responsavel_credito_p,'X'))	= coalesce(ie_responsavel_credito_p, 'X')
and	coalesce(cd_cgc_prestador, 		coalesce(cd_cgc_prestador_p, 'X'))		= coalesce(cd_cgc_prestador_p, 'X')
and	coalesce(cd_cgc_solic_prescr, 	coalesce(cd_cgc_solic_prescr_p, 'X'))	= coalesce(cd_cgc_solic_prescr_p, 'X')
and	coalesce(cd_medico_executor,		coalesce(cd_medico_executor_p, 'X'))		= coalesce(cd_medico_executor_p,'X')
and	coalesce(cd_medico_atend,		coalesce(cd_medico_atend_p, 'X')) 		= coalesce(cd_medico_atend_p, 'X')
and	coalesce(cd_categoria,		coalesce(cd_categoria_p, 'X'))		= coalesce(cd_categoria_p, 'X')
and	coalesce(cd_medico_referido,		coalesce(cd_medico_referido_p, 'X'))		= coalesce(cd_medico_referido_p, 'X')
and	coalesce(cd_tipo_acomodacao,		coalesce(cd_tipo_acomodacao_p,0))		= coalesce(cd_tipo_acomodacao_p,0)
and	coalesce(cd_procedencia,		coalesce(cd_procedencia_p,0))		= coalesce(cd_procedencia_p,0)
and	coalesce(cd_plano,			coalesce(cd_plano_p,'X'))			= coalesce(cd_plano_p,'X')
and	coalesce(nr_seq_classificacao,	coalesce(nr_seq_classificacao_p,0))		= coalesce(nr_seq_classificacao_p,0)
and	coalesce(ie_vinculo_medico,		coalesce(ie_vinculo_medico_w,0))		= coalesce(ie_vinculo_medico_w,0)
and	coalesce(ie_tipo_atend_conta,	coalesce(ie_tipo_atend_conta_p,0))		= coalesce(ie_tipo_atend_conta_p,0)
and	coalesce(ie_tipo_protocolo,		coalesce(ie_tipo_protocolo_p,0))		= coalesce(ie_tipo_protocolo_p,0)
and	coalesce(nr_seq_agrup_classif,	coalesce(nr_seq_agrup_classif_w,0))		= coalesce(nr_seq_agrup_classif_w,0) --OS810426
and	((ie_tiss_tipo_guia_p	<> '5') or (ie_guia_RI	= 'S'))
and	(((ie_honorario_p	not in ('S','P')) or   --lhalves OS269749 em 1/12/2010 - Definir o tipo de guia de Honor (SADT ou HI) que deve se aplicar a regra.
	   (ie_guia_honorario 	= 'S')) or
	  (((ie_honorario_p 	in ('S','P')) and (ie_tiss_tipo_guia_p = '4')) and (ie_guia_honorario 	= 'SADT')) or
	  (((ie_honorario_p 	in ('S','P')) and (ie_tiss_tipo_guia_p = '6')) and (ie_guia_honorario 	= 'HI'))
	)
and	((coalesce(ie_tipo_regra, 'T') 	= 'T') or (ie_tipo_regra = ie_tipo_regra_p))
and 	(cd_convenio IS NOT NULL AND cd_convenio::text <> '')
and (coalesce(ie_escala,'N') = 'N' or (coalesce(ie_escala,'N') = 'S' and coalesce(tiss_obter_se_PF_escala(cd_medico_executor_p,dt_procedimento_p),'N') = 'S'))
and	(((coalesce(ie_fatur_medico,'N') = 'S') and (ie_fatur_medico_p = 'S')) or (ie_fatur_medico_p = 'N'))
and	(((coalesce(ie_elegibilidade,'N') = 'S') and (ie_elegibilidade_p = 'S')) or (ie_elegibilidade_p = 'N'))
and	(((coalesce(ie_solic_autor,'N') = 'S') and (ie_solic_autor_p = 'S')) or (ie_solic_autor_p = 'N'))
and	coalesce(dt_procedimento_p,clock_timestamp())	between coalesce(dt_inicio_vigencia,pkg_date_utils.get_dateTime(1900, 1, 1)) and pkg_date_utils.get_time(coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days'),0,0,0) + 89399/89400
and 	(((coalesce(hr_final::text, '') = '') or (coalesce(hr_inicial::text, '') = '')) or   --OS 813070
	 (coalesce(dt_procedimento_p,clock_timestamp()) between
		pkg_date_utils.Get_DateTime(coalesce(dt_procedimento_p,clock_timestamp()) , coalesce(hr_inicial, pkg_date_utils.get_Time(00,00,01))) and
		pkg_date_utils.Get_DateTime(coalesce(dt_procedimento_p,clock_timestamp()),  coalesce(hr_final, pkg_date_utils.get_Time(23,59,59))))
	)
order by	coalesce(ie_prioridade,0),
	coalesce(cd_procedimento, 0),
	cd_cgc_prestador,
	CASE WHEN coalesce(ie_responsavel_credito, '0')='0' THEN  0  ELSE 1 END ,
	coalesce(cd_grupo_proc, 0),
	coalesce(cd_especialidade, 0),
	coalesce(cd_area_procedimento, 0),
	coalesce(cd_medico_executor,0),
	coalesce(cd_setor_atendimento,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(ie_clinica,0),
	coalesce(cd_cgc_prestador,0),
	coalesce(cd_medico_atend,0),
	coalesce(cd_categoria,0),
	coalesce(dt_inicio_vigencia,pkg_date_utils.get_dateTime(1900, 1, 1)),
	coalesce(cd_medico_referido,'X'),
	coalesce(cd_tipo_acomodacao,0),
	coalesce(cd_procedencia,0),
	coalesce(cd_plano_p,'X'),
	coalesce(nr_seq_classificacao,0),
	coalesce(ie_vinculo_medico,0),
	coalesce(ie_tipo_atend_conta,0),
	coalesce(ie_tipo_protocolo,0),
	coalesce(nr_seq_agrup_classif,0);

c02 CURSOR FOR
SELECT	nr_sequencia,
	cd_cgc_prestador_tiss,
	cd_interno,
	CASE WHEN ie_tiss_tipo_guia_p='5' THEN  null  ELSE CASE WHEN ie_solicitante='S' THEN  cd_cgc_prestador_tiss  ELSE null END  END ,
	cd_medico_exec_tiss,
	ds_prestador_tiss,
	coalesce(ie_prestador,'N'),
	coalesce(ie_med_exec,'N'),
	CASE WHEN ie_tiss_tipo_guia_p='5' THEN  null  ELSE CASE WHEN ie_solicitante='S' THEN  cd_interno  ELSE null END  END ,
	CASE WHEN ie_tiss_tipo_guia_p='5' THEN  null  ELSE CASE WHEN ie_solicitante='S' THEN  ds_prestador_tiss  ELSE null END  END
from	tiss_regra_prestador
where	cd_estabelecimento							= cd_estabelecimento_p
and	coalesce(ie_tipo_atendimento, 	ie_tipo_atendimento_p)			= ie_tipo_atendimento_p
and	coalesce(cd_procedimento,		coalesce(cd_procedimento_p, 0))		= coalesce(cd_procedimento_p, 0)
and (coalesce(ie_origem_proced,		coalesce(ie_origem_proced_p,0))		= coalesce(ie_origem_proced_p,0) or coalesce(cd_procedimento::text, '') = '') --Se não possui procedimento na regra, não precisa considerar a origem
and	coalesce(ie_clinica,			coalesce(ie_clinica_p, 0))			= coalesce(ie_clinica_p,0)
and	coalesce(cd_setor_atendimento,	coalesce(cd_setor_atendimento_p,0))		= coalesce(cd_setor_atendimento_p,0)
and	coalesce(cd_area_procedimento, 	coalesce(cd_area_procedimento_w,0))		= coalesce(cd_area_procedimento_w,0)
and	coalesce(cd_especialidade,		coalesce(cd_especialidade_w,0))		= coalesce(cd_especialidade_w,0)
and	coalesce(cd_grupo_proc,		coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
and	coalesce(ie_responsavel_credito,	coalesce(ie_responsavel_credito_p,'X'))	= coalesce(ie_responsavel_credito_p, 'X')
and	coalesce(cd_cgc_prestador, 		coalesce(cd_cgc_prestador_p, 'X'))		= coalesce(cd_cgc_prestador_p, 'X')
and	coalesce(cd_cgc_solic_prescr, 	coalesce(cd_cgc_solic_prescr_p, 'X'))	= coalesce(cd_cgc_solic_prescr_p, 'X')
and	coalesce(cd_medico_executor,		coalesce(cd_medico_executor_p, 'X'))		= coalesce(cd_medico_executor_p,'X')
and	coalesce(cd_medico_atend,		coalesce(cd_medico_atend_p, 'X')) 		= coalesce(cd_medico_atend_p, 'X')
and	coalesce(cd_categoria,		coalesce(cd_categoria_p, 'X'))		= coalesce(cd_categoria_p, 'X')
and	coalesce(cd_medico_referido,		coalesce(cd_medico_referido_p, 'X'))		= coalesce(cd_medico_referido_p, 'X')
and	coalesce(cd_tipo_acomodacao,		coalesce(cd_tipo_acomodacao_p,0))		= coalesce(cd_tipo_acomodacao_p,0)
and	coalesce(cd_procedencia,		coalesce(cd_procedencia_p,0))		= coalesce(cd_procedencia_p,0)
and	coalesce(cd_plano,			coalesce(cd_plano_p,0))			= coalesce(cd_plano_p,0)
and	coalesce(nr_seq_classificacao,	coalesce(nr_seq_classificacao_p,0))		= coalesce(nr_seq_classificacao_p,0)
and	coalesce(ie_vinculo_medico,		coalesce(ie_vinculo_medico_w,0))		= coalesce(ie_vinculo_medico_w,0)
and	coalesce(ie_tipo_atend_conta,	coalesce(ie_tipo_atend_conta_p,0))		= coalesce(ie_tipo_atend_conta_p,0)
and	coalesce(ie_tipo_protocolo,		coalesce(ie_tipo_protocolo_p,0))		= coalesce(ie_tipo_protocolo_p,0)
and	coalesce(nr_seq_agrup_classif,	coalesce(nr_seq_agrup_classif_w,0))		= coalesce(nr_seq_agrup_classif_w,0) --OS810426
and	((ie_tiss_tipo_guia_p	<> '5') or (ie_guia_RI	= 'S'))
and	(((ie_honorario_p	not in ('S','P')) or   --lhalves OS269749 em 1/12/2010 - Definir o tipo de guia de Honor (SADT ou HI) que deve se aplicar a regra.
	   (ie_guia_honorario 	= 'S')) or
	  (((ie_honorario_p 	in ('S','P')) and (ie_tiss_tipo_guia_p = '4')) and (ie_guia_honorario 	= 'SADT')) or
	  (((ie_honorario_p 	in ('S','P')) and (ie_tiss_tipo_guia_p = '6')) and (ie_guia_honorario 	= 'HI'))
	)
and	((coalesce(ie_tipo_regra, 'T') 	= 'T') or (ie_tipo_regra = ie_tipo_regra_p))
and 	coalesce(cd_convenio::text, '') = ''
and (coalesce(ie_escala,'N') = 'N' or (coalesce(ie_escala,'N') = 'S' and coalesce(tiss_obter_se_PF_escala(cd_medico_executor_p,dt_procedimento_p),'N') = 'S'))
and	(((coalesce(ie_fatur_medico,'N') = 'S') and (ie_fatur_medico_p = 'S')) or (ie_fatur_medico_p = 'N'))
and	(((coalesce(ie_elegibilidade,'N') = 'S') and (ie_elegibilidade_p = 'S')) or (ie_elegibilidade_p = 'N'))
and	(((coalesce(ie_solic_autor,'N') = 'S') and (ie_solic_autor_p = 'S')) or (ie_solic_autor_p = 'N'))
and	coalesce(dt_procedimento_p,clock_timestamp())	between coalesce(dt_inicio_vigencia,pkg_date_utils.get_dateTime(1900, 1, 1)) and pkg_date_utils.get_time(coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days'),0,0,0) + 89399/89400
and 	(((coalesce(hr_final::text, '') = '') or (coalesce(hr_inicial::text, '') = '')) or  --OS 813070
	 (coalesce(dt_procedimento_p,clock_timestamp()) between
		pkg_date_utils.Get_DateTime(coalesce(dt_procedimento_p,clock_timestamp()), coalesce(hr_inicial, pkg_date_utils.get_Time(00,00,01))) and
		pkg_date_utils.Get_DateTime(coalesce(dt_procedimento_p,clock_timestamp()), coalesce(hr_final, pkg_date_utils.get_Time(23,59,59))))
	)
order by	coalesce(cd_procedimento, 0),
	cd_cgc_prestador,
	CASE WHEN coalesce(ie_responsavel_credito, '0')='0' THEN  0  ELSE 1 END ,
	coalesce(cd_grupo_proc, 0),
	coalesce(cd_especialidade, 0),
	coalesce(cd_area_procedimento, 0),
	coalesce(cd_medico_executor,0),
	coalesce(cd_medico_atend,0),
	coalesce(cd_setor_atendimento,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(ie_clinica,0),
	coalesce(cd_cgc_prestador,0),
	coalesce(cd_categoria,0),
	coalesce(dt_inicio_vigencia,pkg_date_utils.get_dateTime(1900, 1, 1)),
	coalesce(cd_medico_referido,'X'),
	coalesce(cd_tipo_acomodacao,0),
	coalesce(cd_procedencia,0),
	coalesce(cd_plano,0),
	coalesce(nr_seq_classificacao,0),
	coalesce(ie_vinculo_medico,0),
	coalesce(ie_tipo_atend_conta,0),
	coalesce(ie_tipo_protocolo,0),
	coalesce(nr_seq_agrup_classif,0);


BEGIN

begin
select	1
into STRICT	qt_regra_w
from	tiss_regra_prestador
where	cd_estabelecimento	= cd_estabelecimento_p  LIMIT 1;
exception
when others then
	qt_regra_w	:= 0;
end;

if (qt_regra_w > 0) then

	select	max(cd_area_procedimento),
		max(cd_especialidade),
		max(cd_grupo_proc)
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	if (cd_medico_executor_p IS NOT NULL AND cd_medico_executor_p::text <> '') then

		select	max(ie_vinculo_medico)
		into STRICT	ie_vinculo_medico_w
		from	medico
		where	cd_pessoa_fisica	= cd_medico_executor_p;

	end if;

	if (coalesce(cd_setor_atendimento_p,0) > 0) then
		select	max(nr_seq_agrup_classif)
		into STRICT	nr_seq_agrup_classif_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	end if;

	open c01;
	loop
	fetch c01 into
		nr_seq_regra_w,
		cd_cgc_prestador_tiss_w,
		cd_prestador_tiss_w,
		cd_cgc_prest_solic_w,
		cd_medico_exec_tiss_w,
		ds_prestador_tiss_w,
		ie_solicitante_w,
		ie_medico_exec_w,
		cd_prestador_solic_w,
		ds_prestador_solic_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		cd_cgc_prestador_tiss_w	:= cd_cgc_prestador_tiss_w;
		cd_prestador_tiss_w	:= cd_prestador_tiss_w;

	end loop;
	close c01;

	/*lhalves OS 220656 em 22/06/2010 - Se não encontrou a regra prestador para o convênio, utiliza a regra pelo estabelecimento do SHIFT+F11*/

	if (coalesce(nr_seq_regra_w::text, '') = '') then
		open c02;
		loop
		fetch c02 into
			nr_seq_regra_w,
			cd_cgc_prestador_tiss_w,
			cd_prestador_tiss_w,
			cd_cgc_prest_solic_w,
			cd_medico_exec_tiss_w,
			ds_prestador_tiss_w,
			ie_solicitante_w,
			ie_medico_exec_w,
			cd_prestador_solic_w,
			ds_prestador_solic_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			cd_cgc_prestador_tiss_w	:= cd_cgc_prestador_tiss_w;
			cd_prestador_tiss_w	:= cd_prestador_tiss_w;

		end loop;
		close c02;
	end if;

	select	max(cd_cgc)
	into STRICT	cd_cgc_estab_w
	from	estabelecimento
	where	cd_estabelecimento	= cd_estabelecimento_p;
end if;

cd_cgc_prestador_tiss_p		:= cd_cgc_prestador_tiss_w;
cd_prestador_tiss_p		:= cd_prestador_tiss_w;
ds_prestador_tiss_p		:= ds_prestador_tiss_w;
cd_medico_exec_tiss_p		:= cd_medico_exec_tiss_w;
cd_cgc_prestador_solic_p	:= cd_cgc_prest_solic_w;
nr_seq_regra_p			:= nr_seq_regra_w;
ie_medico_exec_p		:= ie_medico_exec_w;
cd_prestador_solic_p		:= cd_prestador_solic_w;
ds_prestador_solic_p		:= ds_prestador_solic_w;


/*dsantos em 15/09/2009. OS158199. Opção criada para trazer o campo CNPJ solic da prescrição da EUP nos campos 13 e 14 da guia SADT*/

ie_solicitante_p			:= ie_solicitante_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_regra_prestador (cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, ie_responsavel_credito_p text, ie_clinica_p bigint, cd_cgc_prestador_p text, cd_setor_atendimento_p bigint, cd_medico_executor_p text, cd_medico_atend_p text, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tiss_tipo_guia_p text, ie_honorario_p text, cd_cgc_prestador_tiss_p INOUT text, cd_prestador_tiss_p INOUT text, ds_prestador_tiss_p INOUT text, cd_medico_exec_tiss_p INOUT text, cd_cgc_prestador_solic_p INOUT text, nr_seq_regra_p INOUT bigint, ie_tipo_regra_p text, ie_solicitante_p INOUT text, cd_cgc_solic_prescr_p text, ie_medico_exec_p INOUT text, cd_prestador_solic_p INOUT text, ds_prestador_solic_p INOUT text, dt_procedimento_p timestamp, ie_fatur_medico_p text, cd_medico_referido_p text, cd_tipo_acomodacao_p bigint, cd_procedencia_p bigint, cd_plano_p text, nr_seq_classificacao_p bigint, ie_elegibilidade_p text, ie_solic_autor_p text, ie_tipo_atend_conta_p bigint, ie_tipo_protocolo_p bigint) FROM PUBLIC;

