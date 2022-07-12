-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_se_exibe_alergia ( nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


cd_perfil_w		bigint;
ie_permite_w	varchar(10)		:= 'S';
qt_reg_w		bigint;

C01 CURSOR FOR
	SELECT	coalesce(IE_PERMITE_VISUALIZAR,'S')
	from	TIPO_ALERGIA_REGRA
	where	NR_SEQ_TIPO_ALERGIA					= nr_seq_tipo_p
	and	coalesce(cd_perfil, 		coalesce(cd_perfil_w,0)) 		= coalesce(cd_perfil_w,0)
	order by coalesce(cd_perfil, 0);


BEGIN
if (nr_seq_tipo_p IS NOT NULL AND nr_seq_tipo_p::text <> '') then
	cd_perfil_w	:= obter_perfil_ativo;


	select	count(*)
	into STRICT	qt_reg_w
	from	TIPO_ALERGIA_REGRA
	where	NR_SEQ_TIPO_ALERGIA	= nr_seq_tipo_p;

	if (qt_reg_w	> 0) then
		begin
		/*
		select	count(*)
		into	qt_evolucao_w
		from	tipo_evolucao_acesso
		where	cd_tipo_evolucao 					= cd_tipo_evolucao_p
		and	nvl(cd_pessoa_fisica,	nvl(cd_pessoa_fisica_p,0))	= nvl(cd_pessoa_fisica_p,0)
		and	nvl(cd_perfil, 		nvl(cd_perfil_w,0)) 		= nvl(cd_perfil_w,0);*/
		ie_permite_w	:= 'N';
		open C01;
		loop
		fetch C01 into
			ie_permite_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		end loop;
		close C01;

		ie_permite_w	:= coalesce(ie_permite_w,'N');
		end;
	else
		ie_permite_w	:= 'S';
	end if;
end if;


return ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_se_exibe_alergia ( nr_seq_tipo_p bigint) FROM PUBLIC;

