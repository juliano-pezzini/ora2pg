-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sac_obter_se_classif_ocor_lib ( nr_seq_classif_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1):= 'S';
cd_perfil_ativo_w	bigint := obter_perfil_ativo;
qt_reg_w		bigint;


BEGIN
select	count(*)
into STRICT	qt_reg_w
from	sac_classif_ocorrencia_lib
where	nr_seq_classif = nr_seq_classif_p;

if (qt_reg_w > 0) then
	ds_retorno_w := 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	from 	sac_classif_ocorrencia_lib
	where	nr_seq_classif	= nr_seq_classif_p
	and	cd_perfil	= cd_perfil_ativo_w  LIMIT 1;

	exception
	when others then
		ds_retorno_w := 'N';
	end;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sac_obter_se_classif_ocor_lib ( nr_seq_classif_p bigint, nm_usuario_p text) FROM PUBLIC;

