-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_regra_permissao (nr_seq_pac_reab_p bigint, cd_perfil_p bigint, ie_permite_tipo_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_regra_w			bigint;
nr_seq_tipo_tratamento_w	bigint;
ie_perm_regra_w			varchar(1);
qt_trat_pac_w			bigint;
qt_sem_trat_pac_w		bigint;
qt_total_trat_pac_w		bigint := 0;

ie_permite_w			varchar(1) := 'S';

C01 CURSOR FOR
	SELECT CASE WHEN ie_permite_tipo_p='A' THEN coalesce(ie_permite_alterar,'S') WHEN ie_permite_tipo_p='V' THEN coalesce(ie_permite_visualizar,'S') END ,
		nr_seq_tipo_tratamento
	from	rp_regra_perm_perfil_trat
	where	nr_seq_regra_perfil = nr_seq_regra_w;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_regra_w
from	rp_regra_permissao_perfil
where	cd_perfil = cd_perfil_p
and	coalesce(ie_situacao,'A') = 'A';

if (nr_seq_regra_w > 0) then

	open C01;
	loop
	fetch C01 into
		ie_perm_regra_w,
		nr_seq_tipo_tratamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	count(*)
		into STRICT	qt_trat_pac_w
		from	rp_tratamento
		where	nr_seq_pac_reav 	= nr_seq_pac_reab_p
		and	nr_seq_tipo_tratamento	= nr_seq_tipo_tratamento_w
		and	coalesce(dt_fim_tratamento::text, '') = '';

		qt_total_trat_pac_w :=  qt_total_trat_pac_w + qt_trat_pac_w;

		if (ie_perm_regra_w = 'N') and (qt_trat_pac_w > 0) then
			ie_permite_w	:= 'N';
		end if;

		end;
	end loop;
	close C01;

	select	count(*)
	into STRICT	qt_sem_trat_pac_w
	from	rp_tratamento
	where	nr_seq_pac_reav 	= nr_seq_pac_reab_p;

	if (qt_sem_trat_pac_w = 0) then
		ie_permite_w	:= 'S';
	elsif (qt_total_trat_pac_w = 0) then
		ie_permite_w	:= 'N';
	end if;

end if;


return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_regra_permissao (nr_seq_pac_reab_p bigint, cd_perfil_p bigint, ie_permite_tipo_p text) FROM PUBLIC;

