-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apap_atualizar_secao (nr_sequencia_p bigint, ie_visivel_p text, ie_tipo_p text) AS $body$
BEGIN
if (ie_tipo_p = 'L') then
   CALL apap_dinamico_pck.atualiza_linha(nr_sequencia_p,ie_visivel_p);
else
   CALL apap_dinamico_pck.atualiza_secao(nr_sequencia_p,ie_visivel_p);
end if;
                                          
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_atualizar_secao (nr_sequencia_p bigint, ie_visivel_p text, ie_tipo_p text) FROM PUBLIC;

