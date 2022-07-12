-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_nr_codigo_controle (nr_sequencia_p ctb_movimento.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


nr_codigo_controle_w 	movimento_contabil_doc.nr_codigo_controle%type;


BEGIN

select  max(b.nr_codigo_controle)
into STRICT 	nr_codigo_controle_w
from    ctb_movimento a,
        movimento_contabil_doc b
where   a.nr_sequencia = b.nr_seq_ctb_movto
and     a.nr_sequencia = nr_sequencia_p;

return nr_codigo_controle_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_nr_codigo_controle (nr_sequencia_p ctb_movimento.nr_sequencia%type) FROM PUBLIC;
