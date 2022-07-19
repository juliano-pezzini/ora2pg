-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_criacao_trigger_alt_pf () AS $body$
BEGIN

/* 08/08/2011 - Criar a trigger para atualização da pessoa física */

CALL tasy_criar_trigger_pf_alt();

/*26/09/2011 - Criar a trigger para atualização do complemento de pessoa física*/

CALL tasy_criar_trigger_complpf_alt();

/*22/04/2013 - Criar a trigger para atualização da regra de via adicional na alteração de pessoa física. Coloqueri no ajustar base devido a OS 582995, para o tratamento do commit*/

CALL pls_criar_trigger_pf_via_adic();

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_criacao_trigger_alt_pf () FROM PUBLIC;

