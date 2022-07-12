-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pend_ass_parecer (nm_usuario_p text, nr_parecer_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w char(1)	:= 'N';


BEGIN
	SELECT coalesce(MAX('S'),'N')
        	INTO STRICT ie_retorno_w
        	FROM pep_item_Pendente WHERE nr_parecer        	= nr_parecer_p
	AND nr_seq_registro   	= nr_sequencia_p
        	AND ie_tipo_pendencia 	= 'A'
	AND nm_usuario        	= nm_usuario_p
        	AND ie_tipo_registro  	= 'RP' LIMIT 1;
	
RETURN ie_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pend_ass_parecer (nm_usuario_p text, nr_parecer_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

