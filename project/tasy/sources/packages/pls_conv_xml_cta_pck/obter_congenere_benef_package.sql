-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_congenere_benef ( nr_seq_segurado_p pls_segurado.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_seq_congenere_conv_w		pls_congenere.nr_sequencia%type;


BEGIN

select	max(coalesce(nr_seq_ops_congenere, nr_seq_congenere))
into STRICT	nr_seq_congenere_conv_w
from	pls_segurado
where	nr_sequencia = nr_seq_segurado_p;

return nr_seq_congenere_conv_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_congenere_benef ( nr_seq_segurado_p pls_segurado.nr_sequencia%type) FROM PUBLIC;
