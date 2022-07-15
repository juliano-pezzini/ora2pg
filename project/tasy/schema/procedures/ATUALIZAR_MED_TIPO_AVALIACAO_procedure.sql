-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_med_tipo_avaliacao ( nr_sequencia_p bigint, ie_opcao_p text) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then

	if (ie_opcao_p = 'A') then
		update	med_tipo_avaliacao
		set	dt_aprovacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 'D') then
		update	med_tipo_avaliacao
		set	dt_aprovacao  = NULL
		where	nr_sequencia = nr_sequencia_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_med_tipo_avaliacao ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

