-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_gerar_hor_adep_modelo ( cd_setor_usuario_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_hora_prescricao_w		varchar(255)	:= 3;
qt_hor_add_padr_gestao_w	varchar(255)	:= 6;
qt_hor_ant_padr_gestao_w	varchar(255)	:= 2;
ie_proc_setor_user_w		varchar(255)	:= 'N';
ie_interv_setor_user_w		varchar(255)	:= 'N';
ie_modelo_tabela_gestao_w	varchar(255)	:= 'W_ADEP_T';


BEGIN

/* Função: ADEP - Parâmetro [22] - Número de horas após o vencimento das prescrições para continuidade da exibição das mesmas */

qt_hora_prescricao_w := Obter_Param_Usuario(1113, 22, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, qt_hora_prescricao_w);

/* Função: ADEP - Parâmetro [64] - Exibir somente os procedimentos dos setores do usuário na pasta Gestão */

ie_proc_setor_user_w := Obter_Param_Usuario(1113, 64, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_proc_setor_user_w);

/* Função: ADEP - Parâmetro [72] - Exibir somente as intervenções de enfermagem dos setores do usuário na pasta Gestão */

ie_interv_setor_user_w := Obter_Param_Usuario(1113, 72, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_interv_setor_user_w);

/* Função: ADEP - Parâmetro [93] - Número de horas adicionais padrão para o filtro na pasta Gestão */

qt_hor_add_padr_gestao_w := Obter_Param_Usuario(1113, 93, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, qt_hor_add_padr_gestao_w);

/* Função: ADEP - Parâmetro [94] - Número de horas anteriores padrão para o filtro na pasta Gestão */

qt_hor_ant_padr_gestao_w := Obter_Param_Usuario(1113, 94, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, qt_hor_ant_padr_gestao_w);

/* Função: ADEP - Parâmetro [195] - Modelo de armazenamento (em relação à base de dados) das informações em relação à pasta Gestão */

ie_modelo_tabela_gestao_w := Obter_Param_Usuario(1113, 195, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_modelo_tabela_gestao_w);

CALL gerar_horarios_adep_modelo(cd_estabelecimento_p,
			   cd_perfil_p,
			   cd_setor_usuario_p,
			   nr_atendimento_p,
			   '',
			   qt_hor_ant_padr_gestao_w,
			   qt_hor_add_padr_gestao_w,
			   qt_hora_prescricao_w,
			   'S',
			   'S',
			   ie_proc_setor_user_w,
			   ie_interv_setor_user_w,
			   '',
			   'S',
			   'S',
			   ie_modelo_tabela_gestao_w,
			   'G',
			   'N',
			   nm_usuario_p,
			   'S',
			   null,
			   'N',
			   'N',
			   'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_hor_adep_modelo ( cd_setor_usuario_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
