-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_comunic_benif ( nr_sequencia_p bigint ) AS $body$
BEGIN

update tiss_comunic_benif set ie_status = 'E', nm_usuario =  wheb_usuario_pck.get_nm_usuario, dt_atualizacao = clock_timestamp() where nr_sequencia = nr_sequencia_p;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_comunic_benif ( nr_sequencia_p bigint ) FROM PUBLIC;

