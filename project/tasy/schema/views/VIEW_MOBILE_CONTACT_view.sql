-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW view_mobile_contact (nr_telefone_ans, ds_email_ans, ds_site_ans, nm_contato_operadora, nr_telefone_operadora) AS select
    c.nr_telefone_ans, 
    c.ds_email_ans, 
    c.ds_site_ans, 
    pls_obter_dados_atend_operad(c.cd_cgc_outorgante,'PC') nm_contato_operadora, 
    pls_obter_dados_atend_operad(c.cd_cgc_outorgante,'FC') nr_telefone_operadora 
FROM  pessoa_juridica b, 
    pls_outorgante c 
where  b.cd_cgc = c.cd_cgc_outorgante 
  and  c.cd_estabelecimento = 1;
