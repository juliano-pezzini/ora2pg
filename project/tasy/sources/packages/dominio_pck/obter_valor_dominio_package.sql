-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dominio_pck.obter_valor_dominio ( cd_dominio_p bigint, vl_dominio_p text) RETURNS varchar AS $body$
DECLARE

					
	chave_w	varchar(100);
	nr_seq_idioma_w	bigint;
	
BEGIN
	
	if (cd_dominio_p IS NOT NULL AND cd_dominio_p::text <> '') and (vl_dominio_p IS NOT NULL AND vl_dominio_p::text <> '') then
		
		nr_seq_idioma_w	:= coalesce(philips_param_pck.get_nr_seq_idioma,1);
		chave_w	:= nr_seq_idioma_w||'_'||cd_dominio_p||'_'||vl_dominio_p;
		
		if (current_setting('dominio_pck.vetor_w')::vetorValorDominio.EXISTS(chave_w) and current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w](.ds_valor_dominio IS NOT NULL AND .ds_valor_dominio::text <> '')) then
			return current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w].ds_valor_dominio;
		else
			current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w].cd_dominio		:= cd_dominio_p;
			current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w].vl_dominio		:= vl_dominio_p;
			begin
			select	substr(coalesce(ds_valor_dominio_cliente, obter_desc_expressao_idioma(cd_exp_valor_dominio, ds_valor_dominio, nr_seq_idioma_w)), 1, 255)
			into STRICT 	current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w].ds_valor_dominio
			from 	valor_dominio
			where 	cd_dominio	= cd_dominio_p
			and 	vl_dominio	= vl_dominio_p;
			exception
			      when others then
				current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w].ds_valor_dominio := null;
			    end;

			return current_setting('dominio_pck.vetor_w')::vetorValorDominio[chave_w].ds_valor_dominio;
		end if;
	
	end if;
	
	return	null;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION dominio_pck.obter_valor_dominio ( cd_dominio_p bigint, vl_dominio_p text) FROM PUBLIC;