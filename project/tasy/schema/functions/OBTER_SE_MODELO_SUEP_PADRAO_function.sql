-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_modelo_suep_padrao ( nr_seq_modelo_suep_p bigint, ie_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_padrao_w				varchar(1) := 'N';
cd_pessoa_usuario_w		varchar(100) := '';
nm_usuario_w			varchar(15) := '';


BEGIN

if (nr_seq_modelo_suep_p IS NOT NULL AND nr_seq_modelo_suep_p::text <> '') then

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	if (ie_usuario_p = 'S') then

		select	coalesce(max('S'),'N')
		into STRICT	ie_padrao_w
		from	suep_padrao_usuario
		where	nr_seq_modelo_suep = nr_seq_modelo_suep_p
		and		nm_usuario_suep = nm_usuario_w;

	else

		Select	obter_pf_usuario(nm_usuario_w,'C')
		into STRICT	cd_pessoa_usuario_w
		;

		select	coalesce(max('S'),'N')
		into STRICT	ie_padrao_w
		from	regra_liberacao_suep a,
				suep b
		where	a.nr_seq_suep = b.nr_sequencia
		and		b.nr_sequencia = nr_seq_modelo_suep_p
		and		((a.cd_perfil = wheb_usuario_pck.get_cd_perfil) or (coalesce(cd_perfil::text, '') = ''))
		and     ((a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento) or (coalesce(a.cd_estabelecimento::text, '') = ''))
		and     ((a.cd_setor_atendimento = wheb_usuario_pck.get_cd_setor_atendimento) or (coalesce(a.cd_setor_atendimento::text, '') = ''))
		and		((obter_se_especialidade_medico(cd_pessoa_usuario_w, a.cd_especialidade) = 'S') or (coalesce(a.cd_especialidade::text, '') = ''))
		and 	coalesce(b.ie_situacao,'A') = 'A'
		and     (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
		and		coalesce(a.ie_padrao,'N') = 'S'
		and		coalesce(b.ie_sumario_exclusivo,'N') = 'N';

	end if;

end if;


return	ie_padrao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_modelo_suep_padrao ( nr_seq_modelo_suep_p bigint, ie_usuario_p text) FROM PUBLIC;
