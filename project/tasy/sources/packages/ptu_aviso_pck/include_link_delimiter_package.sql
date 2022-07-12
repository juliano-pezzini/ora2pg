-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- Verifica se precisa colocar o "/" no final do link



CREATE OR REPLACE FUNCTION ptu_aviso_pck.include_link_delimiter ( ds_link_p text ) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Verifica o link passado, e inclui o "/" no final, caso nao possuir
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_retorno_w	varchar(4000);

BEGIN


ds_retorno_w := ds_link_p;

if (ds_link_p IS NOT NULL AND ds_link_p::text <> '') and (substr(ds_link_p, length(ds_link_p), 1) != '/') then
	
	ds_retorno_w := ds_retorno_w ||'/';
end if;


return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.include_link_delimiter ( ds_link_p text ) FROM PUBLIC;