-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_servico_lib_reserva ( nr_seq_servico_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'S';
qt_itens_w	integer;


BEGIN

select 	count(*)
into STRICT	qt_itens_w
from	regra_lib_servico_reserva
where	cd_perfil = cd_perfil_p;

if (qt_itens_w > 0) then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	regra_lib_servico_reserva
	where	cd_perfil = cd_perfil_p
	and	nr_seq_servico = nr_seq_servico_p;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_servico_lib_reserva ( nr_seq_servico_p bigint, cd_perfil_p bigint) FROM PUBLIC;

