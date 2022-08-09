-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_apraz_etapa_sol ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, dt_inicio_p timestamp, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text, ie_somente_gedipa_p text, cd_funcao_origem_p bigint, ie_gedipa_p text, nr_seq_etapa_p bigint, ie_gera_kit_sol_acm_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w		varchar(2000);
dt_horario_w		timestamp;
qt_material_horario_w	bigint;

BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (dt_inicio_p IS NOT NULL AND dt_inicio_p::text <> '') and (nr_seq_etapa_p IS NOT NULL AND nr_seq_etapa_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	dt_horario_w 		:= to_date(to_char(dt_inicio_p,'dd/mm/yyyy hh24:mi') || ':00','dd/mm/yyyy hh24:mi:ss');

	select	count(*)
	into STRICT	qt_material_horario_w
	from	prescr_solucao b,
		prescr_mat_hor c
	where	c.nr_seq_solucao  = b.nr_seq_solucao
	and	c.nr_prescricao = b.nr_prescricao
	and	b.nr_prescricao = nr_prescricao_p
	and	coalesce(c.ie_horario_especial,'N') <> 'S'
	and	b.nr_seq_solucao = nr_seq_solucao_p
	and 	c.dt_horario = dt_horario_w;

	if (qt_material_horario_w > 0) then
		ds_erro_w := wheb_mensagem_pck.get_texto(281862,null);
	end if;
end if;

ds_erro_p := ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_apraz_etapa_sol ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, dt_inicio_p timestamp, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text, ie_somente_gedipa_p text, cd_funcao_origem_p bigint, ie_gedipa_p text, nr_seq_etapa_p bigint, ie_gera_kit_sol_acm_p text, ds_erro_p INOUT text) FROM PUBLIC;
