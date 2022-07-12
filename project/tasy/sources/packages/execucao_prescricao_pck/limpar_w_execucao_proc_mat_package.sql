-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE execucao_prescricao_pck.limpar_w_execucao_proc_mat ( nr_atendimento_p bigint, cd_procedimento_p bigint, cd_material_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) AS $body$
BEGIN
	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		delete	from w_execucao_proc_mat
		where	nr_atendimento = nr_atendimento_p
		and		nm_usuario = nm_usuario_p;
		commit;
	end if;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE execucao_prescricao_pck.limpar_w_execucao_proc_mat ( nr_atendimento_p bigint, cd_procedimento_p bigint, cd_material_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) FROM PUBLIC;
