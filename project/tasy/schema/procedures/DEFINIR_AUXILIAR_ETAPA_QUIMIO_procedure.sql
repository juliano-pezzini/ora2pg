-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_auxiliar_etapa_quimio ( nr_seq_etapa_prod_p bigint, cd_auxiliar_p text) AS $body$
BEGIN

update	can_ordem_prod
set	cd_auxiliar	= cd_auxiliar_p
where	nr_seq_etapa_prod	= nr_seq_etapa_prod_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_auxiliar_etapa_quimio ( nr_seq_etapa_prod_p bigint, cd_auxiliar_p text) FROM PUBLIC;

