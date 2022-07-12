-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_key_values (cd_tasy_attribute_p text, cd_tasy_value_p text, cd_msg_typ_p text, ds_segment_p text default null, nr_account_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_condition_w  	eclipse_attribute.ie_condition%type;
nr_sequencia_w  	eclipse_attribute.nr_sequencia%type;
nm_eclipse_field_w	eclipse_attribute.nm_eclipse_field%type;
qtd_value_w     	integer;
qtd_conversion_w 	integer;


BEGIN

if (cd_tasy_attribute_p IS NOT NULL AND cd_tasy_attribute_p::text <> '') then
		
	select  max(a.ie_condition),
			max(a.nr_sequencia),
			max(a.nm_eclipse_field)
	into STRICT    ie_condition_w,
			nr_sequencia_w,
			nm_eclipse_field_w
	from    eclipse_attribute a
	where   a.nm_atributo  	= cd_tasy_attribute_p
	and (coalesce(a.ds_segment::text, '') = '' or a.ds_segment like('%'||ds_segment_p||'%'))
	and	(
		(cd_msg_typ_p = 'OEC' AND a.ie_oec = 'S') or
		(cd_msg_typ_p = 'OVV' AND a.ie_ovv = 'S') or
		(cd_msg_typ_p = 'IHC' AND a.ie_ihc = 'S') or
		(cd_msg_typ_p = 'DBS' AND a.ie_dbs = 'S')
		);	
	
	if (ie_condition_w = 'M') then
	
		select	count(*)
		into STRICT    qtd_value_w
		from	eclipse_value	
		where   nr_seq_attribute = nr_sequencia_w;

		if (qtd_value_w > 0) then
		
			select	count(*)
			into STRICT    qtd_conversion_w
			from	eclipse_conversion	
			where   nr_seq_value in (SELECT  nr_sequencia
						 from	 eclipse_value	
						 where   nr_seq_attribute = nr_sequencia_w);

			if (qtd_conversion_w = 0) then
				if (coalesce(nr_account_p::text, '') = '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(1103115 ,'NM_ATRIBUTO='||cd_tasy_attribute_p);
				else
					qtd_conversion_w	:= 0;
					--generate_inco_eclipse(nr_account_p, 2, 'NM_ATRIBUTO= '||cd_tasy_attribute_p || 'ECLIPSE= ' || nm_eclipse_field_w, 'Tasy');

					-- To generate eclipse inconsistence use GET_ECLIPSE_CONVERSION instead GET_KEY_VALUES
				end if;
			end if;
		end if;
	
	end if;
	
	begin
	select	b.cd_code
	into STRICT	ds_retorno_w
	from 	eclipse_attribute a,
			eclipse_value b,
			eclipse_conversion c
	where	a.nm_atributo  		= cd_tasy_attribute_p
	and 	b.nr_seq_attribute	= a.nr_sequencia
	and 	c.nr_seq_value 		=  b.nr_sequencia
	and		coalesce(c.ds_tasy_value,c.ds_default_value) = cd_tasy_value_p
	and		(
			(cd_msg_typ_p = 'OEC' AND IE_OEC = 'S') or
			(cd_msg_typ_p = 'OVV' AND IE_OVV = 'S') or
			(cd_msg_typ_p = 'IHC' AND IE_IHC = 'S') or
			(cd_msg_typ_p = 'DBS' AND IE_DBS = 'S')
			)
	and (coalesce(a.ds_segment::text, '') = '' or a.ds_segment like('%'||ds_segment_p||'%'));
	exception
		when others	then
		ds_retorno_w := null;
	end;
end if;
		
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_key_values (cd_tasy_attribute_p text, cd_tasy_value_p text, cd_msg_typ_p text, ds_segment_p text default null, nr_account_p bigint default null) FROM PUBLIC;

