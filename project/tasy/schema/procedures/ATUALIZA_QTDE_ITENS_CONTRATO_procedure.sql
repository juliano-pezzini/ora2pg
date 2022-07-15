-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_qtde_itens_contrato ( nm_usuario_p text, nr_sequencia_p bigint, qt_contrato_p bigint) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) <> 0) then
	update 	w_itens_contrato_selec
	set   	qt_contrato 		= qt_contrato_p,
		nm_usuario_nrec		= nm_usuario_p,
		dt_atualizacao_nrec	= clock_timestamp()
	where 	nr_sequencia 		= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_qtde_itens_contrato ( nm_usuario_p text, nr_sequencia_p bigint, qt_contrato_p bigint) FROM PUBLIC;

