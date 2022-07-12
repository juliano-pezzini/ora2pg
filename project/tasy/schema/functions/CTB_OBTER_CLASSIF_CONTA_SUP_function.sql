-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_classif_conta_sup ( cd_classif_conta_p text, dt_vigencia_p timestamp, cd_empresa_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w		integer;
cd_classif_sup_w	varchar(40);
cd_classif_w		varchar(40);
k			integer;
dt_vigencia_w		timestamp;
nr_seq_classif_w	bigint;
ie_separador_conta_w	empresa.ie_sep_classif_conta_ctb%type;


BEGIN

ie_separador_conta_w := philips_contabil_pck.get_separador_conta;

cd_classif_w		:= cd_classif_conta_p;
dt_vigencia_w		:= trunc(dt_vigencia_p, 'dd');

select	max(a.nr_sequencia)
into STRICT	nr_seq_classif_w
from	conta_contabil b,
	conta_contabil_classif a
where	a.cd_conta_contabil			= b.cd_conta_contabil
and	a.cd_classificacao			= cd_classif_w
and	b.cd_empresa				= cd_empresa_p
and	a.dt_inicio_vigencia			<= coalesce(dt_vigencia_w, clock_timestamp())
and	coalesce(a.dt_fim_vigencia, clock_timestamp()) 	>= coalesce(dt_vigencia_w, clock_timestamp());

if (coalesce(nr_seq_classif_w::text, '') = '') then
	begin
	select	coalesce(max(cd_classif_superior), 'X')
	into STRICT	cd_classif_sup_w
	from	conta_contabil
	where	substr(obter_se_conta_vigente2(cd_conta_contabil, dt_inicio_vigencia, dt_fim_vigencia, dt_vigencia_w),1,1) = 'S'
	and	(cd_classif_superior IS NOT NULL AND cd_classif_superior::text <> '')
	and	cd_classificacao = cd_classif_w
	and	cd_empresa = cd_empresa_p;
	end;
else	
	begin
	/* possui regra de classificacao - verifica se tem conta superior informada */

	
	select	coalesce(max(cd_classif_superior),'')
	into STRICT	cd_classif_sup_w
	from	conta_contabil_classif
	where	nr_sequencia	= nr_seq_classif_w;

	end;
end if;
/*se encontrar a conta superior no cadastro, ja retorna a mesma e nao faz mais nenhuma rotina*/
if (cd_classif_sup_w = 'X') then
	begin
	select	instr(cd_classif_w, ie_separador_conta_w, -1)
	into STRICT	k
	;

	if (k = 0) then
		cd_classif_sup_w	:= null;
	else
		cd_classif_sup_w	:= substr(cd_classif_w,1,k -1);
	end if;

	if (k > 0) then
		select	count(*)
		into STRICT	qt_existe_w
		from	conta_contabil
		where	cd_classificacao = cd_classif_sup_w
		and	substr(obter_se_conta_vigente2(cd_conta_contabil, dt_inicio_vigencia, dt_fim_vigencia, dt_vigencia_w),1,1) = 'S'
		and	cd_empresa = cd_empresa_p;

		if (qt_existe_w = 0) then
			select	ctb_obter_classif_conta_sup(cd_classif_sup_w, dt_vigencia_w, cd_empresa_p)
			into STRICT	cd_classif_sup_w
			;
		end if;
	end if;
	end;
end if;

return	cd_classif_sup_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_classif_conta_sup ( cd_classif_conta_p text, dt_vigencia_p timestamp, cd_empresa_p bigint) FROM PUBLIC;

