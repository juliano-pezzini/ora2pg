-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_classif_rec (nr_seq_classif_rec_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text default null) RETURNS varchar AS $body$
DECLARE


ie_exibir_w		varchar(10) := 'S';
qt_reg_w		integer;

c01 CURSOR FOR
SELECT	coalesce(ie_exibir,'N')
from	classif_recomendacao_regra
where	nr_seq_classificacao					= nr_seq_classif_rec_p
and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0))	= coalesce(cd_setor_atendimento_p,coalesce(cd_setor_atendimento,0))
and	coalesce(cd_perfil,coalesce(cd_perfil_p,0))				= coalesce(cd_perfil_p,coalesce(cd_perfil,0))
--and	((cd_estabelecimento is null) or (cd_estabelecimento = cd_estabelecimento_p))
and	((coalesce(cd_estab::text, '') = '') or (cd_estab = cd_estabelecimento_p))
and	((coalesce(cd_pessoa_fisica::text, '') = '') or (cd_pessoa_fisica = obter_pf_usuario(nm_usuario_p,'C')))
order by coalesce(cd_pessoa_fisica,0),
	coalesce(cd_perfil,0),
	coalesce(cd_setor_atendimento,0);


BEGIN

if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
  ie_exibir_w := 'N';
end if;

select	count(*)
into STRICT	qt_reg_w
from	classif_recomendacao_regra
where	nr_seq_classificacao	= nr_seq_classif_rec_p;

if (qt_reg_w > 0) then
	ie_exibir_w	:= 'N';
	open C01;
	loop
	fetch C01 into	
		ie_exibir_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		ie_exibir_w	:= ie_exibir_w;
	end loop;
	close C01;

end if;

return ie_exibir_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_classif_rec (nr_seq_classif_rec_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text default null) FROM PUBLIC;

