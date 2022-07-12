-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_pos_esq_entidade (nm_tabela_p text,qt_pos_esq_atual_p bigint,qt_entidade_atual_p bigint,qt_entidade_p bigint) RETURNS bigint AS $body$
DECLARE

qt_pos_esq_w	bigint;


BEGIN
	if ( qt_entidade_atual_p in (1,qt_entidade_p))  or (coalesce(qt_entidade_atual_p::text, '') = '')  then
		qt_pos_esq_w := 0;
	else
		qt_pos_esq_w := qt_pos_esq_atual_p + (length(nm_tabela_p) * 8) + 80;
	end if;

	return qt_pos_esq_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_pos_esq_entidade (nm_tabela_p text,qt_pos_esq_atual_p bigint,qt_entidade_atual_p bigint,qt_entidade_p bigint) FROM PUBLIC;
