-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_consistir_conta ( nr_seq_ocorrencia_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_analise_w		bigint;
ie_proc_mat_w			varchar(3);
nr_seq_conta_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_glosa_w			bigint;

c01 CURSOR FOR 
	SELECT	a.nr_seq_analise, 
		null, 
		a.nr_sequencia, 
		null, 
		null 
	from	pls_conta a, 
		pls_ocorrencia_benef c 
	where	a.nr_sequencia = c.nr_seq_conta 
	and	coalesce(c.nr_seq_conta_proc::text, '') = '' 
	and	coalesce(c.nr_seq_conta_mat::text, '') = '' 
	and	coalesce(c.nr_seq_proc_partic::text, '') = '' 
	and	a.ie_status <> 'F' 
	and	c.nr_seq_ocorrencia = nr_seq_ocorrencia_p 
	and	ie_opcao_p = 'C' 
	group by 
		a.nr_seq_analise, 
		a.nr_sequencia 
	
union all
 
	SELECT	a.nr_seq_analise, 
		'P', 
		a.nr_sequencia, 
		b.nr_sequencia, 
		null 
	from	pls_conta_proc b, 
		pls_conta a, 
		pls_ocorrencia_benef c 
	where	a.nr_sequencia = b.nr_seq_conta 
	and	b.nr_sequencia = c.nr_seq_conta_proc 
	and	c.nr_seq_ocorrencia = nr_seq_ocorrencia_p 
	and	a.ie_status <> 'F' 
	and	ie_opcao_p = 'P' 
	group by 
		a.nr_seq_analise, 
		a.nr_sequencia, 
		b.nr_sequencia 
	
union all
 
	select	a.nr_seq_analise, 
		'M', 
		a.nr_sequencia, 
		null, 
		b.nr_sequencia 
	from	pls_conta_mat b, 
		pls_conta a, 
		pls_ocorrencia_benef c 
	where	a.nr_sequencia = b.nr_seq_conta 
	and	b.nr_sequencia = c.nr_seq_conta_mat 
	and	a.ie_status <> 'F' 
	and	c.nr_seq_ocorrencia = nr_seq_ocorrencia_p 
	and	ie_opcao_p = 'M' 
	group by 
		a.nr_seq_analise, 
		a.nr_sequencia, 
		b.nr_sequencia;


BEGIN 
 
if (nr_seq_ocorrencia_p IS NOT NULL AND nr_seq_ocorrencia_p::text <> '') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_analise_w, 
		ie_proc_mat_w, 
		nr_seq_conta_w, 
		nr_seq_conta_proc_w, 
		nr_seq_conta_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (coalesce(ie_proc_mat_w::text, '') = '') then 
			update	pls_ocorrencia_benef a 
			set	ie_situacao = 'I' 
			where	nr_seq_conta = nr_seq_conta_w 
			and	nr_seq_ocorrencia = nr_seq_ocorrencia_p 
			and	coalesce(nr_seq_conta_proc::text, '') = '' 
			and	coalesce(nr_seq_conta_mat::text, '') = '';
		 
			CALL pls_consistir_conta(nr_seq_conta_w,cd_estabelecimento_p,nm_usuario_p,'S','N','N',null,'S');
		else 
			nr_seq_glosa_w	:= null;
			if (ie_proc_mat_w = 'P') then 
 
				begin 
				select	a.nr_sequencia 
				into STRICT	nr_seq_ocorrencia_benef_w 
				from	pls_ocorrencia_benef a 
				where	a.nr_seq_conta_proc = nr_seq_conta_proc_w 
				and	a.nr_seq_ocorrencia = nr_seq_ocorrencia_p;
				exception 
					when others then 
					nr_seq_ocorrencia_benef_w	:= null;
				end;
			else 
				begin 
				select	a.nr_sequencia 
				into STRICT	nr_seq_ocorrencia_benef_w 
				from	pls_ocorrencia_benef a 
				where	a.nr_seq_conta_mat = nr_seq_conta_mat_w 
				and	a.nr_seq_ocorrencia = nr_seq_ocorrencia_p;
				exception 
					when others then 
					nr_seq_ocorrencia_benef_w	:= null;
				end;
				 
			end if;
			 
			update	pls_ocorrencia_benef 
			set	ie_situacao = 'I', 
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='U' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'S' END  
			where	nr_sequencia	= nr_seq_ocorrencia_benef_w;
 
			if (coalesce(nr_seq_glosa_w::text, '') = '') then 
				begin 
				select	a.nr_sequencia 
				into STRICT	nr_seq_glosa_w 
				from	pls_conta_glosa a 
				where	a.nr_seq_ocorrencia_benef	= nr_seq_ocorrencia_benef_w;
				exception 
				when others then 
					nr_seq_glosa_w	:= null;
				end;
			end if;
	 
			if (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '') then 
				update	pls_conta_glosa 
				set	ie_situacao		= 'I', 
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='U' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'S' END  
				where	nr_sequencia		= nr_seq_glosa_w;
			end if;
		 
			CALL pls_analise_consistir_item(	nr_seq_analise_w, 
							'RO', 
							null, 
							nr_seq_conta_w, 
							nr_seq_conta_proc_w, 
							nr_seq_conta_mat_w, 
							cd_estabelecimento_p, 
							nm_usuario_p);
		end if;
		end;
	end loop;
	close C01;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_consistir_conta ( nr_seq_ocorrencia_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

