-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_wjpanel_ultimo_nivel (nr_seq_objeto_p bigint) RETURNS varchar AS $body$
DECLARE


ie_ultimo_nivel_w varchar(1) := 'S';


BEGIN
if (nr_seq_objeto_p IS NOT NULL AND nr_seq_objeto_p::text <> '') then
	begin
	select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_ultimo_nivel_w
	from	dic_objeto
	where	nr_seq_obj_sup = nr_seq_objeto_p
	and	ie_tipo_objeto = 'P';
	end;
end if;
return ie_ultimo_nivel_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_wjpanel_ultimo_nivel (nr_seq_objeto_p bigint) FROM PUBLIC;
