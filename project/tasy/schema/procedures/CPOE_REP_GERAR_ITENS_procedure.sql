-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_rep_gerar_itens ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p cpoe_dieta.cd_pessoa_fisica%type, ie_tipo_pessoa_p text default 'N', ie_oncologia_p text default 'N') AS $body$
DECLARE

	
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;	
cd_setor_atendimento_w	prescr_medica.cd_setor_atendimento%type;
nr_seq_agenda_w			prescr_medica.nr_seq_agenda%type;
cd_funcao_w				funcao.cd_funcao%type;
dt_liberacao_w			timestamp := dt_liberacao_p;

BEGIN

select	max(cd_funcao_origem),
		max(cd_setor_atendimento)
into STRICT	cd_funcao_w,
		cd_setor_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (coalesce(ie_oncologia_p,'N') = 'S') then
	dt_liberacao_w := null;
end if;

select	max(nr_seq_agenda)
into STRICT	nr_seq_agenda_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (nr_atendimento_p = 0) then
	nr_atendimento_w := null;
else
	nr_atendimento_w := nr_atendimento_p;
end if;

CALL gravar_processo_longo(obter_desc_expressao(770069),'CPOE_REP_GERAR_ITENS',1);
CALL cpoe_rep_gerar_recomendacao(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_gasoterapia(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_hemodialise(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_hemoterapia(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_npt_adulta(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_funcao_w,cd_setor_atendimento_w);

CALL cpoe_rep_gerar_suplemento(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_leite_deriv(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_jejum(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w,cd_setor_atendimento_w);	
CALL cpoe_rep_gerar_dieta_oral(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_dieta_enteral(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w,cd_setor_atendimento_w);
CALL cpoe_rep_gerar_procedimento(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w,cd_setor_atendimento_w, null, null, nr_seq_agenda_w);
CALL cpoe_rep_generate_material(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w, ie_tipo_pessoa_p,cd_setor_atendimento_w, nr_seq_agenda_w);
CALL cpoe_rep_gerar_medicamento(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w, ie_tipo_pessoa_p,cd_setor_atendimento_w, nr_seq_agenda_w);
CALL cpoe_rep_gerar_solucao(nr_prescricao_p, nr_atendimento_w, dt_inicio_prescr_p, dt_validade_prescr_p, dt_liberacao_w, nm_usuario_p, cd_pessoa_fisica_p, cd_funcao_w, ie_tipo_pessoa_p,cd_setor_atendimento_w, nr_seq_agenda_w);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_rep_gerar_itens ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p cpoe_dieta.cd_pessoa_fisica%type, ie_tipo_pessoa_p text default 'N', ie_oncologia_p text default 'N') FROM PUBLIC;

