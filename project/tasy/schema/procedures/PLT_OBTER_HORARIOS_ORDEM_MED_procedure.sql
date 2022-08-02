-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_obter_horarios_ordem_med ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_prescr_usuario_p text) AS $body$
DECLARE


dt_horario_w	timestamp;

c01 CURSOR FOR
SELECT	c.dt_horario
from	prescr_ordem_hor c,
	prescr_medica_ordem b,
	prescr_medica a
where	c.nr_seq_ordem = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
and	coalesce(a.ie_adep,'S') = 'S'
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	c.dt_horario;


BEGIN
open c01;
loop
fetch c01 into dt_horario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	insert into w_rep_horarios_t(
		nm_usuario,
		dt_horario)
	values (
		nm_usuario_p,
		dt_horario_w);
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_obter_horarios_ordem_med ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_prescr_usuario_p text) FROM PUBLIC;

