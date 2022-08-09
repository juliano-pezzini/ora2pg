-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_evolucao_paciente_html ( nr_atendimento_p bigint, ie_tipo_evolucao_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_medico_p text, ie_evolucao_clinica_p text) AS $body$
DECLARE


cd_evolucao_w			bigint;
ie_nivel_atencao_w		varchar(1);
ie_evolucao_clinica_w   varchar(255);


BEGIN


If (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND ie_tipo_evolucao_p IS NOT NULL AND ie_tipo_evolucao_p::text <> '') then

	select	nextval('evolucao_paciente_seq')
	into STRICT	cd_evolucao_w
	;

	Select	wheb_assist_pck.get_nivel_atencao_perfil,
			Obter_Valor_Param_Usuario(281, 693, Obter_Perfil_Ativo, nm_usuario_p, obter_estabelecimento_ativo)
	into STRICT	ie_nivel_atencao_w,
			ie_evolucao_clinica_w
	;

	insert into evolucao_paciente(	nr_atendimento,
					cd_evolucao,
					dt_evolucao,
					ie_tipo_evolucao,
					cd_pessoa_fisica,
					nm_usuario,
					cd_medico,
					dt_liberacao,
					ie_evolucao_clinica,
					ie_situacao,
					dt_atualizacao,
					ie_nivel_atencao)
				values (	nr_atendimento_p,
					cd_evolucao_w,
					clock_timestamp(),
					ie_tipo_evolucao_p,
					cd_pessoa_fisica_p,
					nm_usuario_p,
					cd_medico_p,
					clock_timestamp(),
					coalesce(ie_evolucao_clinica_w,'E'),
					'A',
					clock_timestamp(),
					ie_nivel_atencao_w);

	CALL COPIA_CAMPO_LONG_DE_PARA_NOVO('W_EVOLUCAO_GRUPO_FAMILIAR',
					'DS_EVOLUCAO',
					'where nm_usuario = :nm_usuario_p',
					'nm_usuario_p='||nm_usuario_p,
					'EVOLUCAO_PACIENTE',
					'DS_EVOLUCAO',
					'where cd_evolucao = :cd_evolucao',
					'cd_evolucao='||cd_evolucao_w,
					'L');


	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_evolucao_paciente_html ( nr_atendimento_p bigint, ie_tipo_evolucao_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_medico_p text, ie_evolucao_clinica_p text) FROM PUBLIC;
