-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_val_medida_laudo_normais ( nr_seq_laudo_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_laudo_p IS NOT NULL AND nr_seq_laudo_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	CALL atualizar_com_valores_normais(nr_seq_laudo_p, nm_usuario_p);
	CALL calcular_valores_medida_laudo(nr_seq_laudo_p, nm_usuario_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_val_medida_laudo_normais ( nr_seq_laudo_p bigint, nm_usuario_p text) FROM PUBLIC;
