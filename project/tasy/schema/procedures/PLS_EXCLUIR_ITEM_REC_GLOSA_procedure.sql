-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_item_rec_glosa ( ie_tipo_p text, nr_seq_ref_p bigint) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Excluir itens dos recursos de glosa
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionário [x] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P

'C' - Conta
'P' - Procedimento
'M' - Material

IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P -------IE_TIPO_P
Alterações:
-------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_conta_w		pls_rec_glosa_conta.nr_sequencia%type;	
ds_log_call_w		varchar(4000);
ds_log_w			varchar(255);
nm_usuario_w		usuario.nm_usuario%type := ' ';
nr_seq_rec_glosa_conta_w	pls_rec_glosa_conta.nr_sequencia%type;
nr_seq_rec_glosa_prot_w		pls_rec_glosa_protocolo.nr_sequencia%type;
qt_Count 			integer;

C01 CURSOR( ie_tipo_w text, nr_seq_w bigint ) FOR
	SELECT	nr_sequencia
	from	pls_rec_glosa_proc
	where	((ie_tipo_w = 'P' and nr_sequencia = nr_seq_w) or (ie_tipo_w = 'C' and nr_seq_conta_rec = nr_seq_w))
	
union all

	SELECT	nr_sequencia
	from	pls_rec_glosa_mat
	where	((ie_tipo_w = 'M' and nr_sequencia = nr_seq_w) or (ie_tipo_w = 'C' and nr_seq_conta_rec = nr_seq_w))
	order by
		nr_sequencia;
		
BEGIN

nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	select count(1)
	  into STRICT qt_Count 
	  from (
		SELECT 1 
		  from pls_analise_conta_item 
		 where nr_seq_glosa_conta_rec in (SELECT g.nr_sequencia from pls_rec_glosa_glosas g where nr_seq_proc_rec in ( select nr_sequencia from pls_rec_glosa_proc where nr_sequencia = nr_seq_ref_p))
		
union all

		select 1 from pls_analise_conta_item 
		 where nr_seq_glosa_conta_rec in (select g.nr_sequencia from pls_rec_glosa_glosas g where nr_seq_mat_rec in ( select nr_sequencia from pls_rec_glosa_mat where nr_sequencia = nr_seq_ref_p))
	) alias5;
	
	if (qt_Count > 0 ) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1071736);
	end if;

if (ie_tipo_p = 'P') then

	select 	a.nr_sequencia,
			b.nr_sequencia
	into STRICT	nr_seq_rec_glosa_conta_w,
			nr_seq_rec_glosa_prot_w
	from	pls_rec_glosa_conta a,
			pls_rec_glosa_protocolo b,
			pls_rec_glosa_proc c
	where	a.nr_seq_protocolo = b.nr_sequencia
	and		c.nr_seq_conta_rec = a.nr_sequencia
	and		c.nr_sequencia = nr_seq_ref_p;
	

	ds_log_w := 'Excluído procedimento recurso seq = '||nr_seq_ref_p||' - conta recurso = '||nr_seq_rec_glosa_conta_w;
	ds_log_call_w := substr(	' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
							' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);

	insert	into	pls_hist_rec_glosa( 	nr_sequencia, ds_log, dt_atualizacao,
				nm_usuario, ds_call_stack, nr_seq_protocolo,
				nr_seq_conta_rec, nr_seq_mat_rec, nr_seq_proc_rec,
				nr_seq_mot_lib_glosa)
		values (	nextval('pls_hist_rec_glosa_seq'), ds_log_w, clock_timestamp(), 
				nm_usuario_w, ds_log_call_w, nr_seq_rec_glosa_prot_w,
				null, null, null,
				null);
				
elsif (ie_tipo_p = 'M') then

	select 	a.nr_sequencia,
			b.nr_sequencia
	into STRICT	nr_seq_rec_glosa_conta_w,
			nr_seq_rec_glosa_prot_w
	from	pls_rec_glosa_conta a,
			pls_rec_glosa_protocolo b,
			pls_rec_glosa_mat c
	where	a.nr_seq_protocolo = b.nr_sequencia
	and		c.nr_seq_conta_rec = a.nr_sequencia
	and		c.nr_sequencia = nr_seq_ref_p;
	

	ds_log_w := 'Excluído material recurso - seq = '||nr_seq_ref_p||' - conta recurso = '||nr_seq_rec_glosa_conta_w;
	ds_log_call_w := substr(	' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
							' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);

	insert	into	pls_hist_rec_glosa( 	nr_sequencia, ds_log, dt_atualizacao,
				nm_usuario, ds_call_stack, nr_seq_protocolo,
				nr_seq_conta_rec, nr_seq_mat_rec, nr_seq_proc_rec,
				nr_seq_mot_lib_glosa)
		values (	nextval('pls_hist_rec_glosa_seq'), ds_log_w, clock_timestamp(), 
				nm_usuario_w, ds_log_call_w, nr_seq_rec_glosa_prot_w,
				null, null, null,
				null);


end if;

select	max(nr_sequencia)
into STRICT	nr_seq_conta_w
from	pls_rec_glosa_conta
where (ie_tipo_p = 'C' and nr_sequencia = nr_seq_ref_p);

for r_C01_w in C01( ie_tipo_p, nr_seq_ref_p ) loop
	begin
	--delete das filhas da pls_rec_glosa_proc
	select count(1)
	  into STRICT qt_Count 
	  from (
		SELECT 1 
		  from pls_analise_conta_item 
		 where nr_seq_glosa_conta_rec in (SELECT g.nr_sequencia from pls_rec_glosa_glosas g where nr_seq_proc_rec in ( select nr_sequencia from pls_rec_glosa_proc where nr_sequencia = r_C01_w.nr_sequencia))
		
union all

		select 1 from pls_analise_conta_item 
		 where nr_seq_glosa_conta_rec in (select g.nr_sequencia from pls_rec_glosa_glosas g where nr_seq_mat_rec in ( select nr_sequencia from pls_rec_glosa_mat where nr_sequencia = r_C01_w.nr_sequencia))
	) alias6;
	
	if (qt_Count > 0 ) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1071736);
	end if;

	delete FROM pls_rec_retorno_glosa where nr_seq_proc_imp in ( SELECT nr_sequencia from pls_rec_glosa_proc_imp where nr_sequencia = r_C01_w.nr_sequencia );
	delete FROM pls_rec_glosa_glosas where nr_seq_proc_rec in ( SELECT nr_sequencia from pls_rec_glosa_proc where nr_sequencia = r_C01_w.nr_sequencia );
	delete FROM pls_rec_glosa_glosas_imp where nr_seq_proc_imp in ( SELECT nr_sequencia from pls_rec_glosa_proc_imp where nr_sequencia = r_C01_w.nr_sequencia );
	--delete da pls_rec_glosa_proc
	delete FROM pls_rec_glosa_proc where nr_sequencia = r_C01_w.nr_sequencia;
	delete FROM pls_rec_glosa_proc_imp where nr_sequencia = r_C01_w.nr_sequencia;
	--delete das filhas da pls_rec_glosa_mat
	delete FROM pls_rec_retorno_glosa where nr_seq_mat_imp in ( SELECT nr_sequencia from pls_rec_glosa_mat_imp where nr_sequencia = r_C01_w.nr_sequencia );
	delete FROM pls_rec_glosa_glosas where nr_seq_mat_rec in ( SELECT nr_sequencia from pls_rec_glosa_mat where nr_sequencia = r_C01_w.nr_sequencia );
	delete FROM pls_rec_glosa_glosas_imp where nr_seq_mat_imp in ( SELECT nr_sequencia from pls_rec_glosa_mat_imp where nr_sequencia = r_C01_w.nr_sequencia );
	--delete da pls_rec_glosa_mat
	delete FROM pls_rec_glosa_mat where nr_sequencia = r_C01_w.nr_sequencia;
	delete FROM pls_rec_glosa_mat_imp where nr_sequencia = r_C01_w.nr_sequencia;
	end;
end loop;

if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') and (ie_tipo_p = 'C') then --Caso ie_tipo = C exclui a conta do recurso de glosa
	delete FROM pls_rec_glosa_anexo where nr_seq_conta_rec = nr_seq_conta_w;	
	delete FROM pls_rec_glosa_conta_aud where nr_seq_conta_rec = nr_seq_conta_w;
	delete FROM pls_rec_retorno_glosa where nr_seq_conta_imp = nr_seq_conta_w;
	delete FROM pls_rec_glosa_glosas where nr_seq_conta_rec = nr_seq_conta_w;
	delete FROM pls_rec_glosa_glosas_imp where nr_seq_conta_imp = nr_seq_conta_w;
	delete FROM pls_rec_glosa_conta where nr_sequencia = nr_seq_conta_w;
	delete FROM pls_rec_glosa_conta_imp where nr_sequencia = nr_seq_conta_w;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_item_rec_glosa ( ie_tipo_p text, nr_seq_ref_p bigint) FROM PUBLIC;

