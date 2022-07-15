-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_parametros_quimio ( nm_usuario_p text, ie_libera_intercorrencia_p INOUT text, ie_libera_medicamento_p INOUT text ) AS $body$
DECLARE


ie_libera_intercorrencia_w	varchar(1) := 'N';
ie_libera_medicamento_w	varchar(1) := 'N';


BEGIN

	select	coalesce(ie_libera_intercorrencia, 'N'),
		coalesce(ie_libera_medicamento, 'N')
	into STRICT	ie_libera_intercorrencia_w,
		ie_libera_medicamento_w
	from	parametros_quimio;

ie_libera_intercorrencia_p	:= ie_libera_intercorrencia_w;
ie_libera_medicamento_p	:= ie_libera_medicamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_parametros_quimio ( nm_usuario_p text, ie_libera_intercorrencia_p INOUT text, ie_libera_medicamento_p INOUT text ) FROM PUBLIC;

