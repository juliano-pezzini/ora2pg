-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_texto_padrao_evolucao ( cd_tipo_evolucao_p text, cd_profissional_p text, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

/*
C - Código
*/
nr_seq_texto_w		bigint;
cd_especialidade_w	bigint := 0;
ie_tipo_atendimento_w	bigint	:= 0;
ie_clinica_w		bigint	:= 0;
cd_setor_atendimento_w	bigint	:= 0;
nm_usuario_w		varchar(50);
cd_perfil_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_seq_texto
	from	tipo_evolucao_texto a, texto_padrao b
	where	a.cd_tipo_evolucao	= cd_tipo_evolucao_p
	and	coalesce(a.cd_especialidade,cd_especialidade_w)	= cd_especialidade_w
	and	coalesce(a.ie_tipo_atendimento,ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
	and	coalesce(a.ie_clinica,ie_clinica_w)			= ie_clinica_w
	and	coalesce(a.cd_setor_atendimento,cd_setor_atendimento_w)= cd_setor_atendimento_w
	and	coalesce(a.nm_usuario_config,nm_usuario_w)		= nm_usuario_w
	and	coalesce(a.cd_perfil,cd_perfil_w)			= cd_perfil_w
                and a.nr_seq_texto = b.nr_sequencia
                and coalesce(b.ie_situacao, 'A') = 'A'
	order by coalesce(a.nm_usuario_config,'AAAAAAA'),
		coalesce(a.cd_perfil,0),
		coalesce(a.ie_tipo_atendimento, 0),
		 coalesce(a.cd_setor_atendimento, 0),
		 coalesce(a.ie_clinica,0);

BEGIN
cd_especialidade_w	:= coalesce(obter_especialidade_medico(cd_profissional_p,'C'),0);
nm_usuario_w		:= coalesce(wheb_usuario_pck.get_nm_usuario,'AAAAAA');
cd_perfil_w		:= coalesce(obter_perfil_ativo,0);

if (coalesce(nr_atendimento_p,0)	> 0) then
	select	ie_tipo_atendimento,
		coalesce(ie_clinica,0),
		cd_setor_atendimento
	into STRICT	ie_tipo_atendimento_w,
		ie_clinica_w,
		cd_setor_atendimento_w
	from	resumo_atendimento_paciente_v
	where	nr_atendimento	= nr_atendimento_p;
end if;

open C01;
loop
fetch C01 into
	nr_seq_texto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (coalesce(nr_seq_texto_w::text, '') = '') then
	select	max(a.nr_seq_texto)
	into STRICT	nr_seq_texto_w
	from	tipo_evolucao a, texto_padrao b
	where	a.cd_tipo_evolucao	= cd_tipo_evolucao_p
                and a.nr_seq_texto = b.nr_sequencia
                and coalesce(b.ie_situacao, 'A') = 'A';
end if;

return nr_seq_texto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_texto_padrao_evolucao ( cd_tipo_evolucao_p text, cd_profissional_p text, nr_atendimento_p bigint) FROM PUBLIC;
