-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_tit_desdobrados (cd_pessoa_p bigint, tp_pessoa_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE
 vl_desdobrado double precision;

BEGIN
	select coalesce(sum(a.vl_titulo),0)
	into STRICT vl_desdobrado
	from	titulo_pagar a
	where	a.ie_situacao = 'D'
		and ((tp_pessoa_p = 0
		     and CASE WHEN tp_pessoa_p=0 THEN  null  ELSE cd_pessoa_p (END IS NOT NULL AND END::text <> '')
		     and exists (SELECT	1
				 from	w_ficha_financ_consulta x
				 where	x.nr_titulo_cp = a.nr_titulo
				 and	x.cd_cgc = CASE WHEN tp_pessoa_p=0 THEN  null  ELSE cd_pessoa_p END
				 and x.nm_usuario = nm_usuario_p))
		or (tp_pessoa_p = 0
		    and CASE WHEN tp_pessoa_p=0 THEN  cd_pessoa_p  ELSE null (END IS NOT NULL AND END::text <> '')
		    and exists (select	1
				 from	w_ficha_financ_consulta x
				 where	x.nr_titulo_cp = a.nr_titulo
				 and	x.cd_pessoa_fisica = CASE WHEN tp_pessoa_p=0 THEN  cd_pessoa_p  ELSE null END 
				 and	x.nm_usuario = nm_usuario_p))
		or (tp_pessoa_p <> 0
		    and exists (select	1
				 from	w_ficha_financ_consulta x
				 where	x.nr_titulo_cp = a.nr_titulo
				 and	x.cd_cgc = cd_pessoa_p
				 and	x.nm_usuario = nm_usuario_p)));
	return vl_desdobrado;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_tit_desdobrados (cd_pessoa_p bigint, tp_pessoa_p bigint, nm_usuario_p text) FROM PUBLIC;

