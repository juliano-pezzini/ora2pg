-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_dmed_ir_pck.load_data_responsible (ie_provider_p tax_dmed_dados_gerais.ie_prestador%type, open_initials_p text, responsible_initials_p text, beneficiary_initials_p text) AS $body$
DECLARE

      c_responsible CURSOR FOR
        SELECT  sum(x.total_amount) total_amount,
                x.responsible_name responsible_name,
                x.responsible_cpf responsible_cpf,
                x.responsible_code responsible_code,
                sum(x.total_responsible) total_responsible
        from   (
                SELECT  d.vl_pago total_amount,
                        fis_remove_special_characters(substr(obter_nome_pf(d.cd_responsavel_pagamento), 1, 255)) responsible_name,
                        p.nr_cpf responsible_cpf,
                        d.cd_responsavel_pagamento responsible_code,
                        CASE WHEN coalesce(d.cd_cnpj_prestador_remb::text, '') = '' THEN  coalesce((select  d.vl_pago                                                                                                                                          where   (d.cd_responsavel_pagamento = d.cd_beneficiario                                                                     and     ((coalesce(d.cd_pf_prestador_remb, 0) = 0) or d.cd_responsavel_pagamento = d.cd_pf_prestador_remb))), 0)  ELSE 0 END  total_responsible
                from    tax_dmed_controle       c,
                        tax_dmed_lote_mensal    m,
                        tax_dmed_dados_gerais   d,
                        pessoa_fisica           p
                where   m.nr_seq_lote           = c.nr_seq_lote
                and     d.nr_seq_lote_mensal    = m.nr_sequencia
                and     p.cd_pessoa_fisica      = to_char(d.cd_responsavel_pagamento)
                and     c.nr_sequencia          = file_control_sequence
                and     d.ie_prestador          = ie_provider_p
                and     (p.nr_cpf IS NOT NULL AND p.nr_cpf::text <> '')              
                order by p.nr_cpf asc
                ) x 
                group by  responsible_code,
                          responsible_cpf,
                          responsible_name
                order by  responsible_cpf;

      responsible_vector  c_responsible%rowtype;
      record_open         varchar(255) := '%s' || data_separator;
      record_responsible  varchar(255) := '%s' || data_separator || '%s' || data_separator || '%s' || data_separator || '%s' || data_separator;
      aux_text            varchar(255) := '';

BEGIN
      CALL tax_dmed_ir_pck.add_data_file(utl_lms.format_message(record_open, open_initials_p), open_initials_p);
      open c_responsible;
      loop
          fetch c_responsible into responsible_vector;
          EXIT WHEN NOT FOUND; /* apply on c_responsible */
          begin

              if (responsible_vector.total_responsible <> 0) then
                aux_text := tax_dmed_ir_pck.shape_dmed_default_number(responsible_vector.total_responsible);
              else
                aux_text := '';
              end if;

              if (responsible_vector.total_amount > 0) then
                  CALL tax_dmed_ir_pck.add_data_file(utl_lms.format_message(record_responsible,responsible_initials_p, 
                                                                      responsible_vector.responsible_cpf, 
                                                                      responsible_vector.responsible_name, 
                                                                      aux_text), 
                                                                      responsible_initials_p);
                  if ie_provider_p = 'N' then
                      CALL tax_dmed_ir_pck.load_data_refund(responsible_vector.responsible_code);
                  end if;

                  CALL tax_dmed_ir_pck.load_data_beneficiary(ie_provider_p, responsible_vector.responsible_code, beneficiary_initials_p, responsible_vector.responsible_cpf);
              end if;
          end;
      end loop;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_dmed_ir_pck.load_data_responsible (ie_provider_p tax_dmed_dados_gerais.ie_prestador%type, open_initials_p text, responsible_initials_p text, beneficiary_initials_p text) FROM PUBLIC;
