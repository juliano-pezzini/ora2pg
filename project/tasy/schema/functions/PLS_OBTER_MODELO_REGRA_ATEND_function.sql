-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_modelo_regra_atend ( nr_seq_atendimento_p bigint, ie_evento_executado_p bigint) RETURNS bigint AS $body$
DECLARE


ie_origem_atendimento_w		pls_atendimento.ie_origem_atendimento%type;
ie_tipo_atendimento_w		pls_atendimento.ie_tipo_atendimento%type;
nr_seq_modelo_w			bigint;
nr_retorno_w			bigint;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_municipio_benef_w		pessoa_fisica.cd_municipio_ibge%type;


C01 CURSOR FOR
	SELECT	nr_seq_modelo,
		cd_municipio_benef,
		nr_seq_regiao_benef
	from (
		SELECT	c.nr_seq_modelo,
			c.cd_municipio_benef,
			c.nr_seq_regiao_benef
		from	pls_regra_quest_atend c
		where	c.ie_origem_atendimento	= ie_origem_atendimento_w
		and	c.ie_tipo_atendimento	= ie_tipo_atendimento_w
		and	c.ie_evento_executado	= ie_evento_executado_p
		and	c.ie_situacao		= 'A'
		and (pls_obter_se_controle_estab('GA') = 'S' and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ))
		and (c.cd_municipio_benef	= cd_municipio_benef_w
		or	coalesce(c.cd_municipio_benef::text, '') = '')
		and (exists (	select	1
					from	pls_regiao_local x
					where	x.cd_municipio_ibge = cd_municipio_benef_w
					and	x.nr_seq_regiao = c.nr_seq_regiao_benef) or coalesce(c.nr_seq_regiao_benef::text, '') = '')
		
union all

		select	c.nr_seq_modelo,
			c.cd_municipio_benef,
			c.nr_seq_regiao_benef
		from	pls_regra_quest_atend c
		where	c.ie_origem_atendimento	= ie_origem_atendimento_w
		and	c.ie_tipo_atendimento	= ie_tipo_atendimento_w
		and	c.ie_evento_executado	= ie_evento_executado_p
		and	c.ie_situacao		= 'A'
		and (pls_obter_se_controle_estab('GA') = 'N')
		and (c.cd_municipio_benef	= cd_municipio_benef_w
		or	coalesce(c.cd_municipio_benef::text, '') = '')
		and (exists (	select	1
					from	pls_regiao_local x
					where	x.cd_municipio_ibge = cd_municipio_benef_w
					and	x.nr_seq_regiao = c.nr_seq_regiao_benef) or coalesce(c.nr_seq_regiao_benef::text, '') = '')) alias15
	order by 	coalesce(cd_municipio_benef, 0),
			coalesce(nr_seq_regiao_benef, 0);

BEGIN

select	ie_origem_atendimento,
	ie_tipo_atendimento,
	cd_pessoa_fisica
into STRICT	ie_origem_atendimento_w,
	ie_tipo_atendimento_w,
	cd_pessoa_fisica_w
from	pls_atendimento
where	nr_sequencia = nr_seq_atendimento_p;

if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '')then
	begin
	select	c.cd_municipio_ibge
	into STRICT	cd_municipio_benef_w
	from 	pessoa_fisica a,
		compl_pessoa_fisica c
	where	a.cd_pessoa_fisica	= c.cd_pessoa_fisica
	and	c.ie_tipo_complemento	= 1
	and	c.cd_pessoa_fisica 	= cd_pessoa_fisica_w;
	exception
		when others then
		cd_municipio_benef_w	:= null;
	end;
end if;

for r_C01_w in C01 loop
	nr_seq_modelo_w	:= r_C01_w.nr_seq_modelo;
end loop;

nr_retorno_w := coalesce(nr_seq_modelo_w,0);

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_modelo_regra_atend ( nr_seq_atendimento_p bigint, ie_evento_executado_p bigint) FROM PUBLIC;
