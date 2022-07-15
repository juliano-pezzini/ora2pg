-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_aprova_exame_amostra ( nr_prescricao_p bigint, nr_seq_resultado_p bigint, nr_seq_material_p bigint, cd_medico_resp_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_prescr_w		bigint;

c01 CURSOR FOR 
	SELECT c.nr_sequencia nr_seq_prescr 
	from atendimento_paciente a, 
	prescr_medica b, 
	prescr_procedimento c, 
	exame_laboratorio d, 
	exame_lab_resultado e, 
	exame_lab_result_item f, 
	material_exame_lab g, 
	prescr_proc_mat_item j 
	where b.nr_atendimento = a.nr_atendimento 
	and c.nr_prescricao = b.nr_prescricao 
	and d.nr_seq_exame = f.nr_seq_exame 
	and e.nr_prescricao = b.nr_prescricao 
	and e.nr_atendimento = a.nr_atendimento 
	and f.nr_seq_resultado = e.nr_seq_resultado 
	and f.nr_seq_prescr = c.nr_sequencia 
	and g.cd_material_exame = c.cd_material_exame 
	and j.nr_prescricao = c.nr_prescricao 
	and j.nr_seq_prescr = c.nr_sequencia 
	and c.ie_status_atend = 30 
	and (c.cd_material_exame IS NOT NULL AND c.cd_material_exame::text <> '') 
	and (c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '') 
	and coalesce(c.ie_suspenso,'N') = 'N' 
	and c.cd_motivo_baixa = 0 
	and f.ie_status = 1 
	and (lab_obter_regra_estab(1, a.cd_estabelecimento) = 'S') 
	and b.nr_prescricao = nr_prescricao_p 
	and f.nr_seq_material = nr_seq_material_p;

BEGIN
 
open c01;
loop 
fetch c01 into 
	nr_seq_prescr_w;
EXIT WHEN NOT FOUND; /* apply on c01 */	
 
	update exame_lab_result_item 
	set dt_aprovacao = clock_timestamp(), 
	nm_usuario_aprovacao = nm_usuario_p, 
	dt_atualizacao = clock_timestamp(), 
	nm_usuario = nm_usuario_p, 
	cd_medico_resp = cd_medico_resp_p 
	where nr_seq_resultado = nr_seq_resultado_p 
	and nr_seq_prescr = nr_seq_prescr_w 
	and (nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');
	 
	update prescr_procedimento 
	set ie_status_atend = 35 
	where nr_prescricao = nr_prescricao_p 
	and nr_sequencia = nr_seq_prescr_w 
	and ie_status_atend < 35;
	 
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_aprova_exame_amostra ( nr_prescricao_p bigint, nr_seq_resultado_p bigint, nr_seq_material_p bigint, cd_medico_resp_p text, nm_usuario_p text) FROM PUBLIC;

