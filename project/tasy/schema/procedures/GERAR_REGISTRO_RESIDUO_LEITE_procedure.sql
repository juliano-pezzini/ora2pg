-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_registro_residuo_leite ( nr_seq_horario_p bigint, ie_residuo_p text, qt_volume_residuo_p bigint, ie_caracteristica_p text, qt_volume_prescr_p bigint, qt_volume_adm_p bigint, dt_registro_p timestamp, cd_perfil_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w		bigint;
nr_seq_redisuo_w		bigint;
nr_seq_atend_w			bigint;
nr_seq_tipo_w			bigint;
nr_prescricao_w			bigint;
nr_seq_material_w		integer;
cd_setor_atendimento_w	integer;
cd_profissional_w		varchar(10);

--Regra de lancamento das ganhos e perdas 
c01 CURSOR FOR 
SELECT	nr_seq_tipo 
from	prescr_sol_perda_ganho 
where	ie_evento		= 41 
and		coalesce(ie_tipo_solucao,4)	= 4 
and	((coalesce(cd_material::text, '') = '') or (cd_material in (	SELECT	a.cd_material 
							from	prescr_material a 
							where	a.nr_sequencia	= nr_seq_material_w 
							and	a.nr_prescricao		= nr_prescricao_w))) 
and	((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_atendimento	= cd_setor_atendimento_w)) 
and	((coalesce(cd_perfil::text, '') = '') or (cd_perfil = cd_perfil_p));
										

BEGIN 
 
if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') and (ie_residuo_p IS NOT NULL AND ie_residuo_p::text <> '') and (ie_caracteristica_p IS NOT NULL AND ie_caracteristica_p::text <> '') then 
	 
	select	max(obter_pf_usuario(nm_usuario_p,'C')) 
	into STRICT	cd_profissional_w 
	;	
	 
	select	max(a.nr_atendimento), 
			max(a.nr_prescricao), 
			max(b.nr_sequencia), 
			coalesce(max(a.cd_setor_atendimento),0)			 
	into STRICT	nr_atendimento_w, 
			nr_prescricao_w, 
			nr_seq_material_w, 
			cd_setor_atendimento_w 
	from	prescr_medica a,	 
			prescr_material b, 
			prescr_mat_hor c 
	where	a.nr_prescricao = b.nr_prescricao 
	and		b.nr_prescricao = c.nr_prescricao 
	and		b.nr_sequencia = c.nr_seq_material 
	and		c.nr_sequencia = nr_seq_horario_p;
	 
	select	nextval('adep_residuo_gastrico_seq') 
	into STRICT	nr_seq_redisuo_w 
	;
	 
	insert into adep_residuo_gastrico(	nr_sequencia, 
										dt_atualizacao, 
										nm_usuario, 
										dt_atualizacao_nrec, 
										nm_usuario_nrec, 
										dt_evento, 
										qt_volume, 
										ie_caracteristica, 
										ie_acao, 
										qt_volume_prescrito, 
										qt_volume_adm, 
										nr_seq_horario, 
										nr_atendimento, 
										nr_prescricao) 
								values (	nr_seq_redisuo_w, 
										clock_timestamp(), 
										nm_usuario_p, 
										clock_timestamp(), 
										nm_usuario_p, 
										dt_registro_p, 
										qt_volume_residuo_p, 
										ie_caracteristica_p, 
										ie_residuo_p, 
										qt_volume_prescr_p, 
										qt_volume_adm_p, 
										nr_seq_horario_p, 
										nr_atendimento_w, 
										nr_prescricao_w);
	 
	commit;
	 
	if (ie_residuo_p = 'Z') then		 

		open C01;
		loop 
		fetch C01 into	 
			nr_seq_tipo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			 
			select	nextval('atendimento_perda_ganho_seq') 
			into STRICT	nr_seq_atend_w 
			;
			insert into atendimento_perda_ganho(nr_sequencia, 
					nr_atendimento, 
					dt_atualizacao, 
					nm_usuario, 
					nr_seq_tipo, 
					qt_volume, 
					ds_observacao, 
					dt_medida, 
					cd_setor_atendimento, 
					ie_origem, 
					dt_referencia, 
					cd_profissional, 
					ie_situacao, 
					dt_liberacao, 
					dt_apap, 
					qt_ocorrencia,
					nr_seq_horario) 
			values (nr_seq_atend_w, 
					nr_atendimento_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_tipo_w, 
					qt_volume_residuo_p, 
					ds_observacao_p, 
					clock_timestamp(), 
					cd_setor_atendimento_w, 
					'S', 
					clock_timestamp(), 
					cd_profissional_w, 
					'A', 
					clock_timestamp(), 
					clock_timestamp(), 
					1,
					nr_seq_horario_p);
		end loop;
		close C01;		
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_registro_residuo_leite ( nr_seq_horario_p bigint, ie_residuo_p text, qt_volume_residuo_p bigint, ie_caracteristica_p text, qt_volume_prescr_p bigint, qt_volume_adm_p bigint, dt_registro_p timestamp, cd_perfil_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
