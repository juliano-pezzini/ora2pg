-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_obter_se_pront_armz (nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

ds_status_w	varchar(255);

BEGIN
select	max(substr(obter_valor_dominio(1220,ie_status),1,255))
into STRICT	ds_status_w
from	same_prontuario
where	ie_status not in (1,10,6)
and	((nr_atendimento = nr_atendimento_p) or ((coalesce(nr_atendimento_p,0) = 0) and (cd_pessoa_fisica = cd_pessoa_fisica_p)));

ds_retorno_p := ds_status_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_obter_se_pront_armz (nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_retorno_p INOUT text) FROM PUBLIC;
