-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_caixa_saldo_diario ( nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update  caixa_saldo_diario
	set     dt_fechamento  = NULL,
        	nm_usuario_fechamento  = NULL,
        	nm_usuario = nm_usuario_p,
        	dt_atualizacao = clock_timestamp()
	where   nr_sequencia = nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_caixa_saldo_diario ( nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;

