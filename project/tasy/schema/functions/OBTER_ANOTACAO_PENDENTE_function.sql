-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_anotacao_pendente (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_anotacao_w		varchar(4000)	:= '';
ds_retorno_w		varchar(4000)	:= '';
ie_lib_pend_enfer_w	varchar(3);

c01 CURSOR FOR
	SELECT	ds_anotacao
	from	atendimento_anot_enf
	where	nr_atendimento	= nr_atendimento_p
	and	ie_pendente	= 'S'
	and	coalesce(ie_situacao,'A') = 'A'
	and	((ie_lib_pend_enfer_w = 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));



BEGIN

select	coalesce(max(ie_lib_pend_enfer),'N')
into STRICT	ie_lib_pend_enfer_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

open	c01;
loop
fetch	c01 into ds_anotacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_retorno_w	:= substr(ds_retorno_w ||', '|| ds_anotacao_w,1,4000);


	end;
end loop;
close c01;

return	substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_anotacao_pendente (nr_atendimento_p bigint) FROM PUBLIC;
