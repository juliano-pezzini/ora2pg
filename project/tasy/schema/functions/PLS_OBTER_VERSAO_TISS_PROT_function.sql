-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_versao_tiss_prot ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_prot_conta_imp_p pls_protocolo_conta_imp.nr_sequencia%type default null, nr_seq_conta_imp_p pls_conta_imp.nr_sequencia%type default null, nr_seq_conta_item_imp_p pls_conta_item_imp.nr_sequencia%type default null, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type default null, nr_seq_conta_p pls_conta.nr_sequencia%type default null, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE

 
-- O parametro nr_seq_analise_p está mantido como o primeiro parametro e os demais como default null 
-- desta forma as rotinas que utilizavam esta vão funcionar normalmente e as futuras apenas será preciso 
-- passar null no primeiro parametro e informar o que deseja. 
 
cd_versao_tiss_w	pls_protocolo_conta.cd_versao_tiss%type;
nr_seq_conta_w		pls_conta.nr_sequencia%type;
			

BEGIN 
 
-- protocolo de importação 
if (nr_seq_prot_conta_imp_p IS NOT NULL AND nr_seq_prot_conta_imp_p::text <> '') then 
 
	select	max(cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_protocolo_conta_imp 
	where	nr_sequencia = nr_seq_prot_conta_imp_p;
 
-- conta de importação 
elsif (nr_seq_conta_imp_p IS NOT NULL AND nr_seq_conta_imp_p::text <> '') then 
 
	select	max(a.cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_conta_imp b, 
		pls_protocolo_conta_imp a 
	where	b.nr_sequencia = nr_seq_conta_imp_p 
	and 	a.nr_sequencia = b.nr_seq_protocolo;
 
-- item da importação 
elsif (nr_seq_conta_item_imp_p IS NOT NULL AND nr_seq_conta_item_imp_p::text <> '') then 
 
	select	max(a.cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_conta_item_imp c, 
		pls_conta_imp b, 
		pls_protocolo_conta_imp a 
	where	c.nr_sequencia = nr_seq_conta_item_imp_p 
	and 	b.nr_sequencia = c.nr_seq_conta 
	and 	a.nr_sequencia = b.nr_seq_protocolo;
 
-- protocolo quente da conta 
elsif (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then 
 
	select	max(cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_protocolo_conta 
	where	nr_sequencia = nr_seq_protocolo_p;
 
-- conta quente 
elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then 
 
	select	max(a.cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_conta b, 
		pls_protocolo_conta a		 
	where	b.nr_sequencia = nr_seq_conta_p 
	and 	a.nr_sequencia = b.nr_seq_protocolo;
 
-- procedimento quente da conta 
elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then 
 
	select	max(a.cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_conta_proc c, 
		pls_conta b, 
		pls_protocolo_conta a 
	where	c.nr_sequencia = nr_seq_conta_proc_p 
	and 	b.nr_sequencia = c.nr_seq_conta 
	and	a.nr_sequencia = b.nr_seq_protocolo;
 
elsif (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then 
 
	select	pls_obter_conta_principal(a.cd_guia, a.nr_sequencia, a.nr_seq_segurado, a.nr_seq_prestador) 
	into STRICT	nr_seq_conta_w 
	from	pls_analise_conta a 
	where	a.nr_sequencia	= nr_seq_analise_p;
 
	select	max(a.cd_versao_tiss) 
	into STRICT	cd_versao_tiss_w 
	from	pls_conta b, 
		pls_protocolo_conta a		 
	where	b.nr_sequencia = nr_seq_conta_w 
	and 	a.nr_sequencia = b.nr_seq_protocolo;
end if;
 
if (coalesce(cd_versao_tiss_w::text, '') = '') then 
	cd_versao_tiss_w := '2.02.03';
end if;
 
return	cd_versao_tiss_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_versao_tiss_prot ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_prot_conta_imp_p pls_protocolo_conta_imp.nr_sequencia%type default null, nr_seq_conta_imp_p pls_conta_imp.nr_sequencia%type default null, nr_seq_conta_item_imp_p pls_conta_item_imp.nr_sequencia%type default null, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type default null, nr_seq_conta_p pls_conta.nr_sequencia%type default null, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type default null) FROM PUBLIC;
