-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_stat_pag_proc_partic ( ie_glosa_p pls_proc_participante.ie_glosa%type, vl_participante_p pls_proc_participante.vl_participante%type, vl_glosa_p pls_proc_participante.vl_glosa%type) RETURNS varchar AS $body$
BEGIN
-- foi descontinuada, agora existe a pls_obter_stat_pag_item
return null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_stat_pag_proc_partic ( ie_glosa_p pls_proc_participante.ie_glosa%type, vl_participante_p pls_proc_participante.vl_participante%type, vl_glosa_p pls_proc_participante.vl_glosa%type) FROM PUBLIC;
