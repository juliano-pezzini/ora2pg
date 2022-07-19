-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cancelar_rec_glosa_solic ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE
 	

cd_cgc_prestador_imp	pls_guia_plano_lote_cancel.cd_cgc_prestador_imp%type;
cd_cpf_prestador_imp	pls_guia_plano_lote_cancel.cd_cpf_prestador_imp%type;
cd_prestador_imp		pls_guia_plano_lote_cancel.cd_prestador_imp%type;
nr_seq_prestador_imp_w	pls_prestador.nr_sequencia%type;
nr_seq_conta_rec_w		pls_rec_glosa_conta.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
ie_status_prot_w		pls_rec_glosa_protocolo.ie_status%type;
nr_seq_analise_recurso_w	pls_rec_glosa_conta.nr_seq_analise%type;
nr_seq_protocolo_recurso_w	pls_rec_glosa_protocolo.nr_sequencia%type;
cd_cgc_prestador_imp_w		pls_guia_plano_lote_cancel.cd_cgc_prestador_imp%type;
cd_cpf_prestador_imp_w		pls_guia_plano_lote_cancel.cd_cpf_prestador_imp%type;
cd_prestador_imp_w			pls_guia_plano_lote_cancel.cd_prestador_imp%type;
qt_contas_nao_cancel_w		pls_rec_glosa_conta.nr_sequencia%type;
qt_rec_w					integer := 0;

C01 CURSOR FOR
	SELECT	a.cd_guia_operadora_imp,
			a.cd_guia_prestador_imp	,
			a.nr_sequencia,
			a.nr_protocolo_imp
	from	pls_guia_plano_cancel a
	where	a.nr_seq_lote_cancel = nr_seq_lote_cancel_p;

C02 CURSOR(nr_seq_conta_rec_pc		pls_rec_glosa_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia
	from	pls_rec_glosa_proc
	where	nr_seq_conta_rec = nr_seq_conta_rec_pc;
	
C03 CURSOR(nr_seq_conta_rec_pc		pls_rec_glosa_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia
	from	pls_rec_glosa_mat
	where	nr_seq_conta_rec = nr_seq_conta_rec_pc;	
	
C04 CURSOR(	nr_seq_prot_pw 	pls_protocolo_conta.nr_sequencia%type) FOR
	SELECT	max(a.nr_sequencia) nr_sequencia
	from	pls_rec_glosa_conta a
	where	a.nr_seq_conta in (	SELECT  x.nr_sequencia
					from	pls_conta x
					where	x.nr_seq_protocolo = nr_seq_prot_pw
	)
	group by a.nr_seq_conta;				
			
	
procedure executa_cancelamento( nr_seq_conta_rec_pw  in pls_rec_glosa_conta.nr_sequencia%type,
				nr_seq_guia_lote_pw  in	pls_guia_plano_cancel.nr_sequencia%type) is
				
tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;				
				
BEGIN

	select 	max(nr_seq_analise),
			max(nr_seq_protocolo)
	into STRICT	nr_seq_analise_recurso_w,
			nr_seq_protocolo_recurso_w
	from	pls_rec_glosa_conta
	where 	nr_sequencia = nr_seq_conta_rec_pw;

	-- verificar status do protocolo
	select 	max(ie_status)
	into STRICT	ie_status_prot_w
	from 	pls_rec_glosa_protocolo
	where	nr_sequencia	= nr_seq_protocolo_recurso_w;
		
	--dominio 5828			
	if (ie_status_prot_w not in ('3','4','5','6','7')) then

		update	pls_rec_glosa_conta
		set		ie_status	= '3',
				dt_cancelamento	= clock_timestamp()
		where	nr_sequencia	= nr_seq_conta_rec_pw;
		
		if (nr_seq_analise_recurso_w IS NOT NULL AND nr_seq_analise_recurso_w::text <> '') then
			CALL pls_alterar_status_analise_cta(	nr_seq_analise_recurso_w, 'C', 'PLS_CANCELAR_RECURSO_GLOSA',
							nm_usuario_p, cd_estabelecimento_p);
		end if;
		
		Open C02( nr_seq_conta_rec_pw );
		loop
			tb_nr_sequencia_w.delete;
			
			fetch C02 bulk collect into tb_nr_sequencia_w
			limit pls_util_pck.qt_registro_transacao_w;
			
			exit when tb_nr_sequencia_w.count = 0;
			
			forall i in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
				update	pls_rec_glosa_proc
				set	ie_status = '5'
				where	nr_sequencia = tb_nr_sequencia_w(i);
			commit;
		end loop;
		close C02;
		
		Open C03( nr_seq_conta_rec_pw );
		loop
			tb_nr_sequencia_w.delete;
			
			fetch C03 bulk collect into tb_nr_sequencia_w
			limit pls_util_pck.qt_registro_transacao_w;
			
			exit when tb_nr_sequencia_w.count = 0;
			
			forall i in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
				update	pls_rec_glosa_mat
				set	ie_status = '5'
				where	nr_sequencia = tb_nr_sequencia_w(i);
			commit;
		end loop;
		close C03;
	
		--seta status de retorno como cancelado
		CALL pls_atualiza_status_canc_tiss( nr_seq_guia_lote_pw, 1, nm_usuario_p );
		
		select 	max(nr_sequencia)
		into STRICT	qt_contas_nao_cancel_w
		from	pls_rec_glosa_conta
		where	nr_seq_protocolo = nr_seq_protocolo_recurso_w
		and 	ie_status <> '3';
		
		--verifica se alguma conta no protocolo esta diferente de cancelada, caso nao tiver, entao necessita cancelar o protocolo de recurso tambem
		if (coalesce(qt_contas_nao_cancel_w::text, '') = '' ) then
			
			update 	pls_rec_glosa_protocolo
			set	ie_status	= '10'
			where	nr_sequencia	= nr_seq_protocolo_recurso_w;
		end if;
	else
		--seta status de retorno como nao cancelado, pois o status do recurso nao permite mais o cancelamento
		CALL pls_atualiza_status_canc_tiss( nr_seq_guia_lote_pw, 2, nm_usuario_p );
	end if;

end;	
	
begin

	select 	max(cd_cgc_prestador_imp),
			max(cd_cpf_prestador_imp),
			max(cd_prestador_imp)
	into STRICT	cd_cgc_prestador_imp_w,
			cd_cpf_prestador_imp_w,
			cd_prestador_imp_w		
	from 	pls_guia_plano_lote_cancel
	where	nr_sequencia = nr_seq_lote_cancel_p;

	nr_seq_prestador_imp_w	:= pls_obter_prestador_imp( cd_cgc_prestador_imp_w, cd_cpf_prestador_imp_w, cd_prestador_imp_w,
							   null, null, null, 'C', cd_estabelecimento_p, clock_timestamp());
							
	for r_c01_w in C01 loop
	
		if (r_c01_w.nr_protocolo_imp IS NOT NULL AND r_c01_w.nr_protocolo_imp::text <> '') then
			
			--passa o protocolo da conta medica que deu origem a recurso
			qt_rec_w := 0;
			for r_c04_w in c04(r_c01_w.nr_protocolo_imp) loop
			
				executa_cancelamento( r_c04_w.nr_sequencia, r_c01_w.nr_sequencia);
				qt_rec_w := qt_rec_w + 1;
			end loop;
				
			if (qt_rec_w = 0) then -- se nao encontrar o recurso, seta  status como guia inexistente
				CALL pls_atualiza_status_canc_tiss(r_c01_w.nr_sequencia, 3, nm_usuario_p );
			end if;	
			
		else
			if (r_c01_w.cd_guia_operadora_imp IS NOT NULL AND r_c01_w.cd_guia_operadora_imp::text <> '') then
				select  max(b.nr_sequencia)
				into STRICT	nr_seq_conta_rec_w
				from	pls_rec_glosa_protocolo a,
						pls_rec_glosa_conta b
				where 	a.nr_sequencia = b.nr_seq_protocolo
				and    a.nr_seq_prestador = nr_seq_prestador_imp_w
				and 	b.cd_guia_ref = r_c01_w.cd_guia_operadora_imp;
			
			elsif (r_c01_w.cd_guia_prestador_imp IS NOT NULL AND r_c01_w.cd_guia_prestador_imp::text <> '')  then
			
				select max(nr_sequencia)
				into STRICT	nr_seq_conta_w
				from 	pls_conta
				where 	cd_guia_prestador = r_c01_w.cd_guia_prestador_imp
				and 	nr_seq_prestador_exec = nr_seq_prestador_imp_w;

				if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
					select  max(b.nr_sequencia)					
					into STRICT	nr_seq_conta_rec_w
					from	pls_rec_glosa_protocolo a,
							pls_rec_glosa_conta b
					where 	a.nr_sequencia = b.nr_seq_protocolo
					and    a.nr_seq_prestador = nr_seq_prestador_imp_w
					and 	b.nr_seq_conta = nr_seq_conta_w;

				end if;
					
			end if;
			
			if (nr_seq_conta_rec_w IS NOT NULL AND nr_seq_conta_rec_w::text <> '') then
						
				executa_cancelamento( nr_seq_conta_rec_w, r_c01_w.nr_sequencia);
				
			else -- se nao encontrar o recurso, seta  status como guia inexistente
				CALL pls_atualiza_status_canc_tiss(r_c01_w.nr_sequencia, 3, nm_usuario_p );
			end if;		
		end if;
	end loop;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cancelar_rec_glosa_solic ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;

