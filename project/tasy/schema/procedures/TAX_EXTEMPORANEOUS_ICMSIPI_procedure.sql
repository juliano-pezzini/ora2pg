-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tax_extemporaneous_icmsipi ( issue_date_p nota_fiscal.dt_emissao%type, reference_invoice_p nota_fiscal.nr_sequencia_ref%type, invoice_type_p nota_fiscal.ie_tipo_nota%type, movement_date_p INOUT nota_fiscal.dt_entrada_saida%type, situation_p INOUT fis_efd_icmsipi_C100.cd_sit%type) AS $body$
DECLARE


  converted_issue_date_w          nota_fiscal.dt_emissao%type;
  converted_movement_date_w       nota_fiscal.dt_entrada_saida%type;

BEGIN
  converted_issue_date_w    := trunc(issue_date_p, 'MM');
  converted_movement_date_w := trunc(movement_date_p, 'MM');

  if (converted_issue_date_w < converted_movement_date_w) then
    if (reference_invoice_p IS NOT NULL AND reference_invoice_p::text <> '') then
      situation_p := '07';
    else
      situation_p := '01';
    end if;
    movement_date_p := issue_date_p;
  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_extemporaneous_icmsipi ( issue_date_p nota_fiscal.dt_emissao%type, reference_invoice_p nota_fiscal.nr_sequencia_ref%type, invoice_type_p nota_fiscal.ie_tipo_nota%type, movement_date_p INOUT nota_fiscal.dt_entrada_saida%type, situation_p INOUT fis_efd_icmsipi_C100.cd_sit%type) FROM PUBLIC;

