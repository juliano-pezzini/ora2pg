-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_dmed_ir_pck.is_insured_valid (type_contract_p fis_dados_dmed.ie_tipo_contratacao%type, responsible_sequence_p fis_dados_dmed.cd_pessoa_pagador%type, cnpj_administrator_p fis_dados_dmed.cd_cgc_administradora%type, cnpj_responsible_p titulo_receber.cd_cgc%type, document_source_p titulo_receber.ie_origem_titulo%type) RETURNS bigint AS $body$
DECLARE

      is_valid boolean;

BEGIN
      if (document_source_p = '3') then
          if current_setting('tax_dmed_ir_pck.general_rule_vector')::general_rule_reference[1].ie_consider_pj = 'S' then
              if (type_contract_p = 'CA') and (cnpj_administrator_p = cnpj_responsible_p) then
                  is_valid := false;
              else
	                is_valid := ((responsible_sequence_p IS NOT NULL AND responsible_sequence_p::text <> '') or (type_contract_p in ('CA') and coalesce(responsible_sequence_p::text, '') = ''));
              end if;
          else
	          is_valid := (responsible_sequence_p IS NOT NULL AND responsible_sequence_p::text <> '');
          end if;
      else
          is_valid := true;
      end if;

      return diutil.bool_to_int(is_valid);

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_dmed_ir_pck.is_insured_valid (type_contract_p fis_dados_dmed.ie_tipo_contratacao%type, responsible_sequence_p fis_dados_dmed.cd_pessoa_pagador%type, cnpj_administrator_p fis_dados_dmed.cd_cgc_administradora%type, cnpj_responsible_p titulo_receber.cd_cgc%type, document_source_p titulo_receber.ie_origem_titulo%type) FROM PUBLIC;
