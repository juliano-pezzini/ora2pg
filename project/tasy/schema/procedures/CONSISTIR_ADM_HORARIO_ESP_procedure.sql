-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_adm_horario_esp (cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, dt_horario_adm_p timestamp, ie_laboratorio_p text) AS $body$
DECLARE


dt_entrada_w	timestamp;
dt_alta_w	timestamp;
nr_seq_adm_w	bigint;
ie_data_proc_w	varchar(15);
ie_data_lib_prescr_w	varchar(15);
ie_exibe_suspenso_w	varchar(15);
ie_atualizar_hor_alta_w  varchar(1);

c01 CURSOR FOR
SELECT	coalesce(max(c.nr_sequencia),0) nr_seq_hor
from	prescr_mat_hor c,
	prescr_material b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_material = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	b.ie_agrupador in (1)
and	a.dt_validade_prescr > clock_timestamp()
and	b.cd_material = cd_item_p
and	ie_tipo_item_p = 'M'
and	a.nr_prescricao = nr_prescricao_p
and	b.nr_sequencia = nr_seq_item_p
and	(c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')
and	c.dt_horario >= dt_horario_adm_p
and	c.ie_horario_especial = 'S'
and	coalesce(c.ie_adep,'S') = 'S'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

SELECT	coalesce(max(c.nr_sequencia),0) nr_seq_hor
from	prescr_proc_hor c,
	prescr_procedimento b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_procedimento = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_proc_w) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_proc_w))::text <> '')
and	obter_se_exibir_adep_suspensos(b.dt_suspensao, ie_exibe_suspenso_w) = 'S'
and	((coalesce(b.nr_seq_exame::text, '') = '' and ie_laboratorio_p = 'N') or ((b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '') and ie_laboratorio_p = 'S'))
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.cd_procedimento = cd_item_p
and	ie_tipo_item_p = 'P'
and	a.nr_prescricao = nr_prescricao_p
and	b.nr_sequencia = nr_seq_item_p
and	(c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')
and	c.dt_horario >= dt_horario_adm_p
and	c.ie_horario_especial = 'S'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	coalesce(max(c.nr_sequencia),0) nr_seq_hor
from	prescr_rec_hor c,
	prescr_recomendacao b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_recomendacao = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > clock_timestamp()
and	((b.cd_recomendacao = cd_item_p) or (coalesce(b.cd_recomendacao::text, '') = '' and b.ds_recomendacao = cd_item_p))
and	ie_tipo_item_p = 'R'
and	a.nr_prescricao = nr_prescricao_p
and	b.nr_sequencia = nr_seq_item_p
and	(c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')
and	c.dt_horario >= dt_horario_adm_p
and	c.ie_horario_especial = 'S'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	coalesce(max(c.nr_sequencia),0) nr_seq_hor
from	pe_prescr_proc_hor c,
	pe_prescr_proc b,
	pe_prescricao a
where	c.nr_seq_pe_proc = b.nr_sequencia
and	b.nr_seq_prescr = a.nr_sequencia
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_seq_proc = cd_item_p
and	ie_tipo_item_p = 'E'
and	a.nr_sequencia = nr_prescricao_p
and	b.nr_sequencia = nr_seq_item_p
and	coalesce(b.ie_adep,'N') = 'S'
and	(c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')
and	c.dt_horario >= dt_horario_adm_p
and	c.ie_horario_especial = 'S'

union

select	coalesce(max(c.nr_sequencia),0) nr_seq_hor
from	prescr_mat_hor c,
	prescr_material b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_material = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	b.ie_agrupador in (12)
and	a.dt_validade_prescr > clock_timestamp()
and	b.cd_material = cd_item_p
and	ie_tipo_item_p = 'S'
and	a.nr_prescricao = nr_prescricao_p
and	b.nr_sequencia = nr_seq_item_p
and	(c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')
and	c.dt_horario >= dt_horario_adm_p
and	c.ie_horario_especial = 'S'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';


BEGIN

ie_data_proc_w := obter_param_usuario(924, 223, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_proc_w);
ie_data_lib_prescr_w := obter_param_usuario(1113, 115, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_lib_prescr_w);
ie_exibe_suspenso_w := obter_param_usuario(1113, 117, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exibe_suspenso_w);
ie_atualizar_hor_alta_w := obter_param_usuario(1113, 67, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_hor_alta_w);

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (dt_horario_adm_p IS NOT NULL AND dt_horario_adm_p::text <> '') then
	/* obter dados atendimento */

	select	max(dt_entrada),
		max(dt_alta)
	into STRICT	dt_entrada_w,
		dt_alta_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;

	/* validar dados atendimento x administracao */

	if	(dt_alta_w IS NOT NULL AND dt_alta_w::text <> '' AND ie_atualizar_hor_alta_w = 'N')  then
		/*Este atendimento teve alta em ' || to_char(dt_alta_w, 'dd/mm/yyyy hh24:mi:ss') || chr(10) ||
							'Nao e possivel realizar administracoes para atendimentos com alta!');*/
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261460, 'DT_ALTA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_alta_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
	elsif (dt_horario_adm_p < dt_entrada_w) then
		--A data da administracao atual nao pode ser anterior a data de entrada do atendimento!');
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261461);
	end if;

	/* validar administracao x administracoes anteriores */

	open c01;
	loop
	fetch c01 into nr_seq_adm_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_adm_w := nr_seq_adm_w;
		if (nr_seq_adm_w > 0) then
			--Ja foram realizadas administracoes anteriores ou simultaneas deste item no horario informado!');
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(261462);
		end if;
		end;
	end loop;
	close c01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_adm_horario_esp (cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, dt_horario_adm_p timestamp, ie_laboratorio_p text) FROM PUBLIC;

