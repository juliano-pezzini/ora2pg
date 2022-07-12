-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_complete_address_desc ( nr_seq_pessoa_endereco_p bigint, cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, cd_cgc_p text, nr_seq_pj_complemento_p bigint, line_break_p text default 'N') RETURNS varchar AS $body$
DECLARE

											
/*
Parameters that should be informed in each option

New way of person or legal entity address only:
	NR_SEQ_PESSOA_ENDERECO_P

Old way or new way of Person address:
	CD_PESSOA_FISICA_P
	IE_TIPO_COMPLEMENTO_P
	
Legal entity address:
	CD_CGC_P

Legal entity complementary address:
	CD_CGC_P
	NR_SEQ_PJ_COMPLEMENTO_P

*/
								
			

ds_retorno_w		varchar(4000)	:= null;
nr_seq_catalogo_w	end_catalogo.nr_sequencia%type;
nr_seq_pessoa_endereco_w	pessoa_endereco.nr_sequencia%type;
nm_pais_w	pais.nm_pais%type;
qt_pais_w	integer	:= 0;
ie_tipo_complemento_pj_w	pessoa_juridica_compl.ie_tipo_complemento%type;
ie_pf_pj_w			varchar(20)	:= 'PF';

/* To get complete address with new data structure */

c01 CURSOR FOR
SELECT	c.ds_endereco ds,
		c.ie_informacao info,
		coalesce(cfg.nr_ordem_descricao,1) ordem
FROM end_endereco c, pessoa_endereco_item a
LEFT OUTER JOIN config_endereco cfg ON (a.ie_informacao = cfg.ie_informacao)
WHERE a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w and cfg.nr_seq_catalogo = nr_seq_catalogo_w  and c.nr_sequencia = a.nr_seq_end_endereco and a.nr_seq_end_endereco > 0 and coalesce(cfg.IE_FISICA_JURIDICA,ie_pf_pj_w) = ie_pf_pj_w

union all

SELECT	a.ds_valor ds,
		a.ie_informacao info,
		coalesce(cfg.nr_ordem_descricao,1) ordem
FROM pessoa_endereco_item a
LEFT OUTER JOIN config_endereco cfg ON (a.ie_informacao = cfg.ie_informacao)
WHERE a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w and cfg.nr_seq_catalogo = nr_seq_catalogo_w  and coalesce(a.nr_seq_end_endereco::text, '') = '' and coalesce(cfg.IE_FISICA_JURIDICA,ie_pf_pj_w) = ie_pf_pj_w
 
union all

select	nm_pais_w ds,
		'PAIS' info,
		999999 ordem

where	not exists (select	1
					FROM pessoa_endereco_item a
LEFT OUTER JOIN config_endereco cfg ON (a.ie_informacao = cfg.ie_informacao)
WHERE a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w and cfg.nr_seq_catalogo = nr_seq_catalogo_w and coalesce(cfg.IE_FISICA_JURIDICA,ie_pf_pj_w) = ie_pf_pj_w and a.ie_informacao = 'PAIS' )
order by
		ordem;
								
BEGIN

if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
        
		if (cd_cgc_p = 'PF') then
            ie_pf_pj_w	:= 'PF';
        else
            ie_pf_pj_w	:= 'PJ';
        end if;

end if;


if (nr_seq_pessoa_endereco_p IS NOT NULL AND nr_seq_pessoa_endereco_p::text <> '') then
	nr_seq_pessoa_endereco_w	:= nr_seq_pessoa_endereco_p;
else
  begin
	/* Person address */

	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_tipo_complemento_p IS NOT NULL AND ie_tipo_complemento_p::text <> '') then
	
		select	nr_seq_pessoa_endereco
		into STRICT	nr_seq_pessoa_endereco_w
		from	compl_pessoa_fisica a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
		and		a.ie_tipo_complemento = ie_tipo_complemento_p;
	-- Legal entity complementary address 
	elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') and (nr_seq_pj_complemento_p IS NOT NULL AND nr_seq_pj_complemento_p::text <> '') then
		select	nr_seq_pessoa_endereco,
				ie_tipo_complemento
		into STRICT	nr_seq_pessoa_endereco_w,
				ie_tipo_complemento_pj_w
		from	pessoa_juridica_compl a
		where	a.cd_cgc	= cd_cgc_p
		and		a.nr_sequencia = nr_seq_pj_complemento_p;
	-- Legal entity address 
	elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
		select	nr_seq_pessoa_endereco
		into STRICT	nr_seq_pessoa_endereco_w
		from	pessoa_juridica a
		where	a.cd_cgc	= cd_cgc_p;
	end if;
	exception
		when others then
		nr_seq_pessoa_endereco_w := null;
  end;
end if;

if (nr_seq_pessoa_endereco_w IS NOT NULL AND nr_seq_pessoa_endereco_w::text <> '') then
	begin
	select	a.nr_seq_catalogo,
			c.nm_pais
	into STRICT	nr_seq_catalogo_w,
			nm_pais_w
	from	pais c,
			end_catalogo b,
			pessoa_endereco a
	where	a.nr_seq_catalogo = b.nr_sequencia
	and		b.nr_seq_pais = c.nr_sequencia
	and		a.nr_sequencia	= nr_seq_pessoa_endereco_w;
	exception
		when others then
		null;
	end;
	
	if (coalesce(nr_seq_catalogo_w::text, '') = '') then
		begin
		select	b.nr_seq_catalogo,
				c.nm_pais
		into STRICT	nr_seq_catalogo_w,
				nm_pais_w
		from	pais c,
				end_endereco b,
				end_catalogo d,
				pessoa_endereco_item a
		where b.nr_seq_catalogo = d.nr_sequencia
		and	d.nr_seq_pais = c.nr_sequencia
		and a.nr_seq_end_endereco = b.nr_sequencia
		and		a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w  LIMIT 1;
		exception
			when others then
			null;
		end;
	end if;
	

	if ((nr_seq_catalogo_w IS NOT NULL AND nr_seq_catalogo_w::text <> '') and line_break_p = 'N') then
		for r_c01 in c01 loop
			if (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w	:= substr(r_c01.ds,1,4000);
			elsif (r_c01.ds IS NOT NULL AND r_c01.ds::text <> '') then
				ds_retorno_w	:= substr(ds_retorno_w || ', ' || r_c01.ds,1,4000);
			end if;
		end loop;
	else
		for r_c01 in c01 loop
            ds_retorno_w := ds_retorno_w || obter_valor_dominio(8959, r_c01.info) || ': ' || r_c01.ds || chr(10);
		end loop;
	end if;
else
	/* To get complete address with old structure */



	/* Person address */

	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_tipo_complemento_p IS NOT NULL AND ie_tipo_complemento_p::text <> '') then
		ds_retorno_w	:= obter_compl_pf(cd_pessoa_fisica_p,ie_tipo_complemento_p,'EC');
	/* Legal entity complementary address */

	elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') and (ie_tipo_complemento_pj_w IS NOT NULL AND ie_tipo_complemento_pj_w::text <> '') then	
		ds_retorno_w	:= obter_compl_pj(cd_cgc_p,ie_tipo_complemento_pj_w,'EC');
	/* Return empty address when inserting new record */
	
	elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') and (coalesce(ie_tipo_complemento_pj_w::text, '') = '') then	
		ds_retorno_w	:= null;
	/* Legal entity address */

	elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
		ds_retorno_w	:= obter_dados_pf_pj(null,cd_cgc_p,'ECM');
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_complete_address_desc ( nr_seq_pessoa_endereco_p bigint, cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, cd_cgc_p text, nr_seq_pj_complemento_p bigint, line_break_p text default 'N') FROM PUBLIC;

