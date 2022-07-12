-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cta_obter_se_estagio_lib ( nr_seq_estagio_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'S';
qt_regra_lib_estagio_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_lib_estagio_w
from	cta_liberacao_estagio
where	nr_seq_estagio = nr_seq_estagio_p;

if (qt_regra_lib_estagio_w > 0) then

	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from	cta_liberacao_estagio
	where	nr_seq_estagio = nr_seq_estagio_p
	and	coalesce(nm_usuario_regra, nm_usuario_p) = nm_usuario_p
	and	coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
	and  	((coalesce(nr_seq_tipo_p,0) = 0) or (coalesce(nr_seq_tipo, coalesce(nr_seq_tipo_p,0)) = coalesce(nr_seq_tipo_p,0)))
	and	ie_situacao = 'A';

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cta_obter_se_estagio_lib ( nr_seq_estagio_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_seq_tipo_p bigint) FROM PUBLIC;

