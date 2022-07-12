-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_avaliacao_rh ( nr_seq_ordem_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


tipo_acordo_w		varchar(1);
cd_pessoa_fisica_w	varchar(50);
nr_seq_ordem_w		bigint;
dt_acordo_treinado_w	timestamp;
dt_acordo_superior_w	timestamp;
nm_acordo_treinado_w	varchar(50);
nm_acordo_superior_w	varchar(50);
nm_usuario_w		varchar(50);
cd_usuario_w		varchar(50);


BEGIN

/*
Valores para o "tipo_acordo_w"
  N - Não habilita
  H - Habilita
*/
tipo_acordo_w := 'N';


select	max(a.cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	tre_inscrito a
where	a.nr_seq_ordem = nr_seq_ordem_p;

select	max(b.nm_usuario)
into STRICT	nm_usuario_w
from	usuario b
where	b.cd_pessoa_fisica = cd_pessoa_fisica_w;

select	max(x.cd_pessoa_fisica)
into STRICT	cd_usuario_w
from	usuario x
where	x.nm_usuario = nm_usuario_p;

select	max(c.nr_seq_ordem),
	max(c.dt_acordo_treinado),
	max(c.nm_acordo_treinado),
	max(c.dt_acordo_superior),
	max(c.nm_acordo_superior)
into STRICT	nr_seq_ordem_w,
	dt_acordo_treinado_w,
	nm_acordo_treinado_w,
	dt_acordo_superior_w,
	nm_acordo_superior_w
from	man_pesquisa_rh c
where	c.nr_seq_ordem = nr_seq_ordem_p;

if (nm_usuario_p = nm_usuario_w) then
	begin
		if	((coalesce(dt_acordo_treinado_w::text, '') = '') and (coalesce(nm_acordo_treinado_w::text, '') = '')) then
			tipo_acordo_w := 'H';
		end if;
	end;
elsif	((cd_usuario_w = sis_obter_gerente(nm_usuario_w, 'C')) or (cd_usuario_w = sis_obter_diretor(nm_usuario_w, 'C'))) then
	begin
		if	((coalesce(dt_acordo_superior_w::text, '') = '') and (coalesce(nm_acordo_superior_w::text, '') = '')) then
			tipo_acordo_w := 'H';
		end if;
	end;
end if;

return	tipo_acordo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_avaliacao_rh ( nr_seq_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;

