-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_catalogo (nr_sequencia_p bigint) AS $body$
DECLARE


ie_tipo_catalogo_w	catalogo_codificacao.ie_tipo_catalogo%type;


BEGIN

update catalogo_codificacao
set ie_situacao = 'I', ie_usar_como_padrao = 'N'
where nr_sequencia = nr_sequencia_p;

select ie_tipo_catalogo
into STRICT ie_tipo_catalogo_w
from catalogo_codificacao
where nr_sequencia = nr_sequencia_p;

if ie_tipo_catalogo_w = 'P' then
  update procedimento set ie_situacao = 'I' where nr_seq_catalogo = nr_sequencia_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_catalogo (nr_sequencia_p bigint) FROM PUBLIC;

