-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_codigo_classif ( cd_empresa_p bigint, cd_classificacao_p text) RETURNS varchar AS $body$
DECLARE


cd_conta_contabil_w		varchar(20);
nr_seq_classif_w			bigint;


BEGIN

if (cd_classificacao_p IS NOT NULL AND cd_classificacao_p::text <> '') and (cd_empresa_p IS NOT NULL AND cd_empresa_p::text <> '') then

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_classif_w
	from	conta_contabil b,
		conta_contabil_classif a
	where	a.cd_conta_contabil	= b.cd_conta_contabil
	and	a.cd_classificacao		= cd_classificacao_p
	and	b.cd_empresa		= cd_empresa_p
	and	a.dt_inicio_vigencia 	<= clock_timestamp()
	and	coalesce(a.dt_fim_vigencia, clock_timestamp()) >= clock_timestamp();

	if (coalesce(nr_seq_classif_w::text, '') = '') then
		begin
		select	max(cd_conta_contabil)
		into STRICT	cd_conta_contabil_w
		from	conta_contabil
		where	cd_classificacao = cd_classificacao_p
		and	cd_empresa	= cd_empresa_p;
		end;
	else
		select	cd_conta_contabil
		into STRICT	cd_conta_contabil_w
		from	conta_contabil_classif
		where	nr_sequencia	= nr_seq_classif_w;
	end if;

end if;

return cd_conta_contabil_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_codigo_classif ( cd_empresa_p bigint, cd_classificacao_p text) FROM PUBLIC;
