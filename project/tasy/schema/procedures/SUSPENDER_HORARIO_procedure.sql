-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_horario (nr_prescricao_p bigint, nr_seq_medic_p bigint, nr_atendimento_p bigint, cd_material_p bigint, nr_seq_motipo_p bigint, ie_tipo_item_p text, nr_seq_horarios_p text, dt_horario_p timestamp, cd_estabelecimento_p bigint, ds_motivo_p text, nm_usuario_p text) AS $body$
DECLARE

			   
ds_erro_w		varchar(255);
nr_seq_horarios_w	varchar(255);
nr_pos_virgula_w 	smallint;	
nr_seq_horario_w	bigint;	
 

BEGIN 
nr_seq_horarios_w := null;
if (nr_seq_horarios_p IS NOT NULL AND nr_seq_horarios_p::text <> '') then 
	begin 
	nr_seq_horarios_w := trim(both nr_seq_horarios_p);
	while(nr_seq_horarios_w IS NOT NULL AND nr_seq_horarios_w::text <> '') loop 
		begin 
		nr_pos_virgula_w := position(',' in nr_seq_horarios_w);		
		if (nr_pos_virgula_w > 0) then 
			begin 
			nr_seq_horario_w	:= (substr(nr_seq_horarios_w,1,nr_pos_virgula_w-1))::numeric;
			nr_seq_horarios_w	:= substr(nr_seq_horarios_w,nr_pos_virgula_w+1,length(nr_seq_horarios_w));			
			end;
		else 
			begin 
			nr_seq_horario_w	:= (nr_seq_horarios_w)::numeric;
			nr_seq_horarios_w	:= null;
			end;
		end if;	
 
		-- Consiste a suspensão do horário 
		ds_erro_w := Consiste_susp_prescr_mat_hor(nr_prescricao_p, nr_seq_horario_w, cd_estabelecimento_p, nm_usuario_p, ds_erro_w);
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '')	then 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(214150,'ERRO='||ds_erro_w);	
		else 
			-- suspender horário 
			CALL suspender_prescr_mat_hor(nr_seq_horario_w, nm_usuario_p, nr_seq_motipo_p, ds_motivo_p,'N',null);
			-- gerar evento ADEP 
			CALL Gerar_Alter_Hor_Prescr_Adep(nr_atendimento_p, ie_tipo_item_p, cd_material_p, nr_prescricao_p, nr_seq_medic_p, nr_seq_horario_w,dt_horario_p, 12, null, null, nr_seq_motipo_p, nm_usuario_p);
		end if;
		end;
	end loop;
	end;
end if;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_horario (nr_prescricao_p bigint, nr_seq_medic_p bigint, nr_atendimento_p bigint, cd_material_p bigint, nr_seq_motipo_p bigint, ie_tipo_item_p text, nr_seq_horarios_p text, dt_horario_p timestamp, cd_estabelecimento_p bigint, ds_motivo_p text, nm_usuario_p text) FROM PUBLIC;
