-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_dados_ocor_pck.pls_obter_qt_glosa ( nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type) RETURNS bigint AS $body$
DECLARE

 
qt_glosa_w		pls_conta_proc_v.qt_procedimento%type	:= 0;
qt_apresentada_w	pls_conta_proc_v.qt_procedimento_imp%type;

BEGIN
 
if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then 
	select	max(qt_procedimento_imp) 
	into STRICT	qt_apresentada_w 
	from	pls_conta_proc_v 
	where	nr_sequencia	= nr_seq_conta_proc_p;
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then 
	select	max(qt_material_imp) 
	into STRICT	qt_apresentada_w 
	from	pls_conta_mat_v 
	where	nr_sequencia	= nr_seq_conta_mat_p;
end if;
 
if (qt_apresentada_w > qt_liberada_p) then 
	qt_glosa_w	:= qt_apresentada_w - qt_liberada_p;
end if;
 
return	qt_glosa_w;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_dados_ocor_pck.pls_obter_qt_glosa ( nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type) FROM PUBLIC;