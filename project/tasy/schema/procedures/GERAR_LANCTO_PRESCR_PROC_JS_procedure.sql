-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lancto_prescr_proc_js ( nr_prescricao_p bigint, nr_seq_proced_p bigint, nr_seq_evento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, ie_regra_lanc_aut_p text, ie_consistencia_ativa_p text, cd_perfil_p bigint, nr_erro_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_erro_w	smallint;

BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_proced_p IS NOT NULL AND nr_seq_proced_p::text <> '') and (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	CALL gerar_lancto_aut_prescr_proc( 
		nr_prescricao_p, 
		nr_seq_proced_p, 
		nr_seq_evento_p, 
		nm_usuario_p, 
		cd_procedimento_p, 
		ie_origem_proced_p, 
		nr_seq_proc_interno_p, 
		nr_seq_exame_p, 
		ie_regra_lanc_aut_p);
 
	if (ie_regra_lanc_aut_p = 'E') and (ie_consistencia_ativa_p = 'S') then 
		begin 
		nr_erro_w := consistir_prescr_procedimento( 
			nr_prescricao_p, nr_seq_proced_p, nm_usuario_p, cd_perfil_p, nr_erro_w);
		end;
	end if;
	end;
end if;
nr_erro_p	:= nr_erro_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lancto_prescr_proc_js ( nr_prescricao_p bigint, nr_seq_proced_p bigint, nr_seq_evento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, ie_regra_lanc_aut_p text, ie_consistencia_ativa_p text, cd_perfil_p bigint, nr_erro_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;

