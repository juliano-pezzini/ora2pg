-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_arq_relat_email ( nr_seq_email_p pls_email.nr_sequencia%type, nr_seq_email_anexo_p pls_email_anexo.nr_sequencia%type) RETURNS PLS_EMAIL_PARAM_RELATORIO.NM_ANEXO%TYPE AS $body$
DECLARE

			
nm_anexo_w			pls_email_param_relatorio.nm_anexo%type;	
cd_relatorio_w			pls_email_param_relatorio.cd_relatorio%type;
cd_classif_relat_w		pls_email_param_relatorio.cd_classif_relat%type;


BEGIN

select	max(b.nm_anexo)
into STRICT	nm_anexo_w
from	pls_email_anexo a,
	pls_email_param_relatorio b
where	a.cd_relatorio = b.cd_relatorio
and	a.cd_classif_relat = b.cd_classif_relat
and	a.nr_seq_email = nr_seq_email_p
and	a.nr_sequencia = nr_seq_email_anexo_p;

if (coalesce(nm_anexo_w::text, '') = '') then 	
	select	cd_relatorio,
		cd_classif_relat
	into STRICT	cd_relatorio_w,
		cd_classif_relat_w
	from	pls_email_anexo
	where	nr_sequencia = nr_seq_email_anexo_p;
	
	nm_anexo_w	:= nr_seq_email_p || '_' || nr_seq_email_anexo_p || cd_relatorio_w|| cd_classif_relat_w;
end if;	

return nm_anexo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_arq_relat_email ( nr_seq_email_p pls_email.nr_sequencia%type, nr_seq_email_anexo_p pls_email_anexo.nr_sequencia%type) FROM PUBLIC;
