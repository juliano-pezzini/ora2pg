-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION execucao_prescricao_pck.get_estabelecimento () RETURNS varchar AS $body$
BEGIN
	return	wheb_usuario_pck.get_cd_estabelecimento;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION execucao_prescricao_pck.get_estabelecimento () FROM PUBLIC;