-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_grupo_item_ageint (dt_agendamento_p timestamp, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, qt_idade_p bigint, ie_tipo_atendimento_p bigint, ie_sexo_p text, nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, cd_pessoa_fisica_p text, dt_nascimento_p timestamp, nm_usuario_p text, nr_seq_cobertura_p bigint, dt_inicio_agendamento_p timestamp, cd_usuario_convenio_p text, cd_medico_P text default null, cd_especialidade_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_tipo_agendamento_w	agenda_int_grupo.ie_tipo_agendamento%type;
vl_total_w				varchar(30);
vl_item_w				double precision := 0;
vl_item_assoc_w			double precision := 0;
ie_tipo_convenio_w		convenio.ie_tipo_convenio%type;
nr_seq_proc_interno_w	proc_int_proc_prescr.nr_seq_proc_int_adic%type;
ie_calcula_item_associado_w	varchar(1) := 'N';

--Vetor usado na ageint_gerar_proc_Assoc;
c01 CURSOR FOR
	SELECT	coalesce(nr_seq_proc_int_adic,0)
	from	proc_int_proc_prescr
	where	nr_seq_proc_interno	= nr_seq_proc_interno_p
	and 	coalesce(cd_convenio,cd_convenio_p) = cd_convenio_p
	and (coalesce(cd_convenio_excluir::text, '') = '' or cd_convenio_excluir <> cd_convenio_p)
	and		Obter_conv_excluir_proc_assoc(nr_sequencia, cd_convenio_p)	= 'S'
	and		coalesce(ie_somente_agenda_cir,'N') = 'N'
	and		(((coalesce(qt_idade_p::text, '') = '') or (coalesce(qt_idade_min::text, '') = '' and coalesce(qt_idade_max::text, '') = '')) or
			((qt_idade_p IS NOT NULL AND qt_idade_p::text <> '') and (qt_idade_p between coalesce(qt_idade_min,qt_idade_p) and
			coalesce(qt_idade_max,qt_idade_p))))
	and 	Obter_se_proc_interno_ativo(nr_seq_proc_int_adic) = 'A';


BEGIN
select 	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio = cd_convenio_p;

if (ie_tipo_convenio_w = 1) then
	vl_item_w := ageint_obter_valor_item(
										cd_convenio_p,
										cd_categoria_p,
										cd_plano_p,
										nr_seq_proc_interno_p,
										cd_estabelecimento_p,
										qt_idade_p,
										ie_tipo_atendimento_p,
										ie_sexo_p,
										nr_seq_ageint_p,
										NULL,
										NULL,
										dt_nascimento_p,
										nm_usuario_p,
										NULL,
										dt_agendamento_p,
										cd_usuario_convenio_p,
										cd_medico_p,
										cd_especialidade_p);

	ie_calcula_item_associado_w := OBTER_CALC_ITEM_ASSOC_AGEINT(nr_seq_proc_interno_p);
	if (ie_calcula_item_associado_w = 'S') then
	--Busca valor de itens associados.
		open c01;
		loop
		fetch c01 into
			nr_seq_proc_interno_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

				vl_item_assoc_w := vl_item_assoc_w + ageint_obter_valor_item(
													cd_convenio_p,
													cd_categoria_p,
													cd_plano_p,
													nr_seq_proc_interno_w,
													cd_estabelecimento_p,
													qt_idade_p,
													ie_tipo_atendimento_p,
													ie_sexo_p,
													nr_seq_ageint_p,
													NULL,
													NULL,
													dt_nascimento_p,
													nm_usuario_p,
													NULL,
													dt_agendamento_p,
													cd_usuario_convenio_p,
													cd_medico_p,
													cd_especialidade_p);

			end;
		end loop;
		close c01;
	end if;
	vl_total_w := TO_CHAR(vl_item_w + vl_item_assoc_w,'999g999g999g999g990d00');
else
	vl_total_w := null;
end if;

return	vl_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_grupo_item_ageint (dt_agendamento_p timestamp, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, qt_idade_p bigint, ie_tipo_atendimento_p bigint, ie_sexo_p text, nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, cd_pessoa_fisica_p text, dt_nascimento_p timestamp, nm_usuario_p text, nr_seq_cobertura_p bigint, dt_inicio_agendamento_p timestamp, cd_usuario_convenio_p text, cd_medico_P text default null, cd_especialidade_p bigint default null) FROM PUBLIC;
