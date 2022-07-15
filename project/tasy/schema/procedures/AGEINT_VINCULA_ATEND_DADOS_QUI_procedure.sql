-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_vincula_atend_dados_qui ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_sequencia_p,0) > 0)  then

   update	agenda_quimio
   set		nr_atendimento  = nr_atendimento_p,
		dt_atualizacao  = clock_timestamp(),
		nm_usuario	= coalesce(nm_usuario_p,obter_usuario_ativo)
   where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_vincula_atend_dados_qui ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

