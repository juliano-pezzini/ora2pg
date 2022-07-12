-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_local_paciente () RETURNS bigint AS $body$
DECLARE

  nr_seq_local_w       bigint;
  cd_estabelecimento_w bigint;

BEGIN
    cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

    SELECT coalesce(Max(nr_sequencia), 0)
    INTO STRICT   nr_seq_local_w 
    FROM   nut_local_refeicao 
    WHERE  ie_situacao = 'A' 
           AND ie_local_paciente = 'S' 
           AND ( ( cd_estabelecimento = cd_estabelecimento_w ) 
                  OR ( coalesce(cd_estabelecimento::text, '') = '' ) );

    RETURN nr_seq_local_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_local_paciente () FROM PUBLIC;
