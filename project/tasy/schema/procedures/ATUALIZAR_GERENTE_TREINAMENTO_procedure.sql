-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_gerente_treinamento ( cd_pessoa_fisica_p bigint, cd_gerente_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w  qms_treinamento.cd_pessoa_fisica%type   not null    := cd_pessoa_fisica_p;
cd_gerente_w        qms_treinamento.cd_gerente_pessoa%type  not null    := cd_gerente_p;
nm_usuario_w        qms_treinamento.nm_usuario%type                     := nm_usuario_p;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND cd_gerente_p IS NOT NULL AND cd_gerente_p::text <> '') then
    update qms_treinamento
    set dt_atualizacao      =   clock_timestamp(),
        nm_usuario          =   nm_usuario_w,
        cd_gerente_pessoa   =   cd_gerente_w
    where cd_pessoa_fisica  =   cd_pessoa_fisica_w;
    commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_gerente_treinamento ( cd_pessoa_fisica_p bigint, cd_gerente_p bigint, nm_usuario_p text) FROM PUBLIC;

