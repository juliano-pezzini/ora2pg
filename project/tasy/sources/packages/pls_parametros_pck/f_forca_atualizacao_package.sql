-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--parametros_linha tipo_pls_parametro;
/* := tipo_pls_parametros/*(	null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null, null);*/
-- Procedure criada para for?ar a atualiza??o entre os parametros da mem?ria
-- e os da tabela pls_parametros. Pode ser utilizada, por exemplo, na trigger da tabela pls_parametros
CREATE OR REPLACE PROCEDURE pls_parametros_pck.f_forca_atualizacao ( forca_atu_p boolean default true) AS $body$
BEGIN
PERFORM set_config('pls_parametros_pck.forca_atualizacao', forca_atu_p, false);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_parametros_pck.f_forca_atualizacao ( forca_atu_p boolean default true) FROM PUBLIC;
