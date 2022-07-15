-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_convenio_particular_pf (cd_estabelecimento_p bigint, cd_convenio_param_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, CD_CONVENIO_P INOUT bigint, CD_CATEGORIA_P INOUT text) AS $body$
DECLARE


nr_seq_cartao_w		bigint;
cd_convenio_w		integer	:= 0;
cd_categoria_w		varchar(10);

c01 CURSOR FOR
	SELECT	cd_convenio,
		cd_categoria
	from	param_cartao_fidelidade
	where	nr_seq_cartao	= nr_seq_cartao_w;


BEGIN

/* select	nvl(max(nr_seq_cartao), 0)
into	nr_seq_cartao_w
from	pf_cartao_fidelidade
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	dt_referencia_p between dt_inicio_validade and nvl(dt_fim_validade, sysdate);

if	(nr_seq_cartao_w <> 0) then
	begin

	open	c01;
	loop
	fetch	c01 into
		cd_convenio_w,
		cd_categoria_w;
	exit	when c01%notfound;
		begin

		cd_convenio_w	:= cd_convenio_w;

		end;
	end loop;
	close c01;

	end;
end if;

*/
if (cd_convenio_w	= 0) then

	select	coalesce(max(CD_CONVENIO_GLOSA),0),
		coalesce(max(cd_categoria_glosa),'')
	into STRICT	cd_convenio_w,
		cd_categoria_w
	from	convenio
	where	cd_convenio		= cd_convenio_param_p;

	if (cd_convenio_w	= 0) then
		SELECT * FROM obter_convenio_particular(cd_estabelecimento_p, cd_convenio_w, cd_categoria_w) INTO STRICT cd_convenio_w, cd_categoria_w;
	end if;
end if;

CD_CONVENIO_P		:= cd_convenio_w;
CD_CATEGORIA_P		:= cd_categoria_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_convenio_particular_pf (cd_estabelecimento_p bigint, cd_convenio_param_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, CD_CONVENIO_P INOUT bigint, CD_CATEGORIA_P INOUT text) FROM PUBLIC;

