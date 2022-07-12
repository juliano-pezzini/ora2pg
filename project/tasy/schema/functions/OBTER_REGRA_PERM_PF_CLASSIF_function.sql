-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_perm_pf_classif ( cd_funcao_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


qt_regra_w		bigint;
ds_retorno_w		varchar(80)	:= '';
nr_seq_classif_w	bigint;
qt_perm_w		bigint;
nr_seq_classif_ww	bigint;
ds_classificacao_w	varchar(80)	:= '';

C01 CURSOR FOR
	SELECT	nr_seq_classif
	from	pessoa_classif
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	((trunc(dt_referencia_p) >= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = ''))
	and	((trunc(dt_referencia_p) <= dt_final_vigencia) or (coalesce(dt_final_vigencia::text, '') = ''))
	order by nr_seq_classif;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	regra_funcao_classif_pf
where	cd_funcao	= cd_funcao_p
and	coalesce(cd_agenda, cd_agenda_p) 	= cd_agenda_p;

if (qt_regra_w	> 0) then

	open C01;
	loop
	fetch C01 into
		nr_seq_classif_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	max(c.ds_classificacao)
		into STRICT	ds_classificacao_w
		from	regra_funcao_classif_pf a,
			regra_classif_pf b,
			classif_pessoa c
		where	a.nr_sequencia		= b.nr_seq_regra
		and	a.cd_funcao		= cd_funcao_p
		and	b.nr_seq_classif	= c.nr_sequencia
		and	((a.cd_agenda		= cd_agenda_p) or (coalesce(a.cd_agenda::text, '') = ''))
		and	b.nr_seq_classif	= nr_seq_classif_w;

		if (ds_classificacao_w IS NOT NULL AND ds_classificacao_w::text <> '') then
			ds_retorno_w	:= ds_classificacao_w;
		end if;
		ds_classificacao_w	:= '';
		end;
	end loop;
	close C01;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_perm_pf_classif ( cd_funcao_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp) FROM PUBLIC;
