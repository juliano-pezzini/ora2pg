-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_estrutura_cbhpm () AS $body$
BEGIN

update area_procedimento a
set	ie_origem_proced	=
	(SELECT coalesce(min(b.ie_origem_proced),1)
	from	estrutura_procedimento_v b
	where	a.cd_area_procedimento	= b.cd_area_procedimento)
where	coalesce(ie_origem_proced::text, '') = '';

update area_procedimento
set	cd_original	= cd_area_procedimento
where	coalesce(cd_original::text, '') = '';
commit;

update especialidade_proc a
set	ie_origem_proced	=
	(SELECT coalesce(min(b.ie_origem_proced),1)
	from	estrutura_procedimento_v b
	where	a.cd_especialidade	= b.cd_especialidade)
where	coalesce(a.ie_origem_proced::text, '') = '';

update especialidade_proc
set	cd_original	= cd_especialidade
where	coalesce(cd_original::text, '') = '';
commit;

update grupo_proc a
set	ie_origem_proced	=
	(SELECT coalesce(min(b.ie_origem_proced),1)
	from	estrutura_procedimento_v b
	where	a.cd_grupo_proc	= b.cd_grupo_proc)
where	coalesce(a.ie_origem_proced::text, '') = '';

update grupo_proc
set	cd_original	= cd_grupo_proc
where	coalesce(cd_original::text, '') = '';
commit;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_estrutura_cbhpm () FROM PUBLIC;
