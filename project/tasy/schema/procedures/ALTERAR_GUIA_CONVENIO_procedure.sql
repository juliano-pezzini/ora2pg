-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_guia_convenio ( cd_autorizacao_conv_p text, nr_interno_conta_p bigint) AS $body$
BEGIN

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
update	convenio_retorno_item
set	cd_autorizacao_conv = cd_autorizacao_conv_p
where	nr_interno_conta = nr_interno_conta_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_guia_convenio ( cd_autorizacao_conv_p text, nr_interno_conta_p bigint) FROM PUBLIC;
