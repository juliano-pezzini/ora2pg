-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_estado_nutricional (pr_result_adeq_p bigint) RETURNS varchar AS $body$
DECLARE

ds_result_w	varchar(25);
EXEC_w      varchar(200);

BEGIN
  begin
    EXEC_w := 'CALL OBTER_DS_ESTADO_NUTRICIONAL_MD(:1) INTO :result';

    EXECUTE EXEC_w USING IN pr_result_adeq_p,
                                   OUT ds_result_w;
  exception
    when others then
          ds_result_w := null;
  end;

  return ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_estado_nutricional (pr_result_adeq_p bigint) FROM PUBLIC;
