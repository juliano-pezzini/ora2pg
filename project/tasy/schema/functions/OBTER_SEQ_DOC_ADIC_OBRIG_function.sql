-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_doc_adic_obrig ( cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


c01 CURSOR FOR
/*Traz os registros que tem titular convenio mas algum campo obrigatório em branco*/

SELECT	1 ie_tipo,
	a.nr_sequencia,
	a.nr_seq_documento
from	tipo_documentacao d,
	pessoa_titular_convenio t,
	pessoa_documentacao a
where	1=1
and	a.nr_seq_documento	= d.nr_sequencia
and	a.nr_sequencia		= t.nr_seq_pessoa_doc
and	a.cd_pessoa_fisica		= cd_pessoa_fisica_p
and	d.ie_cart_convenio 		= 'S'
and	coalesce(a.ie_situacao,'A')	= 'A'
and exists (	select	1
		from	tipo_doc_campo_adic c
		where	c.nr_seq_tipo_doc = d.nr_sequencia
		and	c.ie_obrigatorio = 'S')

union all

/*Traz os registros que tem regra de obrigatoriedade mas não tem titular convenio*/

select	2 ie_tipo,
	a.nr_sequencia,
	a.nr_seq_documento
from	tipo_documentacao d,
	pessoa_documentacao a
where	1=1
and	a.nr_seq_documento	= d.nr_sequencia
and	a.cd_pessoa_fisica		= cd_pessoa_fisica_p
and	d.ie_cart_convenio 		= 'S'
and	coalesce(a.ie_situacao,'A')	= 'A'
and exists (	select	1
		from	tipo_doc_campo_adic c
		where	c.nr_seq_tipo_doc = d.nr_sequencia
		and	c.ie_obrigatorio = 'S')
and not exists (select	1
		from 	pessoa_titular_convenio t
		where	t.nr_seq_pessoa_doc = a.nr_sequencia);

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	upper(substr(obter_valor_dominio(7023,c.ie_campo),1,35)) ie_campo
from	tipo_doc_campo_adic c
where	c.nr_seq_tipo_doc = c01_w.nr_seq_documento
and	c.ie_obrigatorio = 'S';

c02_w	c02%rowtype;

ds_comando_w		varchar(4000);
ds_sep_bv_w		varchar(10);
ds_retorno_w		varchar(255) := '';
qt_existe_w		bigint;


BEGIN

if (coalesce(cd_pessoa_fisica_p,'0') <> '0') then
	begin
	ds_sep_bv_w	:= obter_separador_bv;

	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (c01_w.ie_tipo = 1) then
			begin
			ds_comando_w	:= 'select count(*) from pessoa_titular_convenio where nr_seq_pessoa_doc = :nr_sequencia and ( ';

			open C02;
			loop
			fetch C02 into
				c02_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				ds_comando_w	:= substr(ds_comando_w	|| c02_w.ie_campo || ' is null or ',1,4000);
				end;
			end loop;
			close C02;

			ds_comando_w	:= substr(ds_comando_w,1,length(ds_comando_w) - 3) || ')';

			qt_existe_w := obter_valor_dinamico_bv(ds_comando_w, 'nr_sequencia='||to_char(c01_w.nr_sequencia) ||ds_sep_bv_w, qt_existe_w);

			if (qt_existe_w > 0) then
				ds_retorno_w := c01_w.nr_sequencia;
			end if;
			end;

		elsif (c01_w.ie_tipo = 2) then
			ds_retorno_w := c01_w.nr_sequencia;
		end if;
		end;
	end loop;
	close C01;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_doc_adic_obrig ( cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;

