-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_se_perm_pf_classif ( cd_funcao_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, ie_opcao_p text default 'S', ie_somente_pessoa_p text default 'N') RETURNS varchar AS $body$
DECLARE


qt_regra_w		bigint;
qt_regra_sem_classif_w	bigint;
ds_retorno_w		varchar(80)	:= 'S';
nr_seq_classif_w	bigint;
qt_perm_w		bigint;
nr_seq_classif_ww	bigint;
ds_classificacao_w	varchar(80);
ds_classif_retorno_w	varchar(80);
cd_perfil_w		integer;
ie_cursor_w		varchar(1) 	:= 'N';
qt_especialidade_w	bigint;
cd_especialidade_w	varchar(80);
ie_perm_espec_w		varchar(1);
nr_Seq_Classif_pf_W	bigint;
ds_classif_esp_ret_w	varchar(80);

C01 CURSOR FOR
	SELECT	nr_seq_classif,
		nr_sequencia
	from	pessoa_classif
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	((dt_referencia_p >= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = ''))
	and	((Dt_referencia_p <= dt_final_vigencia) or (coalesce(dt_final_vigencia::text, '') = ''))
	order by nr_seq_classif;


BEGIN

cd_perfil_w := Obter_perfil_Ativo;

select	count(*)
into STRICT	qt_regra_w
from	regra_funcao_classif_pf
where	cd_funcao	= cd_funcao_p
and	coalesce(cd_perfil,cd_perfil_w) 	= cd_perfil_w;

	open C01;
	loop
	fetch C01 into
		nr_seq_classif_w,
		nr_Seq_Classif_pf_W;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ie_cursor_w	:= 'S';

		select	max(c.ds_classificacao)
		into STRICT	ds_classificacao_w
		from	regra_funcao_classif_pf a,
			regra_classif_pf b,
			classif_pessoa c
		where	a.nr_sequencia		= b.nr_seq_regra
		and	a.cd_funcao		= cd_funcao_p
		and	coalesce(a.cd_perfil,cd_perfil_w) 		= cd_perfil_w
		and	c.nr_sequencia		= b.nr_seq_classif
		and	b.nr_seq_classif	= nr_seq_classif_w;

		if (ds_classificacao_w IS NOT NULL AND ds_classificacao_w::text <> '') then
			ds_retorno_w		:= 'N';
			nr_seq_classif_ww	:= nr_seq_classif_w;
			ds_classif_retorno_w	:= ds_classificacao_w;
			ds_classif_esp_ret_w	:= obter_desc_expressao(342697);--'Este paciente possui a classificação '||ds_classificacao_w;
		end if;
		end;
	end loop;
	close C01;

if (ds_retorno_w = 'S') and (ie_somente_pessoa_p = 'S') then
	select	count(*)
	into STRICT	qt_regra_w
	from	regra_funcao_classif_pf
	where	cd_funcao = cd_funcao_p;
	if (qt_regra_w	> 0) then
		open C01;
		loop
		fetch C01 into
			nr_seq_classif_w,
			nr_seq_classif_pf_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			ie_cursor_w	:= 'S';

			select	max(c.ds_classificacao)
			into STRICT	ds_classificacao_w
			from	regra_funcao_classif_pf a,
				regra_classif_pf b,
				classif_pessoa c
			where	a.nr_sequencia		= b.nr_seq_regra
			and	a.cd_funcao		= cd_funcao_p
			and	c.nr_sequencia		= b.nr_seq_classif
			and	b.nr_seq_classif	= nr_seq_classif_w;

			if (ds_classificacao_w IS NOT NULL AND ds_classificacao_w::text <> '') then
				ds_retorno_w		:= 'N';
				nr_seq_classif_ww	:= nr_seq_classif_w;
				ds_classif_retorno_w	:= ds_classificacao_w;
				ds_classif_esp_ret_w	:= obter_desc_expressao(342697);--'Este paciente possui a classificação '||ds_classificacao_w;
			end if;
			end;
		end loop;
		close C01;
	end if;
end if;

if (ie_cursor_w = 'N') then

	select	count(*)
	into STRICT	qt_regra_sem_classif_w
	from	regra_funcao_classif_pf
	where	cd_funcao = cd_funcao_p
	and	coalesce(cd_perfil,cd_perfil_w) 	= cd_perfil_w
	and	coalesce(ie_consiste_pf_sem_classif,'N') = 'S';

	if (qt_regra_sem_classif_w > 0) then
		ds_classif_retorno_w := obter_desc_expressao(342704);--'(Sem classificação vigente)';
	end if;

end if;

if (ie_opcao_p	= 'S') then
	ds_retorno_w	:= ds_retorno_w;
elsif (ie_opcao_p	= 'SEQ') then
	ds_retorno_w	:= nr_seq_classif_ww;
elsif (ie_opcao_p	= 'DS') then
	ds_retorno_w	:= ds_classif_retorno_w;
elsif (ie_opcao_p	= 'DCE') then
	ds_Retorno_w	:= ds_classif_esp_ret_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_se_perm_pf_classif ( cd_funcao_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, ie_opcao_p text default 'S', ie_somente_pessoa_p text default 'N') FROM PUBLIC;

