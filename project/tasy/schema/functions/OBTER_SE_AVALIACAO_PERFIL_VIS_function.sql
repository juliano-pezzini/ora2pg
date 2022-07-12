-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_avaliacao_perfil_vis (cd_perfil_p bigint, nr_seq_avaliacao_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_perfil_w			varchar(01) := 'S';
qt_perfil_w			bigint;
cd_estabelecimento_w		bigint;
nm_usuario_w			varchar(15);
ie_tipo_evolucao_w		varchar(15);
nr_seq_agrupamento_w		bigint;

C01 CURSOR FOR
	SELECT	coalesce(IE_PERMITE_VISUALIZAR,'S')
	from	med_perfil_avaliacao
	where	nr_seq_tipo_aval	= nr_seq_avaliacao_p
	and	coalesce(cd_perfil,cd_perfil_p)		= cd_perfil_p
	and	coalesce(cd_setor_atendimento,cd_setor_atendimento_p) = cd_setor_atendimento_p
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)	= cd_estabelecimento_w
	and	coalesce(ie_tipo_evolucao,ie_tipo_evolucao_w) = ie_tipo_evolucao_w
	order by coalesce(cd_perfil,0),
			coalesce(cd_setor_atendimento,0),
			coalesce(cd_estabelecimento,0),
			coalesce(ie_tipo_evolucao,0);

BEGIN

select	count(*)
into STRICT	qt_perfil_w
from	med_perfil_avaliacao
where	nr_seq_tipo_aval	= nr_seq_avaliacao_p;
cd_estabelecimento_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;

select	coalesce(max(ie_tipo_evolucao),'xpto')
into STRICT	ie_tipo_evolucao_w
from 	usuario
where	nm_usuario = nm_usuario_w;

select	coalesce(max(nr_seq_agrupamento),0)
into STRICT	nr_seq_agrupamento_w
from 	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p;

if (qt_perfil_w > 0) then
	begin
	ie_perfil_w	:= 'N';
	open C01;
	loop
	fetch C01 into
		ie_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	end;
end if;

return	ie_perfil_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_avaliacao_perfil_vis (cd_perfil_p bigint, nr_seq_avaliacao_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;
