-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sac_obter_se_classif_hist_lib ( nr_seq_classif_hist_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_liberado_w		varchar(1);
qt_registros_w		bigint;
qt_regras_w		bigint;
cd_perfil_ativo_w	bigint;


BEGIN

ie_liberado_w:= 'S';

/* Verificar se existe alguma regra */

select	count(*)
into STRICT		qt_regras_w
from 		sac_classif_hist	a,
			sac_classif_hist_lib	b
where 	a.nr_sequencia = b.nr_seq_classif_hist
and 		a.cd_estabelecimento = cd_estabelecimento_p
and 		b.nr_seq_classif_hist	= nr_seq_classif_hist_p
and		coalesce(a.ie_situacao,'A') = 'A';


if (qt_regras_w > 0) then

	ie_liberado_w			:= 'N';
	cd_perfil_ativo_w		:= coalesce(obter_perfil_ativo,0);

	select	count(*)
	into STRICT		qt_registros_w
	from 		sac_classif_hist		a,
				sac_classif_hist_lib	b
	where 	a.nr_sequencia = b.nr_seq_classif_hist
	and 		a.cd_estabelecimento = cd_estabelecimento_p
	and 		b.nr_seq_classif_hist	= nr_seq_classif_hist_p
	and 		coalesce(b.nm_usuario_lib,nm_usuario_p) = nm_usuario_p
	and		coalesce(b.cd_perfil,cd_perfil_ativo_w) = cd_perfil_ativo_w
	and		coalesce(a.ie_situacao,'A')					= 'A';

	if (qt_registros_w > 0) then
		ie_liberado_w:= 'S';
	end if;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sac_obter_se_classif_hist_lib ( nr_seq_classif_hist_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

