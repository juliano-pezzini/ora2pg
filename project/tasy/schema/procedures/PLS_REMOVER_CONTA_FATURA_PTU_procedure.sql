-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_remover_conta_fatura_ptu ( nr_seq_pls_fatura_p pls_fatura.nr_sequencia%type, nr_seq_ptu_fatura_p ptu_fatura.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_commit_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_conta_sus_p pls_processo_conta.nr_sequencia%type) AS $body$
DECLARE

					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_registro_w			integer;
nr_seq_nota_cobr_w		ptu_nota_cobranca.nr_sequencia%type;
vl_fatura_w			pls_fatura.vl_fatura%type;
vl_total_ndc_w			pls_fatura.vl_total_ndc%type;
nr_fatura_w			ptu_fatura.nr_fatura%type;
nr_nota_credito_debito_w	ptu_fatura.nr_nota_credito_debito%type;
nr_seq_nota_cobr_rrs_w		ptu_nota_cobranca_rrs.nr_sequencia%type;
ie_tipo_arquivo_cob_w		ptu_fatura.ie_tipo_arquivo_cob%type;


BEGIN

if (nr_seq_ptu_fatura_p IS NOT NULL AND nr_seq_ptu_fatura_p::text <> '') then
	select	coalesce(vl_fatura, 0),
		coalesce(vl_total_ndc, 0)
	into STRICT	vl_fatura_w,
		vl_total_ndc_w
	from	pls_fatura
	where	nr_sequencia = nr_seq_pls_fatura_p;
	
	select	max(nr_fatura),
		max(nr_nota_credito_debito),
		coalesce(max(ie_tipo_arquivo_cob),'502')
	into STRICT	nr_fatura_w,
		nr_nota_credito_debito_w,
		ie_tipo_arquivo_cob_w
	from	ptu_fatura
	where	nr_sequencia = nr_seq_ptu_fatura_p;
	
	if (ie_tipo_arquivo_cob_w = '502') and (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_nota_cobr_w
		from	ptu_nota_cobranca
		where	nr_seq_conta	= nr_seq_conta_p
		and	nr_seq_fatura	= nr_seq_ptu_fatura_p;
		
	elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_nota_cobr_rrs_w
		from	ptu_nota_cobranca_rrs
		where	nr_seq_conta	= nr_seq_conta_p
		and	nr_seq_fatura	= nr_seq_ptu_fatura_p;
	
	elsif (nr_seq_conta_sus_p IS NOT NULL AND nr_seq_conta_sus_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_nota_cobr_rrs_w
		from	ptu_nota_cobranca_rrs
		where	nr_seq_conta_sus	= nr_seq_conta_sus_p
		and	nr_seq_fatura		= nr_seq_ptu_fatura_p;
	end if;
	
	if (nr_seq_nota_cobr_w IS NOT NULL AND nr_seq_nota_cobr_w::text <> '') then
		-- R505 - Complemento
		delete	FROM ptu_nota_complemento
		where	nr_seq_nota_cobr = nr_seq_nota_cobr_w;
		
		-- R504 - Itens detalhados do servico
		delete	FROM ptu_nota_servico_item
		where	nr_seq_nota_servico in (SELECT	nr_sequencia
						from	ptu_nota_servico
						where	nr_seq_nota_cobr = nr_seq_nota_cobr_w);
						
		delete	FROM ptu_nota_servico_proc
		where	nr_seq_nota_servico in (SELECT	nr_sequencia
						from	ptu_nota_servico
						where	nr_seq_nota_cobr = nr_seq_nota_cobr_w);
						
		delete	FROM ptu_nota_servico_mat
		where	nr_seq_nota_servico in (SELECT	nr_sequencia
						from	ptu_nota_servico
						where	nr_seq_nota_cobr = nr_seq_nota_cobr_w);
						
		-- R504 - Servicos (Procedimentos / Materiais)
		delete	FROM ptu_nota_servico
		where	nr_seq_nota_cobr = nr_seq_nota_cobr_w;
		
		-- R503 - Hospitalar (Complemento)
		delete	FROM ptu_nota_hosp_compl
		where 	nr_seq_nota_hosp in (	SELECT	nr_sequencia
						from	ptu_nota_hospitalar
						where	nr_seq_nota_cobr = nr_seq_nota_cobr_w);
						
		-- R503 - Hospitalar
		delete	FROM ptu_nota_hospitalar
		where 	nr_seq_nota_cobr = nr_seq_nota_cobr_w;
		
		-- R502 - Cobranca (Conta)
		delete	FROM ptu_nota_cobranca
		where	nr_sequencia = nr_seq_nota_cobr_w;
	end if;
	
	
	-- Reembolso e Ressarcimento ao SUS
	if (nr_seq_nota_cobr_rrs_w IS NOT NULL AND nr_seq_nota_cobr_rrs_w::text <> '') then
                -- Retirando integridade em PTU_NOTA_SERVICO_RRS

                -- PTUNSIM_PTUSRRS_FK -> PTU_NOTA_SERVICO_ITEM.NR_SEQ_NOTA_SERVICO_RRS refer PTU_NOTA_SERVICO_RRS (NR_SEQUENCIA)                
                delete  FROM ptu_nota_servico_item
                where   nr_seq_nota_servico_rrs in (    SELECT  x.nr_sequencia
                                                        from    ptu_nota_servico_rrs x
                                                        where   x.nr_seq_nota_cobr_rrs = nr_seq_nota_cobr_rrs_w);


		delete	FROM ptu_nota_servico_rrs
		where	nr_seq_nota_cobr_rrs in (	SELECT	x.nr_sequencia
							from	ptu_nota_cobranca_rrs	x
							where	x.nr_sequencia	= nr_seq_nota_cobr_rrs_w);
							
		delete	FROM ptu_nota_cobranca_rrs
		where	nr_sequencia	= nr_seq_nota_cobr_rrs_w;	
	end if;	
	
	-- R511 - Corpo fatura (Eventos)
	delete	FROM ptu_fatura_corpo
	where 	nr_seq_fatura = nr_seq_ptu_fatura_p;
	
	select	count(1)
	into STRICT	qt_registro_w
	from	ptu_nota_cobranca
	where	nr_seq_fatura = nr_seq_ptu_fatura_p;
	
	if (qt_registro_w > 0) and (nr_seq_nota_cobr_w IS NOT NULL AND nr_seq_nota_cobr_w::text <> '') then
		-- R505 - Complemento
		CALL ptu_gerar_nota_complemento(nr_seq_nota_cobr_w, nm_usuario_p);
	else	
		select	count(1)
		into STRICT	qt_registro_w
		from	ptu_nota_cobranca_rrs
		where	nr_seq_fatura	= nr_seq_ptu_fatura_p;
		
		if (qt_registro_w = 0) then
			-- R512 / R513 / R514 / R515 - Boleto
			delete 	FROM ptu_fatura_boleto
			where 	nr_seq_fatura = nr_seq_ptu_fatura_p;
			
			-- Historico
			delete 	FROM ptu_fatura_historico
			where 	nr_seq_fatura = nr_seq_ptu_fatura_p;
			
			-- Historico
			delete 	FROM ptu_a500_historico
			where 	nr_seq_fatura = nr_seq_ptu_fatura_p;
			
			-- R510 - Cedente
			delete	FROM ptu_fatura_cedente
			where	nr_seq_fatura = nr_seq_ptu_fatura_p;
			
			-- Conta exclusao
			delete	FROM ptu_fatura_conta_exc
			where	nr_seq_fatura = nr_seq_ptu_fatura_p;
		
			-- R501 - Fatura
			delete	FROM ptu_fatura
			where	nr_sequencia = nr_seq_ptu_fatura_p;
		end if;
	end if;
	
	if (vl_fatura_w = 0) then
		nr_fatura_w := null;
	end if;
	
	if (vl_total_ndc_w = 0) then
		nr_nota_credito_debito_w := null;
	end if;
	
	-- Documento 1 - Fatura
	if (nr_fatura_w IS NOT NULL AND nr_fatura_w::text <> '') and (coalesce(nr_nota_credito_debito_w::text, '') = '') then
		vl_fatura_w	:= vl_fatura_w + vl_total_ndc_w;
		vl_total_ndc_w	:= 0;
		
	-- Documento 2 - NDR
	elsif (coalesce(nr_fatura_w::text, '') = '') and (nr_nota_credito_debito_w IS NOT NULL AND nr_nota_credito_debito_w::text <> '') then
		vl_fatura_w	:= 0;
		vl_total_ndc_w	:= vl_fatura_w + vl_total_ndc_w;
		
	elsif (coalesce(nr_fatura_w::text, '') = '') and (coalesce(nr_nota_credito_debito_w::text, '') = '') then
		vl_fatura_w	:= 0;
		vl_total_ndc_w	:= 0;
	end if;
	
	update	ptu_fatura
	set	vl_total_fatura	= vl_fatura_w,
		vl_total_ndc	= vl_total_ndc_w
	where	nr_sequencia	= nr_seq_ptu_fatura_p;
	
	if (coalesce(ie_commit_p, 'N') = 'S') then
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_remover_conta_fatura_ptu ( nr_seq_pls_fatura_p pls_fatura.nr_sequencia%type, nr_seq_ptu_fatura_p ptu_fatura.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_commit_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_conta_sus_p pls_processo_conta.nr_sequencia%type) FROM PUBLIC;

