-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_eclipse_conversion (cd_tasy_attribute_p text, cd_tasy_value_p text, cd_msg_typ_p text, ds_segment_p text default null, nr_account_p bigint default null, ds_conversion_p INOUT text DEFAULT NULL) AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_condition_w  	eclipse_attribute.ie_condition%type;
nr_sequencia_w  	eclipse_attribute.nr_sequencia%type;
nm_eclipse_field_w	eclipse_attribute.nm_eclipse_field%type;
qtd_value_w     	integer;
qtd_conversion_w 	integer;
domain_number integer;



BEGIN

BEGIN
  domain_number := (cd_tasy_attribute_p )::numeric;
EXCEPTION
  WHEN data_exception THEN
  domain_number := null;
END;


if ((cd_tasy_attribute_p IS NOT NULL AND cd_tasy_attribute_p::text <> '') and coalesce(domain_number::text, '') = '') then


		
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
		(cd_msg_typ_p = 'DBS' AND a.ie_dbs = 'S') or
		(cd_msg_typ_p = 'IMC' AND a.ie_imc = 'S') or
		(cd_msg_typ_p = 'OVS' AND a.ie_ovs = 'S')
		);	
	
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
					 where   nr_seq_attribute = nr_sequencia_w)
		and		coalesce(ds_tasy_value,ds_default_value) = cd_tasy_value_p;

		if (qtd_conversion_w = 0) then
				CALL generate_inco_eclipse(nr_account_p, 2, 'NM_ATRIBUTO= '||cd_tasy_attribute_p || ' (' || 
					nr_sequencia_w || ' - ' || cd_tasy_value_p || ') ' || nm_eclipse_field_w || ' (' || ds_segment_p || ')', 'Tasy');
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
			(cd_msg_typ_p = 'DBS' AND IE_DBS = 'S') or
			(cd_msg_typ_p = 'IMC' AND IE_IMC = 'S') or 
			(cd_msg_typ_p = 'OVS' AND IE_OVS = 'S')
			)
	and (coalesce(a.ds_segment::text, '') = '' or a.ds_segment like('%'||ds_segment_p||'%'));
	 exception
		when others	then
		ds_retorno_w := null;
	end;

elsif (domain_number IS NOT NULL AND domain_number::text <> '') then
begin  
  select b.cd_code
  into STRICT	ds_retorno_w
  from eclipse_attribute a,
      ECLIPSE_VALUE b,
      ECLIPSE_CONVERSION c
  where a.CD_DOMINIO = domain_number
  and 	b.nr_seq_attribute	= a.nr_sequencia
  and  b.nr_sequencia  = c.nr_seq_value
  and coalesce(c.ds_tasy_value,c.ds_default_value) = cd_tasy_value_p;

	 exception
		when others	then
		ds_retorno_w := null;
	end;
 
end if;

ds_conversion_p	:= ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_eclipse_conversion (cd_tasy_attribute_p text, cd_tasy_value_p text, cd_msg_typ_p text, ds_segment_p text default null, nr_account_p bigint default null, ds_conversion_p INOUT text DEFAULT NULL) FROM PUBLIC;

