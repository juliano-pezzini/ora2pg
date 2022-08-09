-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_impressao_agrup_lote ( nm_usuario_p text, nr_sequencia_p bigint, ie_impressao_p text) AS $body$
BEGIN

if (ie_impressao_p = 'I') then
	update  material_lote_fornec_agrup
        set	dt_impressao = clock_timestamp(),
		nm_usuario_impressao = nm_usuario_p
	where   nr_sequencia = nr_sequencia_p;
elsif (ie_impressao_p = 'R') then
	update  material_lote_fornec_agrup
        set	dt_reimpressao = clock_timestamp(),
		nm_usuario_reimpressao = nm_usuario_p
	where   nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_impressao_agrup_lote ( nm_usuario_p text, nr_sequencia_p bigint, ie_impressao_p text) FROM PUBLIC;
