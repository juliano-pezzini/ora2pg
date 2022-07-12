-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_cd_sang_isbt_doacao ( nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE

cd_sangue_isbt_w	varchar(2);

C01 CURSOR FOR
	SELECT	a.cd_sangue_isbt
	from	san_grupo_sanguineo_isbt a,
		san_doacao b,
		pessoa_fisica c
	where	b.cd_pessoa_fisica			= c.cd_pessoa_fisica
	and	coalesce(a.nr_seq_tipo_doacao,b.nr_seq_tipo)	= b.nr_seq_tipo
	and	coalesce(a.ie_tipo_sangue,c.ie_tipo_sangue)	= c.ie_tipo_sangue
	and	coalesce(a.ie_fator_rh,c.ie_fator_rh)	= c.ie_fator_rh
	and	b.nr_sequencia				= nr_seq_doacao_p
	order by a.nr_seq_tipo_doacao desc, a.ie_fator_rh desc, a.ie_tipo_sangue desc;


BEGIN
if (coalesce(nr_seq_doacao_p,0) > 0 ) then

	open C01;
	loop
	fetch C01 into
		cd_sangue_isbt_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		null;
		end;
	end loop;
	close C01;

end if;

return	cd_sangue_isbt_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_cd_sang_isbt_doacao ( nr_seq_doacao_p bigint) FROM PUBLIC;
