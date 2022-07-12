-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION projeto_xml_pck.obter_estrutura_xml (nr_seq_projeto_p bigint) RETURNS SETOF T_PROJETO_XML AS $body$
DECLARE


t_projeto_xml_row_w	t_projeto_xml_row;WITH RECURSIVE cte AS (


c01 CURSOR FOR
SELECT	substr(lpad(' ',(1 - 1) * 2,' ') || nm_atributo_xml,1,255) nm_atributo_xml,1 nivel,ie_tipo,ie_tipo_atributo,ds_mascara,ie_obrigatorio,ds_observacao,row_number() OVER () AS id,nr_seq_apresentacao
from (	select	b.nm_atributo_xml,
		b.nr_sequencia,
		b.nr_seq_elemento nr_seq_superior,
		'A' ie_tipo,
		b.ie_tipo_atributo,
		b.ds_mascara,
		b.ie_obrigatorio,
		substr(obter_desc_expressao(cd_exp_observacao),1,255) ds_observacao,
		b.nr_seq_apresentacao
	from	xml_elemento a,
		xml_atributo b
	where	a.nr_sequencia = b.nr_seq_elemento
	and	a.nr_seq_projeto = nr_seq_projeto_p
	and	coalesce(b.nr_seq_atrib_elem::text, '') = ''
	
union all

	SELECT	coalesce(a.ds_grupo, b.nm_atributo_xml) nm_atributo_xml,
		b.nr_sequencia,
		b.nr_seq_elemento nr_seq_superior,
		CASE WHEN coalesce(a.ds_grupo,'NULL')='NULL' THEN  'AE'  ELSE 'E' END  ie_tipo,
		null ie_tipo_atributo,
		null ds_mascara,
		null ie_obrigatorio,
		null ds_observacao,
		b.nr_seq_apresentacao*1000
	from	xml_elemento a,
		xml_atributo b
	where	b.nr_seq_atrib_elem = a.nr_sequencia
	and	a.nr_seq_projeto = nr_seq_projeto_p
	
union all

	select	a.nm_elemento nm_atributo_xml,
		a.nr_sequencia,
		(select	max(y.nr_sequencia)
		from	xml_elemento x,
			xml_atributo y
		where	x.nr_sequencia = y.nr_seq_elemento
		and	x.nr_seq_projeto = a.nr_seq_projeto
		and	y.nr_seq_atrib_elem = a.nr_sequencia) nr_seq_superior,
		'E' ie_tipo,
		null ie_tipo_atributo,
		null ds_mascara,
		null ie_obrigatorio,
		null ds_observacao,
		a.nr_seq_apresentacao*1000
	from	xml_elemento a
	where	a.nr_seq_projeto = nr_seq_projeto_p) z WHERE coalesce(nr_seq_superior::text, '') = ''
  UNION ALL


c01 CURSOR FOR
SELECT	substr(lpad(' ',((c.level+1) - 1) * 2,' ') || nm_atributo_xml,1,255) nm_atributo_xml,(c.level+1) nivel,ie_tipo,ie_tipo_atributo,ds_mascara,ie_obrigatorio,ds_observacao,row_number() OVER () AS id,nr_seq_apresentacao
from (	select	b.nm_atributo_xml,
		b.nr_sequencia,
		b.nr_seq_elemento nr_seq_superior,
		'A' ie_tipo,
		b.ie_tipo_atributo,
		b.ds_mascara,
		b.ie_obrigatorio,
		substr(obter_desc_expressao(cd_exp_observacao),1,255) ds_observacao,
		b.nr_seq_apresentacao
	from	xml_elemento a,
		xml_atributo b
	where	a.nr_sequencia = b.nr_seq_elemento
	and	a.nr_seq_projeto = nr_seq_projeto_p
	and	coalesce(b.nr_seq_atrib_elem::text, '') = ''
	
union all

	SELECT	coalesce(a.ds_grupo, b.nm_atributo_xml) nm_atributo_xml,
		b.nr_sequencia,
		b.nr_seq_elemento nr_seq_superior,
		CASE WHEN coalesce(a.ds_grupo,'NULL')='NULL' THEN  'AE'  ELSE 'E' END  ie_tipo,
		null ie_tipo_atributo,
		null ds_mascara,
		null ie_obrigatorio,
		null ds_observacao,
		b.nr_seq_apresentacao*1000
	from	xml_elemento a,
		xml_atributo b
	where	b.nr_seq_atrib_elem = a.nr_sequencia
	and	a.nr_seq_projeto = nr_seq_projeto_p
	
union all

	select	a.nm_elemento nm_atributo_xml,
		a.nr_sequencia,
		(select	max(y.nr_sequencia)
		from	xml_elemento x,
			xml_atributo y
		where	x.nr_sequencia = y.nr_seq_elemento
		and	x.nr_seq_projeto = a.nr_seq_projeto
		and	y.nr_seq_atrib_elem = a.nr_sequencia) nr_seq_superior,
		'E' ie_tipo,
		null ie_tipo_atributo,
		null ds_mascara,
		null ie_obrigatorio,
		null ds_observacao,
		a.nr_seq_apresentacao*1000
	from	xml_elemento a
	where	a.nr_seq_projeto = nr_seq_projeto_p) JOIN cte c ON (c.prior nr_sequencia = z.nr_seq_superior)

) SELECT * FROM cte ORDER BY 	nivel, z.nr_seq_apresentacao, z.nm_atributo_xml;
;

c01_w	c01%rowtype;


BEGIN

if (coalesce(nr_seq_projeto_p,0) > 0) then

	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (c01_w.ie_tipo <> 'AE') then
			begin
			t_projeto_xml_row_w.nm_atributo_xml	:=	c01_w.nm_atributo_xml;
			t_projeto_xml_row_w.nivel		:=	c01_w.nivel;
			t_projeto_xml_row_w.ie_tipo		:=	c01_w.ie_tipo;
			t_projeto_xml_row_w.ie_tipo_atributo	:=	c01_w.ie_tipo_atributo;
			t_projeto_xml_row_w.ds_mascara		:=	c01_w.ds_mascara;
			t_projeto_xml_row_w.ie_obrigatorio	:=	c01_w.ie_obrigatorio;
			t_projeto_xml_row_w.ds_observacao	:=	c01_w.ds_observacao;
			t_projeto_xml_row_w.id			:=	c01_w.id;
			t_projeto_xml_row_w.nr_seq_apresentacao	:=	c01_w.nr_seq_apresentacao;

			RETURN NEXT t_projeto_xml_row_w;
			end;
		end if;
		end;
	end loop;
	close C01;

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION projeto_xml_pck.obter_estrutura_xml (nr_seq_projeto_p bigint) FROM PUBLIC;