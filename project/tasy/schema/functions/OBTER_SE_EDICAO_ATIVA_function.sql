-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_edicao_ativa ( cd_edicao_amb_p bigint) RETURNS varchar AS $body$
DECLARE


ie_situacao_w	varchar(1):= 'I';


BEGIN

select 	coalesce(max(ie_situacao),'I')
into STRICT	ie_situacao_w
from 	edicao_amb
where 	cd_edicao_amb = cd_edicao_amb_p;

return	ie_situacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_edicao_ativa ( cd_edicao_amb_p bigint) FROM PUBLIC;
