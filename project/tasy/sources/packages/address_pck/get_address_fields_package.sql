-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION address_pck.get_address_fields (nr_seq_pessoa_endereco_p bigint, table_p text default null) RETURNS SETOF T_ADDRESS_DATA AS $body$
DECLARE

		c01 CURSOR FOR
			SELECT	a.ie_informacao,
					a.nr_seq_end_endereco,
					a.ds_valor ds_valor,
					null cd_sistema_anterior,
					null sg_estado_tasy,
					null nr_seq_pais
			from	pessoa_endereco_item a
			where	a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_p
			and		coalesce(a.nr_seq_end_endereco::text, '') = ''
			
union all

			SELECT	a.ie_informacao,
					a.nr_seq_end_endereco,
					b.ds_endereco ds_valor,
					b.cd_sistema_anterior,
					b.sg_estado_tasy,
					coalesce(b.nr_seq_pais, c.nr_seq_pais)
			from	end_catalogo c,
					end_endereco b,
					pessoa_endereco_item a
			where	b.nr_seq_catalogo = c.nr_sequencia
			and		a.nr_seq_end_endereco = b.nr_sequencia
			and		a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_p;		
	
	ds_valor_w	pessoa_endereco_item.ds_valor%type;
	row_w		t_address_row;
			
	
BEGIN
	row_w.street		:= null;
	row_w.house_number	:= null;
	row_w.complement	:= null;
	row_w.neighborhood	:= null;
	row_w.location		:= null;
	row_w.city			:= null;
	row_w.district		:= null;
	row_w.stateName		:= null;
	row_w.postalCode	:= null;
	row_w.stateCode		:= null;
	row_w.countrySeq	:= null;
	row_w.internalNumber	:= null;
	row_w.externalNumberChar	:= null;
	row_w.country	:= null;
	
	
	for r_c01 in c01 loop	
		if (r_c01.ie_informacao = 'BAIRRO_VILA') then
			row_w.neighborhood	:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'CODIGO_POSTAL') then
			row_w.postalCode	:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'COMPLEMENTO') then
			row_w.complement	:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'DISTRITO') then
			row_w.district		:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'ESTADO_PROVINCI') then
			row_w.stateName		:= r_c01.ds_valor;
			row_w.stateCode		:= r_c01.sg_estado_tasy;
		elsif (r_c01.ie_informacao = 'LOCALIDADE_AREA') then
			row_w.location		:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'MUNICIPIO') then
			row_w.city			:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'NUMERO') then
			row_w.house_number	:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'RUA_VIALIDADE') then
			row_w.street		:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'TIPO_LOGRAD') then	
			row_w.streetType		:= r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'TIPO_BAIRRO') then
			row_w.neighborhoodType := r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'NUMERO_INT') then
			row_w.internalNumber := r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'NUMERO_EXT_ALFA') then
			row_w.externalNumberChar := r_c01.ds_valor;
		elsif (r_c01.ie_informacao = 'PAIS') then
			row_w.country	:= r_c01.ds_valor;
		end if;
		
		if ((r_c01.nr_seq_pais IS NOT NULL AND r_c01.nr_seq_pais::text <> '') and r_c01.ie_informacao = 'PAIS') or coalesce(row_w.countrySeq::text, '') = '' then
			row_w.countrySeq	:= r_c01.nr_seq_pais;
		end if;

	end loop;
	RETURN NEXT row_w;

		return;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION address_pck.get_address_fields (nr_seq_pessoa_endereco_p bigint, table_p text default null) FROM PUBLIC;
