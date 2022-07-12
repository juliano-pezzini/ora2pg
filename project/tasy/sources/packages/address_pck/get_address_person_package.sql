-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION address_pck.get_address_person (cd_pessoa_fisica_p text, ie_tipo_complemento_p text) RETURNS SETOF T_ADDRESS_DATA AS $body$
DECLARE

								
	nr_seq_pessoa_endereco_w	pessoa_endereco.nr_sequencia%type	:= null;
	row_w				t_address_row;
	ie_tipo_complemento_w		bigint		:= cast(coalesce(ie_tipo_complemento_p, 0) as bigint);
								
	
BEGIN
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_tipo_complemento_p IS NOT NULL AND ie_tipo_complemento_p::text <> '') then
		select	a.nr_seq_pessoa_endereco
		into STRICT	nr_seq_pessoa_endereco_w
		from	compl_pessoa_fisica a
		where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and		a.ie_tipo_complemento = ie_tipo_complemento_w;
	end if;
	
	select	neighborhood,
			postalCode,
			complement,
			district,
			stateName,
			location,
			city,
			house_number,
			street,
			countrySeq,
			streetType,
			neighborhoodType,
			internalNumber,
			externalNumberChar,
			country
	into STRICT	row_w.neighborhood,
			row_w.postalCode,
			row_w.complement,
			row_w.district,
			row_w.stateName,
			row_w.location,
			row_w.city,
			row_w.house_number,
			row_w.street,
			row_w.countrySeq,
			row_w.streetType,
			row_w.neighborhoodType,
			row_w.internalNumber,
			row_w.externalNumberChar,
			row_w.country
	from	table(address_pck.get_address_fields(nr_seq_pessoa_endereco_w));
	RETURN NEXT row_w;
		
	return;
		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION address_pck.get_address_person (cd_pessoa_fisica_p text, ie_tipo_complemento_p text) FROM PUBLIC;