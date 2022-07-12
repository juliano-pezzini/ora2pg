-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sis_obter_diretor ( nm_usuario_resp_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*  ie_opcao_p
C - Código (referente a tabela PESSOA_FISICA)
M - email (referente a tabela USUARIO)
S - Sequência (Chave primária)*/
ds_retorno_w		varchar(255);
cd_pessoa_fisica_w	varchar(10);
cd_diretor_w		varchar(10);
nr_seq_dir_w		bigint;
qt_diretor_w		bigint;
qt_gerente_w		bigint;
qt_lider_w		bigint;
qt_equipe_w		bigint;


BEGIN
-- Buscar cd_pessoa_fisica do usuário informado
select	coalesce(max(a.cd_pessoa_fisica),'0')
into STRICT	cd_pessoa_fisica_w
from	usuario a
where	a.nm_usuario = nm_usuario_resp_p;
-- verifica se usuário é diretor
select	count(*)
into STRICT	qt_diretor_w
from	departamento_philips a
where	a.cd_pessoa_fisica = cd_pessoa_fisica_w
and	a.ie_situacao = 'A'
and	coalesce(a.ie_apoio,'N') = 'N';
-- Verifica se usuário é gerente
select	count(*)
into STRICT	qt_gerente_w
from	gerencia_wheb a
where	a.cd_responsavel = cd_pessoa_fisica_w
and	a.ie_situacao = 'A';
-- Verifica se usuário é lider de grupo
select	count(*)
into STRICT	qt_lider_w
from	gerencia_wheb_grupo a
where	a.nm_usuario_lider = nm_usuario_resp_p
and	a.ie_situacao = 'A';
-- Verifica se usuário é equipe
select	count(*)
into STRICT	qt_equipe_w
from	gerencia_wheb_grupo_usu a
where	a.nm_usuario_grupo = nm_usuario_resp_p;

-- Buscará qual o diretor do responsável referente
if (qt_diretor_w > 0) then
	cd_diretor_w := cd_pessoa_fisica_w;
	select	coalesce(max(a.nr_sequencia),'0')
	into STRICT	nr_seq_dir_w
	from	departamento_philips a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_w
	and	a.ie_situacao = 'A'
	and	coalesce(a.ie_apoio,'N') = 'N';
elsif (qt_gerente_w > 0) then
	begin
	select	coalesce(max(c.cd_pessoa_fisica),'0'),
		coalesce(max(c.nr_sequencia),'0')
	into STRICT	cd_diretor_w,
		nr_seq_dir_w
	from	gerencia_wheb a,
		depto_gerencia_philips b,
		departamento_philips c
	where	a.nr_sequencia = b.nr_seq_gerencia
	and	c.nr_sequencia = b.nr_seq_departamento
	and	c.ie_situacao = 'A'
	and	a.ie_situacao = 'A'
	and	a.cd_responsavel = cd_pessoa_fisica_w;
	end;
elsif (qt_lider_w > 0) then
	begin
	select	coalesce(max(c.cd_pessoa_fisica),'0'),
		coalesce(max(c.nr_sequencia),'0')
	into STRICT	cd_diretor_w,
		nr_seq_dir_w
	from	gerencia_wheb a,
		depto_gerencia_philips b,
		departamento_philips c,
		gerencia_wheb_grupo d
	where	a.nr_sequencia = b.nr_seq_gerencia
	and	c.nr_sequencia = b.nr_seq_departamento
	and	a.nr_sequencia = d.nr_seq_gerencia
	and	c.ie_situacao = 'A'
	and	a.ie_situacao = 'A'
	and	d.ie_situacao = 'A'
	and	d.nm_usuario_lider = nm_usuario_resp_p;
	end;
elsif (qt_equipe_w > 0) then
	begin
	select	coalesce(max(c.cd_pessoa_fisica),'0'),
		coalesce(max(c.nr_sequencia),'0')
	into STRICT	cd_diretor_w,
		nr_seq_dir_w
	from	gerencia_wheb a,
		depto_gerencia_philips b,
		departamento_philips c,
		gerencia_wheb_grupo d,
		gerencia_wheb_grupo_usu e
	where	a.nr_sequencia	= b.nr_seq_gerencia
	and	c.nr_sequencia	= b.nr_seq_departamento
	and	a.nr_sequencia	= d.nr_seq_gerencia
	and	d.nr_sequencia	= e.nr_seq_grupo
	and	c.ie_situacao	= 'A'
	and	a.ie_situacao	= 'A'
	and	d.ie_situacao	= 'A'
	and	e.nm_usuario_grupo = nm_usuario_resp_p;
	end;
end if;

if (ie_opcao_p = 'C') then
	ds_retorno_w := cd_diretor_w;
elsif (ie_opcao_p = 'S') then
	ds_retorno_w := nr_seq_dir_w;
elsif (ie_opcao_p = 'M') then
	begin
	select	max(a.ds_email)
	into STRICT	ds_retorno_w
	from	usuario a
	where	a.cd_pessoa_fisica = cd_diretor_w
	and	(a.ds_email IS NOT NULL AND a.ds_email::text <> '');
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sis_obter_diretor ( nm_usuario_resp_p text, ie_opcao_p text) FROM PUBLIC;

