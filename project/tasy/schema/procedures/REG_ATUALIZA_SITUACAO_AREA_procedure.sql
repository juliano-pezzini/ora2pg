-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_atualiza_situacao_area ( nr_sequencia_p bigint, ie_situacao_p text, nm_usuario_p text) AS $body$
BEGIN

  if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND ie_situacao_p IS NOT NULL AND ie_situacao_p::text <> '') then

    update reg_area_customer
       set ie_situacao = ie_situacao_p,
           dt_atualizacao = clock_timestamp(),
           nm_usuario = nm_usuario_p
     where nr_sequencia = nr_sequencia_p;

    commit;

  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_atualiza_situacao_area ( nr_sequencia_p bigint, ie_situacao_p text, nm_usuario_p text) FROM PUBLIC;
