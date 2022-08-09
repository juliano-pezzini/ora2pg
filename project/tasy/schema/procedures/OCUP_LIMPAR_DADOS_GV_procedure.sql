-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ocup_limpar_dados_gv ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_pessoa_fisica_p text, nm_paciente_p text, nm_usuario_p text) AS $body$
DECLARE

					
ie_status_desfazer_reserva_w		varchar(1);
nm_paciente_w				gestao_vaga.nm_paciente%type;

BEGIN

if (coalesce(nm_paciente_p::text, '') = '') then
	select	max(nm_pac_reserva)
	into STRICT	nm_paciente_w
	from	unidade_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and	cd_unidade_basica = cd_unidade_basica_p
	and	cd_unidade_compl = cd_unidade_compl_p;
	
else
	nm_paciente_w := nm_paciente_p;
	
end if;
if (coalesce(cd_setor_atendimento_p,0) > 0) and (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') and (cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '') and
	((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (nm_paciente_w IS NOT NULL AND nm_paciente_w::text <> ''))then

	ie_status_desfazer_reserva_w := Obter_param_Usuario(1002, 155, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_status_desfazer_reserva_w);	
	
	update	gestao_vaga
	set	cd_setor_desejado  = NULL,
		cd_unidade_basica  = NULL,
		cd_unidade_compl   = NULL,
		ie_status	  = coalesce(ie_status_desfazer_reserva_w, 'A'),
		nm_usuario	  = nm_usuario_p,
		dt_atualizacao 	  = clock_timestamp()
	where	cd_setor_desejado = cd_setor_atendimento_p
	and	cd_unidade_basica = cd_unidade_basica_p
	and	cd_unidade_compl  = cd_unidade_compl_p
	and 	(((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and
		  cd_pessoa_fisica  = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica_p::text, '') = '' and
		  (nm_paciente_w IS NOT NULL AND nm_paciente_w::text <> '') and
		  nm_paciente = nm_paciente_w));
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ocup_limpar_dados_gv ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_pessoa_fisica_p text, nm_paciente_p text, nm_usuario_p text) FROM PUBLIC;
