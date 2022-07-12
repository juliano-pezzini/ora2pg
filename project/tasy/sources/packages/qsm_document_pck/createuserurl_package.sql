-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION qsm_document_pck.createuserurl (nm_usuario_p text) RETURNS SETOF T_USER AS $body$
DECLARE


C01 CURSOR(nm_usuario_pc intpd_fila_transmissao.nm_usuario%type) FOR
    SELECT	a.nm_usuario user_id,
			obter_dados_pf(b.cd_pessoa_fisica, 'PNC') fullName
	from	usuario a,
			pessoa_fisica b
	where	a.nm_usuario		= nm_usuario_pc
	and		a.cd_pessoa_fisica	= b.cd_pessoa_fisica;

r_user_row_w		r_user_row;

BEGIN

for r_C01_w in C01(nm_usuario_p) loop
	begin
	r_user_row_w := qsm_document_pck.limpar_atributos_user(r_user_row_w);

	r_user_row_w.user_id		:= r_C01_w.user_id;
	r_user_row_w.fullName		:= r_C01_w.fullName;

	RETURN NEXT r_user_row_w;
	end;
end loop;

if (	coalesce(r_user_row_w.user_id::text, '') = '' and
	coalesce(r_user_row_w.fullName::text, '') = '') then
		r_user_row_w.user_id		:= nm_usuario_p;
		
		RETURN NEXT r_user_row_w;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION qsm_document_pck.createuserurl (nm_usuario_p text) FROM PUBLIC;
