-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_convenio_lib ( cd_classif_atend_p bigint, cd_classif_conv_p bigint, cd_convenio_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1) := 'S';
qt_existe_lib_w			integer;


BEGIN


select	count(*)
into STRICT	qt_existe_lib_w
from	CLASSIFICACAO_LIB_CONVENIO
where	nr_Seq_classif_atend	=	cd_classif_atend_p;


if (qt_existe_lib_w > 0) then

	ie_retorno_w	:=	'N';

	select	count(*)
	into STRICT	qt_existe_lib_w
	from	CLASSIFICACAO_LIB_CONVENIO
	where	nr_seq_classif_conv		=	cd_classif_conv_p
	and	nr_Seq_classif_atend		=	cd_classif_atend_p;

	if (qt_existe_lib_w > 0) then
		ie_retorno_w	:=	'S';
	end if;
else

	ie_retorno_w	:=	'N';

	select  count(*)
	into STRICT	qt_existe_lib_w
	from	convenio_classif
	where   cd_convenio = coalesce(cd_convenio_p,0);

	if (qt_existe_lib_w = 0) then
		ie_retorno_w := 'S';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_convenio_lib ( cd_classif_atend_p bigint, cd_classif_conv_p bigint, cd_convenio_p bigint default null) FROM PUBLIC;
