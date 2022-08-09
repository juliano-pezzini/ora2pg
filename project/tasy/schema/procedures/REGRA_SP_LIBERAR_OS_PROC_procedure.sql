-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE regra_sp_liberar_os_proc (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

UPDATE OS_PENDENTE_SP SET DT_LIBERACAO = clock_timestamp(), NM_USUARIO = nm_usuario_p WHERE NR_SEQUENCIA = nr_sequencia_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE regra_sp_liberar_os_proc (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
