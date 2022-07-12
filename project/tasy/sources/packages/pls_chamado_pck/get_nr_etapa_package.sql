-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_chamado_pck.get_nr_etapa ( nr_seq_etapa_p pls_tipo_chamado_etapa.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

nr_ordem_w	pls_tipo_chamado_etapa.nr_ordem%type;

BEGIN
select	nr_ordem
into STRICT	nr_ordem_w
from	pls_tipo_chamado_etapa
where	nr_sequencia = nr_seq_etapa_p;
return nr_ordem_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_chamado_pck.get_nr_etapa ( nr_seq_etapa_p pls_tipo_chamado_etapa.nr_sequencia%type) FROM PUBLIC;