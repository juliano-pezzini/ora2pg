-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_controle_visitas ( nr_atendimento_p bigint, nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, qt_atendimentos_p INOUT bigint, qt_acompanhante_p INOUT bigint, nr_atendimento_cracha_p INOUT text) AS $body$
DECLARE


ie_restaurar_grupo_w	varchar(1);
ie_atend_visita_w		varchar(1);


BEGIN

-- Controle de Visitas - Parâmetro [52] - Permite a restauração automática dos grupos de acesso do paciente ao registrar a saída do mesmo.
ie_restaurar_grupo_w := obter_param_usuario(8014, 52, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_restaurar_grupo_w);

if (ie_restaurar_grupo_w = 'S') then
	begin
	select	CASE WHEN count(*)=1 THEN  'S'  ELSE 'N' END
	into STRICT	ie_atend_visita_w
	from	atendimento_visita
	where	nr_seq_controle	= nr_seq_controle_p
	and	coalesce(dt_saida::text, '') = ''
	and	ie_paciente	= 'S';

	if (ie_atend_visita_w = 'S') then
		CALL excluir_grupo_visita_pac(nr_atendimento_p);
	end if;
	end;
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select	count(*)
	into STRICT	qt_atendimentos_p
	from	atendimento_visita
	where	nr_atendimento	= nr_atendimento_p
	and	coalesce(dt_saida::text, '') = '';
end if;

if (nr_seq_controle_p IS NOT NULL AND nr_seq_controle_p::text <> '') then
	begin
	select	count(*)
	into STRICT	qt_acompanhante_p
	from	atendimento_acompanhante
	where	nr_controle	= nr_seq_controle_p
	and	coalesce(dt_saida::text, '') = '';

	select	substr(obter_paciente_cracha(nr_seq_controle_p), 1, 15)
	into STRICT	nr_atendimento_cracha_p
	;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_controle_visitas ( nr_atendimento_p bigint, nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, qt_atendimentos_p INOUT bigint, qt_acompanhante_p INOUT bigint, nr_atendimento_cracha_p INOUT text) FROM PUBLIC;
