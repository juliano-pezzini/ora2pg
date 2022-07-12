-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_apresenta_evento (nr_seq_evento_p bigint, cd_funcao_ativa_p bigint) RETURNS varchar AS $body$
DECLARE


ie_aprensenta_w varchar(1);
ie_funcao_registro_w varchar(5);

BEGIN

begin
  select CASE WHEN coalesce(ie_funcao_registro::text, '') = '' THEN  'N' WHEN ie_funcao_registro='S' THEN  'S' END
  into STRICT ie_funcao_registro_w
  from qua_evento
  where nr_sequencia = nr_seq_evento_p;

exception
	when no_data_found then
	begin
		ie_funcao_registro_w	:= 'N';
	end;
end;

if (ie_funcao_registro_w = 'S') then
  if (cd_funcao_ativa_p = obter_funcao_ativa) then
    ie_aprensenta_w := 'S';
  else
    ie_aprensenta_w := 'N';
  end if;
else
  ie_aprensenta_w := 'S';
end if;

RETURN ie_aprensenta_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_apresenta_evento (nr_seq_evento_p bigint, cd_funcao_ativa_p bigint) FROM PUBLIC;

