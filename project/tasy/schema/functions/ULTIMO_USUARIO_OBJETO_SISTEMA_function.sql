-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ultimo_usuario_objeto_sistema ( nm_objeto_p text ) RETURNS varchar AS $body$
DECLARE

nm_usuario_w varchar(15);


BEGIN

select	nm_usuario
into STRICT    nm_usuario_w
from	objeto_sistema_hist
where	nr_sequencia = (SELECT max(nr_sequencia)
                      from  objeto_sistema_hist
                      where nm_objeto = nm_objeto_p
                      and   trunc(dt_atualizacao)	= trunc(clock_timestamp()));


  RETURN nm_usuario_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ultimo_usuario_objeto_sistema ( nm_objeto_p text ) FROM PUBLIC;

