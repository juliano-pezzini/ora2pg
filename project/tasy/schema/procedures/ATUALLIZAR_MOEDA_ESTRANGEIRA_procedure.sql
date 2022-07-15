-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atuallizar_moeda_estrangeira ( vl_recebimento_p bigint, cd_moeda_p bigint, vl_moeda_original_p bigint, tx_cambial_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

	if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
		begin
			update convenio_receb set vl_recebimento    = vl_recebimento_p,
						  cd_moeda	    = cd_moeda_p,
						  vl_moeda_original = vl_moeda_original_p,
						  tx_cambial 	    = tx_cambial_p
			where nr_sequencia = nr_sequencia_p;
		end;
	end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atuallizar_moeda_estrangeira ( vl_recebimento_p bigint, cd_moeda_p bigint, vl_moeda_original_p bigint, tx_cambial_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

