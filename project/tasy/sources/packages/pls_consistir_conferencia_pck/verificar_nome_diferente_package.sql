-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_consistir_conferencia_pck.verificar_nome_diferente ( nm_conferencia_p text, nm_sib_segurado_p text) RETURNS boolean AS $body$
DECLARE


qt_apostrofo_w	bigint;


BEGIN

if (upper(nm_conferencia_p) = upper(nm_sib_segurado_p)) then
	return false;
else
	select	count(1)
	into STRICT	qt_apostrofo_w
	from (SELECT	coalesce(nm_sib_segurado_p,'X') nm_sib_segurado
		) alias2
	where	nm_sib_segurado like '%'||chr(39)||'%';

	if (qt_apostrofo_w > 0) then
		if	((upper(nm_conferencia_p) = upper(replace(nm_sib_segurado_p, chr(39), ''))) or (upper(nm_conferencia_p) = upper(replace(nm_sib_segurado_p, chr(39), ' ')))) then
			return false;
		end if;
	end if;
end if;

return true;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_consistir_conferencia_pck.verificar_nome_diferente ( nm_conferencia_p text, nm_sib_segurado_p text) FROM PUBLIC;
