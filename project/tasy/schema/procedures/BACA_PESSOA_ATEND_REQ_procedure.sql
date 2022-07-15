-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pessoa_atend_req (dt_mes_atend_p timestamp) AS $body$
DECLARE


nm_usuario_w		varchar(15);
nr_requisicao_w		integer;
nr_sequencia_w		integer;
cd_pessoa_fisica_w	varchar(10);

c01 CURSOR FOR
	SELECT	b.nr_requisicao,
		b.nr_sequencia,
		b.nm_usuario
	from	requisicao_material a,
		item_requisicao_material b
	where	a.nr_requisicao	= b.nr_requisicao
	and	trunc(b.dt_atendimento, 'month') = trunc(dt_mes_atend_p, 'month')
	group by b.nr_requisicao,
		b.nr_sequencia,
		b.nm_usuario;


BEGIN

open	c01;
loop
fetch	c01 into
	nr_requisicao_w,
	nr_sequencia_w,
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(max(cd_pessoa_fisica),'0')
	into STRICT	cd_pessoa_fisica_w
	from	usuario
	where	nm_usuario	= nm_usuario_w;

	if (cd_pessoa_fisica_w	<> '0') then
		begin

		update	item_requisicao_material
		set	cd_pessoa_atende	= cd_pessoa_fisica_w
		where	nr_requisicao		= nr_requisicao_w
		and	nr_sequencia		= nr_sequencia_w
		and	(dt_atendimento IS NOT NULL AND dt_atendimento::text <> '');


		update	requisicao_material
		set	cd_pessoa_atendente	= cd_pessoa_fisica_w
		where	nr_requisicao		= nr_requisicao_w;


		end;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pessoa_atend_req (dt_mes_atend_p timestamp) FROM PUBLIC;

