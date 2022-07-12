-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_nova_prescr_gpt (nr_atendimento_p bigint, ie_tipo_usuario_p text, ie_lib_farm_p text default null, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type DEFAULT NULL, qt_horas_quimio_p bigint default 0) RETURNS varchar AS $body$
DECLARE

				

c01 REFCURSOR;

dt_prescr_min_default_c	constant timestamp := trunc(clock_timestamp(),'dd') - 2;

ie_retorno_w			varchar(1) := 'N';
nr_seq_analise_w		gpt_hist_analise_plano.nr_sequencia%type;
dt_inicio_analise_w 	gpt_hist_analise_plano.dt_inicio_analise%type;
dt_fim_analise_w		gpt_hist_analise_plano.dt_fim_analise%type;
dt_prescricao_min_w		timestamp;

nr_prescricao_w			prescr_medica.nr_prescricao%type;
dt_liberacao_w			prescr_medica.dt_liberacao%type;
ie_lib_farm_w			prescr_medica.ie_lib_farm%type;
dt_liberacao_farmacia_w	prescr_medica.dt_liberacao_farmacia%type;
nr_seq_atend_w			prescr_medica.nr_seq_atend%type;
cd_funcao_origem_w		prescr_medica.cd_funcao_origem%type;
dt_prescricao_w			prescr_medica.dt_prescricao%type;
dt_liberacao_medico_w	prescr_medica.dt_liberacao_medico%type;

dt_geracao_prescricao_w	paciente_atendimento.dt_geracao_prescricao%type;

ie_param_62_w			varchar(1);


	function obter_se_prescr_lib_hor(nr_prescricao_p prescr_medica.nr_prescricao%type) return text is
		ie_considera_prescr_w varchar(1);
	
BEGIN
		if (coalesce(ie_param_62_w::text, '') = '') then
			-- Apresentar como pendente de analise apenas os itens que dependem da geracao do lote pela enfermagem/farmacia
			ie_param_62_w := obter_param_usuario(252, 62, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_62_w);
		end if;
		
		ie_considera_prescr_w := 'S';
		
		if (ie_param_62_w = 'S') and (obter_se_prescr_lib_hor_gpt(nr_prescricao_p) = 'S') then
			ie_considera_prescr_w := 'N';
		end if;
		
		return ie_considera_prescr_w;
	end;

begin

if (coalesce(nr_atendimento_p,0) > 0) then
	select
		max(nr_sequencia)
	into STRICT	nr_seq_analise_w
	from	gpt_hist_analise_plano a
	where	nr_atendimento = nr_atendimento_p
	and		ie_tipo_usuario = ie_tipo_usuario_p;
else
	select
		max(nr_sequencia)
	into STRICT	nr_seq_analise_w
	from	gpt_hist_analise_plano a
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and 	coalesce(nr_atendimento::text, '') = ''
	and		ie_tipo_usuario = ie_tipo_usuario_p;		
end if;

if (coalesce(nr_seq_analise_w, 0) > 0) then
	select 	max(dt_inicio_analise),
			max(dt_fim_analise)
	into STRICT	dt_inicio_analise_w,
			dt_fim_analise_w
	from 	gpt_hist_analise_plano
	where	nr_sequencia = nr_seq_analise_w;
end if;

dt_prescricao_min_w := coalesce(dt_fim_analise_w, dt_inicio_analise_w, dt_prescr_min_default_c);

if (coalesce(nr_atendimento_p,0) > 0) then
	open c01 for
	SELECT
		a.nr_prescricao,
		a.dt_liberacao,
		a.ie_lib_farm,
		a.dt_liberacao_farmacia,
		a.nr_seq_atend,
		a.cd_funcao_origem,
		a.dt_prescricao,
		a.dt_liberacao_medico
	from	prescr_medica a
	where	a.nr_atendimento = nr_atendimento_p
	and		coalesce(a.dt_suspensao::text, '') = ''
	and (a.dt_prescricao >= least(dt_prescricao_min_w, dt_prescr_min_default_c) or (ie_tipo_usuario_p = 'E' and
				coalesce(a.dt_liberacao::text, '') = '' and
				a.dt_prescricao between dt_inicio_analise_w and dt_fim_analise_w));
else
	open c01 for
	SELECT
		a.nr_prescricao,
		a.dt_liberacao,
		a.ie_lib_farm,
		a.dt_liberacao_farmacia,
		a.nr_seq_atend,
		a.cd_funcao_origem,
		a.dt_prescricao,
		a.dt_liberacao_medico
	from	prescr_medica a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and		coalesce(a.dt_suspensao::text, '') = ''
	and (a.dt_prescricao >= least(dt_prescricao_min_w, dt_prescr_min_default_c) or (ie_tipo_usuario_p = 'E' and
				coalesce(a.dt_liberacao::text, '') = '' and
				a.dt_prescricao between dt_inicio_analise_w and dt_fim_analise_w));
end if;

<<prescr_loop>>
loop
	fetch C01 into
		nr_prescricao_w,
		dt_liberacao_w,
		ie_lib_farm_w,
		dt_liberacao_farmacia_w,
		nr_seq_atend_w,
		cd_funcao_origem_w,
		dt_prescricao_w,
		dt_liberacao_medico_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	if (((ie_tipo_usuario_p = 'F') and (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') and
		((ie_lib_farm_p = 'N') or (coalesce(ie_lib_farm_w,'N') = 'S')) and (coalesce(dt_liberacao_farmacia_w::text, '') = '')) or
		((ie_tipo_usuario_p = 'E') and (coalesce(dt_liberacao_w::text, '') = ''))) then

		if ((dt_prescricao_w >= dt_prescricao_min_w) or
			((ie_tipo_usuario_p = 'E') and (coalesce(dt_liberacao_w::text, '') = '') and 
				((dt_liberacao_medico_w >= dt_fim_analise_w) or (dt_liberacao_medico_w between dt_inicio_analise_w and dt_fim_analise_w))) or
			((ie_tipo_usuario_p = 'F') and (coalesce(dt_liberacao_farmacia_w::text, '') = '') and 
				((dt_liberacao_w >= dt_fim_analise_w) or (dt_liberacao_w between dt_inicio_analise_w and dt_fim_analise_w)))) and (obter_se_prescr_lib_hor(nr_prescricao_w) = 'S') then

			ie_retorno_w := 'S';
			exit prescr_loop;

		elsif ((nr_seq_atend_w IS NOT NULL AND nr_seq_atend_w::text <> '')
				and 	cd_funcao_origem_w in (281,3130)
				and		dt_prescricao_w between dt_prescr_min_default_c and clock_timestamp() + (coalesce(qt_horas_quimio_p,0) / 24)) then

			select	max(b.dt_geracao_prescricao)
			into STRICT	dt_geracao_prescricao_w
			from	paciente_atendimento b
			where	b.nr_seq_atendimento = nr_seq_atend_w
			and 	b.nr_prescricao = nr_prescricao_w
			and 	(b.dt_geracao_prescricao IS NOT NULL AND b.dt_geracao_prescricao::text <> '');
			
			if (dt_geracao_prescricao_w >= dt_prescricao_min_w) then
				ie_retorno_w := 'S';	
				exit prescr_loop;
			end if;
		end if;
	end if;
end loop prescr_loop;
close c01;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_nova_prescr_gpt (nr_atendimento_p bigint, ie_tipo_usuario_p text, ie_lib_farm_p text default null, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type DEFAULT NULL, qt_horas_quimio_p bigint default 0) FROM PUBLIC;
