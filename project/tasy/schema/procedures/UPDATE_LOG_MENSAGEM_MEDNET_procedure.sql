-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_log_mensagem_mednet ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text ) AS $body$
DECLARE

    cdPessoaFisicaIsNull   varchar(1);
    nrAtendimentoIsNull    varchar(1);

BEGIN
    select CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN  'S'  ELSE 'N' END ,
           CASE WHEN coalesce(nr_atendimento::text, '') = '' THEN  'S'  ELSE 'N' END
    into STRICT cdPessoaFisicaIsNull,
        nrAtendimentoIsNull
    from log_mensagem_mednet
    where nr_sequencia = nr_sequencia_p;

    if ( cdPessoaFisicaIsNull = 'S' ) then
        update log_mensagem_mednet
        set cd_pessoa_fisica = cd_pessoa_fisica_p
        where nr_sequencia = nr_sequencia_p;
    end if;
    if ( (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and nrAtendimentoIsNull = 'S' ) then
        update log_mensagem_mednet
        set nr_atendimento = nr_atendimento_p
        where nr_sequencia = nr_sequencia_p;
    end if;

    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_log_mensagem_mednet ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text ) FROM PUBLIC;
