-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_hemoc_lib ( Nr_seq_regra_p bigint, Nr_seq_solic_sangue_p bigint, Nm_usuario_p text, ie_funcao_prescritor_p text) RETURNS varchar AS $body$
DECLARE

			 
ie_espec_lib_w		varchar(1) := 'S';
cd_pessoa_fisica_w	varchar(10);
qt_reg_w		bigint;

BEGIN
 
select	coalesce(max(cd_pessoa_fisica),0) 
into STRICT	cd_pessoa_fisica_w 
from	usuario 
where	nm_usuario = nm_usuario_p;
 
 
Select	count(*) 
into STRICT	qt_reg_w 
from	proced_derivado_regra 
where	nr_seq_regra = nr_seq_regra_p;
 
if (qt_reg_w > 0) then 
	Select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_espec_lib_w 
	from	proced_derivado_regra 
	where	nr_seq_regra = nr_seq_regra_p 
	and	((coalesce(ie_funcao_prescritor::text, '') = '') or (ie_funcao_prescritor_p = ie_funcao_prescritor)) 
	and 	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_pessoa_fisica_w, cd_especialidade) = 'S'));
end if;
 
return	ie_espec_lib_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_hemoc_lib ( Nr_seq_regra_p bigint, Nr_seq_solic_sangue_p bigint, Nm_usuario_p text, ie_funcao_prescritor_p text) FROM PUBLIC;

