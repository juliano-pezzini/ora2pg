-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_atual_data_imp_item_extra ( nr_seq_serv_dia_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	nut_item_extra
set	dt_impressao = clock_timestamp(),
	nm_usuario_impressao = nm_usuario_p
where	nr_seq_servico = nr_seq_serv_dia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_atual_data_imp_item_extra ( nr_seq_serv_dia_p bigint, nm_usuario_p text) FROM PUBLIC;

