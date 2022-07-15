-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cid_principal (nr_atendimento_p bigint, dt_diagnostico_p timestamp) AS $body$
BEGIN

update 	diagnostico_doenca
set 	ie_classificacao_doenca = 'S'
where 	nr_atendimento = nr_atendimento_p
and 	ie_classificacao_doenca = 'P'
and		dt_diagnostico = dt_diagnostico_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cid_principal (nr_atendimento_p bigint, dt_diagnostico_p timestamp) FROM PUBLIC;

