-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE realizar_procedimento_previsto ( nr_prescricao_p bigint, nr_cirurgia_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	CALL realizar_proc_previstos(nr_cirurgia_p, nr_prescricao_p,nm_usuario_p, 'S');
	
	CALL executar_taxa_equipamento(nr_cirurgia_p, nm_usuario_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE realizar_procedimento_previsto ( nr_prescricao_p bigint, nr_cirurgia_p bigint, nm_usuario_p text) FROM PUBLIC;

