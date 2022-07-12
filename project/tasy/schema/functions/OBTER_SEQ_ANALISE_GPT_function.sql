-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_analise_gpt (nr_atendimento_p atendimento_paciente.nr_atendimento%type, ie_tipo_usuario_p text, ie_lib_farm_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, qt_horas_quimio_p bigint default 0) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w			gpt_hist_analise_plano.nr_sequencia%type;
ie_tipo_usuario_w		varchar(1);
ie_fim_analise_w		varchar(1) := null;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;

function obter_seq_analise(ie_tipo_usuario_p text, ie_fim_analise_p text := null) return bigint is
	nr_seq_w gpt_hist_analise_plano.nr_sequencia%type;

BEGIN

	select	/*+ INDEX(a GPTHISA_I2) */			max(nr_sequencia)
	into STRICT	nr_seq_w
	from	gpt_hist_analise_plano a
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and		ie_tipo_usuario = ie_tipo_usuario_p
	and (coalesce(nr_atendimento_p, 0) = 0 or nr_atendimento = nr_atendimento_p)
	and (coalesce(ie_fim_analise_p::text, '') = '' or (ie_fim_analise_p = 'S' and (dt_fim_analise IS NOT NULL AND dt_fim_analise::text <> '')) or (ie_fim_analise_p = 'N' and coalesce(dt_fim_analise::text, '') = ''));

	if (coalesce(nr_seq_w, 0) = 0) then

		select	max(nr_sequencia)
		into STRICT	nr_seq_w
		from	gpt_hist_analise_plano a
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and		coalesce(nr_atendimento::text, '') = ''
		and		ie_tipo_usuario = ie_tipo_usuario_p
		and (coalesce(ie_fim_analise_p::text, '') = '' or (ie_fim_analise_p = 'S' and (dt_fim_analise IS NOT NULL AND dt_fim_analise::text <> '')) or (ie_fim_analise_p = 'N' and coalesce(dt_fim_analise::text, '') = ''));

	end if;

	return nr_seq_w;
end;

begin

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	cd_pessoa_fisica_w := cd_pessoa_fisica_p;
elsif (coalesce(nr_atendimento_p,0) > 0) then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
end if;

ie_tipo_usuario_w := coalesce(obter_valor_param_usuario(252, 1, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');

if (obter_se_nova_prescr_gpt(nr_atendimento_p, ie_tipo_usuario_p, ie_lib_farm_p, cd_pessoa_fisica_w, coalesce(qt_horas_quimio_p,0)) = 'S') then
	ie_fim_analise_w := 'N';
end if;

if (ie_tipo_usuario_w = 'E' and ie_tipo_usuario_p = 'F') then
	if ((obter_seq_analise(ie_tipo_usuario_w, ie_fim_analise_w) IS NOT NULL AND (obter_seq_analise(ie_tipo_usuario_w, ie_fim_analise_w))::text <> '')) then
		nr_sequencia_w := obter_seq_analise(ie_tipo_usuario_p, ie_fim_analise_w);
	end if;
else
	nr_sequencia_w := obter_seq_analise(ie_tipo_usuario_p, ie_fim_analise_w);
end if;

return nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_analise_gpt (nr_atendimento_p atendimento_paciente.nr_atendimento%type, ie_tipo_usuario_p text, ie_lib_farm_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, qt_horas_quimio_p bigint default 0) FROM PUBLIC;

