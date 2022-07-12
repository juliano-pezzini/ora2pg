-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_cobertura ( nr_seq_cobertura_p bigint, ie_tipo_cobertura_p text) RETURNS varchar AS $body$
DECLARE


ds_cobertura_w			varchar(255);
nr_seq_sca_w			bigint;


BEGIN

if	((ie_tipo_cobertura_p = 'C')  or (ie_tipo_cobertura_p = 'P')) then
	select	max(b.ds_cobertura)
	into STRICT	ds_cobertura_w
	from	pls_tipo_cobertura 	b,
		pls_cobertura 		a
	where	a.nr_seq_tipo_cobertura	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_cobertura_p;
elsif (ie_tipo_cobertura_p = 'R') then
	select	substr(ds_rol_grupo,1,255)
	into STRICT	ds_cobertura_w
	from	pls_rol_grupo_proc	a
	where	a.nr_sequencia		= nr_seq_cobertura_p;
elsif (ie_tipo_cobertura_p = 'S') then
	select	max(b.ds_plano)
	into STRICT	ds_cobertura_w
	from	pls_plano	b,
		pls_cobertura	a
	where	a.nr_sequencia	= nr_seq_cobertura_p
	and	a.nr_seq_plano	= b.nr_sequencia;
end if;

return	ds_cobertura_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_cobertura ( nr_seq_cobertura_p bigint, ie_tipo_cobertura_p text) FROM PUBLIC;

