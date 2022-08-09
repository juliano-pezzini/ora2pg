-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_substituicao_material ( nr_sequencia_matpaci_p bigint, nr_sequencia_p bigint, nr_sequencia_auditoria_p bigint, cd_material_substituto_p text, cd_motivo_audit_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_gerada_w				bigint;
nr_seq_motivo_w				bigint;
nr_interno_conta_w			bigint;
qt_material_w				bigint;
					

BEGIN 
 
select	nr_interno_conta, 
	qt_material 
into STRICT	nr_interno_conta_w, 
	qt_material_w 
from 	material_atend_paciente 
where	nr_sequencia = nr_sequencia_matpaci_p;	
 
if (nr_sequencia_matpaci_p IS NOT NULL AND nr_sequencia_matpaci_p::text <> '') then 
 
	update	auditoria_matpaci 
	set	qt_ajuste = 0, 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp(), 
		nr_seq_motivo = cd_motivo_audit_p 
	where	nr_sequencia = nr_sequencia_p;
	 
	nr_seq_gerada_w := duplicar_mat_paciente(nr_sequencia_matpaci_p, nm_usuario_p, 'N', nr_seq_gerada_w);
	 
	update 	material_atend_paciente 
	set 	cd_material = cd_material_substituto_p, 
		cd_material_exec = cd_material_substituto_p, 
		cd_material_prescricao = cd_material_substituto_p, 
		ie_auditoria = 'N' 
	where 	nr_sequencia = nr_seq_gerada_w;
	 
	CALL atualiza_preco_material(nr_seq_gerada_w, nm_usuario_p);
	 
	update 	material_atend_paciente 
	set 	ie_auditoria = 'S' 
	where 	nr_sequencia = nr_seq_gerada_w;
	 
	CALL Atualizar_Lista_Itens_Audit(nr_interno_conta_w, nr_seq_gerada_w, 1, qt_material_w, nm_usuario_p, 
						cd_motivo_audit_p, nr_sequencia_auditoria_p, 'N');
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_substituicao_material ( nr_sequencia_matpaci_p bigint, nr_sequencia_p bigint, nr_sequencia_auditoria_p bigint, cd_material_substituto_p text, cd_motivo_audit_p text, nm_usuario_p text) FROM PUBLIC;
