-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_atualizar_nfe_denegada ( nr_seq_transmissao_p text, nr_danfe_p text) AS $body$
DECLARE


nr_seq_nota_fiscal_w	nota_fiscal.nr_sequencia%type;


BEGIN

update nfe_transmissao
set ie_tipo_transmissao = 10 
where nr_sequencia = nr_seq_transmissao_p;
commit;

select max(nr_seq_nota_fiscal)
into STRICT nr_seq_nota_fiscal_w
from nfe_transmissao_nf
where nr_seq_transmissao = nr_seq_transmissao_p;

update nota_fiscal
set nr_danfe = nr_danfe_p 
where nr_sequencia = nr_seq_nota_fiscal_w;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_atualizar_nfe_denegada ( nr_seq_transmissao_p text, nr_danfe_p text) FROM PUBLIC;
