-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_estoque_mat_cirurgia (cd_estabelecimento_p bigint, nr_seq_atepacu_p bigint, nm_usuario_p text, nr_prescricao_p bigint, cd_local_estoque_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

					 
cd_material_w			integer;
qt_material_w			double precision;
cd_unidade_medida_w		varchar(30);
nr_seq_lote_fornec_w		bigint;
cd_setor_atendimento_w     integer;
cd_motivo_baixa_w		smallint;
nr_seq_prescricao_w		bigint;
qt_estoque_w			bigint;

 
 
 
C01 CURSOR FOR 
SELECT nr_sequencia, 
	cd_material, 
	qt_material, 
	cd_unidade_medida, 
	nr_seq_lote_fornec 
from	prescr_material 
where	nr_prescricao	= nr_prescricao_p 
and	cd_motivo_baixa	= 0;


BEGIN 
cd_motivo_baixa_w := obter_param_usuario(36, 21, obter_perfil_ativo, nm_usuario_p, 0, cd_motivo_baixa_w);
begin 
	select	cd_setor_atendimento 
	into STRICT	cd_setor_atendimento_w 
	from 	atend_paciente_unidade 
	where 	nr_seq_interno = nr_seq_atepacu_p;
	exception 
		when no_data_found then 
			cd_setor_atendimento_w := null;
end;
 
 
open C01;
loop 
	fetch c01 into		nr_seq_prescricao_w, 
				cd_material_w, 
				qt_material_w, 
				cd_unidade_medida_w, 
				nr_seq_lote_fornec_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	 
	select obter_saldo_disp_estoque(cd_estabelecimento_p, cd_material_w, cd_local_estoque_p, clock_timestamp()) 
	into STRICT 	qt_estoque_w 
	;
	 
	if (qt_material_w > qt_estoque_w ) then 
		ds_erro_p := wheb_mensagem_pck.get_texto(279560);
	else	 
		CALL Gerar_Prescricao_Estoque(cd_estabelecimento_p,null,null, cd_material_w,clock_timestamp(),2,cd_local_estoque_p, 
					qt_material_w,cd_setor_atendimento_w,cd_unidade_medida_w,nm_usuario_p,'E',null,null,null,null,null,null, 
					nr_seq_lote_fornec_w, null, null, null, null, null, null);
	 
		update 	prescr_material 
		set  	cd_motivo_baixa = cd_motivo_baixa_w 
		where 	nr_prescricao = nr_prescricao_p 
		and 	nr_sequencia = nr_seq_prescricao_w;
	end if;
	 
commit;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_estoque_mat_cirurgia (cd_estabelecimento_p bigint, nr_seq_atepacu_p bigint, nm_usuario_p text, nr_prescricao_p bigint, cd_local_estoque_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
