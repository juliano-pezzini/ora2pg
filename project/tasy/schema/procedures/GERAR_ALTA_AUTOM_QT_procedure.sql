-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alta_autom_qt ( dt_execucao_p timestamp, nm_usuario_p text, nr_dias_p bigint, nr_aux_1 bigint, nr_aux_2 bigint) AS $body$
BEGIN

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alta_autom_qt ( dt_execucao_p timestamp, nm_usuario_p text, nr_dias_p bigint, nr_aux_1 bigint, nr_aux_2 bigint) FROM PUBLIC;

