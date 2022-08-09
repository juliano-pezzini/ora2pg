-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_catalogo_padrao (nr_sequencia_p bigint, ie_tipo_catalogo_p text) AS $body$
BEGIN

update catalogo_codificacao
set ie_usar_como_padrao = 'N'
where ie_tipo_catalogo = ie_tipo_catalogo_p;

update catalogo_codificacao
set ie_usar_como_padrao = 'S'
where nr_sequencia = nr_sequencia_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_catalogo_padrao (nr_sequencia_p bigint, ie_tipo_catalogo_p text) FROM PUBLIC;
