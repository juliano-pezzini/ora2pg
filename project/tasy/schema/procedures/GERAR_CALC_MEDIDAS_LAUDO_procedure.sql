-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_calc_medidas_laudo ( nr_sequencia_p bigint, ie_atualizar_medida text, nm_usuario_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_atualizar_medida IS NOT NULL AND ie_atualizar_medida::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	CALL pa_gerar_medida_laudo(nr_sequencia_p,nm_usuario_p);
		 
	if (ie_atualizar_medida 	= 'S') then 
		begin 
		CALL calcular_valores_medida_laudo(nr_sequencia_p,nm_usuario_p);
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_calc_medidas_laudo ( nr_sequencia_p bigint, ie_atualizar_medida text, nm_usuario_p text) FROM PUBLIC;
