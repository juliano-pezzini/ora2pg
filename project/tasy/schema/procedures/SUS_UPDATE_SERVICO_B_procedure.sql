-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_update_servico_b (ds_servico_p text, cd_servico_p bigint, nm_usuario_p text) AS $body$
BEGIN

update  sus_servico
set     ds_servico     = ds_servico_p,
	ie_situacao    = 'A',
	dt_atualizacao = clock_timestamp(),
	nm_usuario     = nm_usuario_p
where   cd_servico     = cd_servico_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_update_servico_b (ds_servico_p text, cd_servico_p bigint, nm_usuario_p text) FROM PUBLIC;
