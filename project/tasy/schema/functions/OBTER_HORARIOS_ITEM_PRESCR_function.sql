-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horarios_item_prescr (cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_prescricoes_p text, ie_laboratorio_p text) RETURNS varchar AS $body$
DECLARE

 
nr_prescricao_w	bigint;
nr_prescr_old_w	bigint;
nr_seq_item_w		bigint;
nr_seq_horario_w	bigint;
dt_horario_w		varchar(12);
ie_exibe_suspenso_w	varchar(12);
ds_horarios_w		varchar(2000);

ie_data_proc_w	varchar(15);
ie_data_lib_prescr_w	varchar(15);

/* obter horários x item x atendimento */
 
c01 CURSOR FOR 
SELECT	a.nr_prescricao nr_prescricao, 
	b.nr_sequencia nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
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
and	coalesce(c.ie_adep,'S') = 'S' 
and	a.dt_validade_prescr > clock_timestamp() 
and	b.cd_material = cd_item_p 
and	ie_tipo_item_p in ('M', 'IAH') 
and	obter_se_contido(a.nr_prescricao, '(' || nr_prescricoes_p || ')') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union
 
SELECT	a.nr_prescricao nr_prescricao, 
	b.nr_sequencia nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
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
and	ie_tipo_item_p in ('P','I') 
and	obter_se_contido(a.nr_prescricao, '(' || nr_prescricoes_p || ')') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union
 
select	a.nr_prescricao nr_prescricao, 
	b.nr_sequencia nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
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
and	obter_se_contido(a.nr_prescricao, '(' || nr_prescricoes_p || ')') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union
 
select	a.nr_sequencia nr_prescricao, 
	b.nr_sequencia nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
from	pe_prescr_proc_hor c, 
	pe_prescr_proc b, 
	pe_prescricao a 
where	c.nr_seq_pe_proc = b.nr_sequencia 
and	b.nr_seq_prescr = a.nr_sequencia 
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
and	a.nr_atendimento = nr_atendimento_p 
and	b.nr_seq_proc = cd_item_p 
and	coalesce(b.ie_adep,'N') = 'S' 
and	ie_tipo_item_p = 'E' 
and	obter_se_contido(a.nr_sequencia, '(' || nr_prescricoes_p || ')') = 'S' 

union
 
select	a.nr_prescricao nr_prescricao, 
	b.nr_sequencia nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
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
and	obter_se_contido(a.nr_prescricao, '(' || nr_prescricoes_p || ')') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union
 
select	a.nr_prescricao nr_prescricao, 
	b.nr_sequencia nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
from	prescr_mat_hor c, 
	prescr_material b, 
	prescr_medica a 
where	c.nr_prescricao = b.nr_prescricao 
and	c.nr_seq_material = b.nr_sequencia 
and	b.nr_prescricao = a.nr_prescricao 
--and	a.dt_liberacao is not null 
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S' 
and	a.nr_atendimento = nr_atendimento_p 
and	b.ie_agrupador in (2) 
and	a.dt_validade_prescr > clock_timestamp() 
and	b.cd_material = cd_item_p 
and	ie_tipo_item_p = 'MAT' 
and	obter_se_contido(a.nr_prescricao, '(' || nr_prescricoes_p || ')') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union
 
select	a.nr_prescricao nr_prescricao, 
	null nr_seq_item, 
	c.nr_sequencia nr_seq_hor, 
	to_char(c.dt_horario,'dd/mm hh24:mi') 
from	prescr_dieta_hor c, 
	prescr_medica a 
where	c.nr_prescricao = a.nr_prescricao 
--and	a.dt_liberacao is not null 
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S' 
and	a.nr_atendimento = nr_atendimento_p 
and	a.dt_validade_prescr > clock_timestamp() 
and	c.cd_refeicao = cd_item_p 
and	ie_tipo_item_p = 'D' 
and	obter_se_contido(a.nr_prescricao, '(' || nr_prescricoes_p || ')') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 
order by 
	1,3;


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (nr_prescricoes_p IS NOT NULL AND nr_prescricoes_p::text <> '') and (ie_laboratorio_p IS NOT NULL AND ie_laboratorio_p::text <> '') then 
	 
	ie_exibe_suspenso_w := obter_param_usuario(1113, 117, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exibe_suspenso_w);
 
	if (ie_tipo_item_p in ('P','I')) then 
		ie_data_proc_w := obter_param_usuario(924, 223, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_proc_w);
	else 
		ie_data_lib_prescr_w := obter_param_usuario(1113, 115, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_lib_prescr_w);
	end if;
	 
	/* gerar horários x item x atendimento */
 
	open c01;
	loop 
	fetch c01 into	nr_prescricao_w, 
				nr_seq_item_w, 
				nr_seq_horario_w, 
				dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		if (nr_prescricao_w <> coalesce(nr_prescr_old_w,0)) then 
			if (coalesce(ds_horarios_w::text, '') = '') then 
				ds_horarios_w := to_char(nr_prescricao_w) || ':' || chr(10);
				ds_horarios_w := ds_horarios_w || dt_horario_w || ',';
			else 
				ds_horarios_w := substr(ds_horarios_w,1,length(ds_horarios_w)-1);
				ds_horarios_w := ds_horarios_w || chr(10) || to_char(nr_prescricao_w) || ':' || chr(10);
				ds_horarios_w := ds_horarios_w || dt_horario_w || ',';
			end if;
			nr_prescr_old_w := nr_prescricao_w;
		else 
			ds_horarios_w := ds_horarios_w || dt_horario_w || ',';
		end if;
		end;
	end loop;
	close c01;
end if;
 
return substr(ds_horarios_w,1,length(ds_horarios_w)-1);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horarios_item_prescr (cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_prescricoes_p text, ie_laboratorio_p text) FROM PUBLIC;
