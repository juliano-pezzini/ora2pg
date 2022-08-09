-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_ajust_cpf_ident_benef (nm_usuario_p text) AS $body$
DECLARE


vl_parametro_w	varchar(255);


BEGIN
begin
	select	vl_parametro
	into STRICT	vl_parametro_w
	from	funcao_parametro
	where	nr_sequencia	= 3
	and	cd_funcao	= 1294;
exception
when others then
	vl_parametro_w	:= null;
end;

if (vl_parametro_w IS NOT NULL AND vl_parametro_w::text <> '') then
	if (vl_parametro_w	= 'N') then
		update	funcao_parametro
		set	vl_parametro	= 0
		where	nr_sequencia	= 3
		and	cd_funcao	= 1294;
	elsif (vl_parametro_w	= 'S') then
		update	funcao_parametro
		set	vl_parametro	= ''
		where	nr_sequencia	= 3
		and	cd_funcao	= 1294;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_ajust_cpf_ident_benef (nm_usuario_p text) FROM PUBLIC;
