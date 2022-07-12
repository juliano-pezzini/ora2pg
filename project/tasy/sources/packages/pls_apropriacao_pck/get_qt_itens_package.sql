-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_apropriacao_pck.get_qt_itens () RETURNS bigint AS $body$
BEGIN
	if (current_setting('pls_apropriacao_pck.ie_gerando_conta_proc_mat_w')::varchar(255) = 'P') then
		if (current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.qt_procedimento = 0 and
		    coalesce(current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.ie_glosa, 'N') = 'N') then
			return current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.qt_procedimento_imp;
		else
			return current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.qt_procedimento - current_setting('pls_apropriacao_pck.qt_itens_nao_cobrar_w')::pls_conta_proc.qt_procedimento%type;
		end if;
	elsif (current_setting('pls_apropriacao_pck.ie_gerando_conta_proc_mat_w')::varchar(255) = 'M') then
		if (current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.qt_material = 0 and
		    coalesce(current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.ie_glosa, 'N') = 'N') then
			return current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.qt_material_imp;
		else
			return current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.qt_material;
		end if;
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_apropriacao_pck.get_qt_itens () FROM PUBLIC;