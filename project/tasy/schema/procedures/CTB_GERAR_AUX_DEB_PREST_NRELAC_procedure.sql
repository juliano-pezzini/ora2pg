-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_aux_deb_prest_nrelac ( nm_usuario_p usuario.nm_usuario%type, cd_empresa_p empresa.cd_empresa%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dt_inicial_p ctb_livro_auxiliar.dt_inicial%type, dt_final_p ctb_livro_auxiliar.dt_final%type, dt_liberacao_p ctb_livro_auxiliar.dt_liberacao%type, ie_gerar_arquivo_p ctb_livro_auxiliar.ie_tipo_livro_ecd%type, nr_seq_regra_p ctb_livro_auxiliar.nr_sequencia%type) AS $body$
DECLARE

						
nr_contador_w		                bigint := 0;
ds_erro_w		                varchar(255);
ds_local_w		                varchar(255);
arq_texto_w		                utl_file.file_type;
ie_tipo_documento_w	                varchar(2);
nm_arquivo_w		                varchar(255);
ds_nome_livro_w		                varchar(255);
ds_periodo_w		                varchar(255);
nr_protocolo_ans_w	                pls_plano.nr_protocolo_ans%type;
ds_rotulo_w 		                varchar(4000);
nr_cpf_cnpj_w		                w_ctb_livro_aux_event_liq.nr_cpf_cnpj%type;
ie_classif_diops_w	                varchar(1);
nr_dif_data_w		                bigint := 0;
ie_tipo_segurado_w	                ctb_livro_auxiliar.ie_tipo_segurado%type;
ie_tipo_compartilhamento_w		pls_segurado_repasse.ie_tipo_compartilhamento%type;
ie_tipo_repasse_w			pls_segurado_repasse.ie_tipo_repasse%type;
dt_repasse_w				pls_segurado_repasse.dt_repasse%type;
dt_fim_repasse_w			pls_segurado_repasse.dt_fim_repasse%type;
ds_observacao_w		                varchar(255);
ds_observacao_item_w	                varchar(255);
ie_data_tipo_segurado_w			pls_parametros.ie_data_tipo_segurado%type;

c_linha CURSOR FOR
	SELECT	a.nm_prestador												|| ';' ||
		a.nr_cpf_cnpj												|| ';' ||
		substr(obter_valor_dominio(6,pls_obter_se_benef_remido(a.nr_seq_segurado,a.dt_contabilizacao)),1,255)	|| ';' ||
		a.ds_tipo_documento											|| ';' ||
		a.ds_tipo_relacao											|| ';' ||
		a.nr_titulo												|| ';' ||
		a.dt_vencimento												|| ';' ||
		a.vl_evento												|| ';' ||
		a.dt_contabilizacao											|| ';' ||
		a.ds_classif_diops 											|| ';' ||
		substr(pls_obter_se_corresp_assumida(a.ie_tipo_segurado,
			a.nr_protocolo_ans),1,255)									|| ';' ||
		substr(obter_valor_dominio(3579,a.ie_tipo_evento),1,255)						|| ';' ||
		a.ds_tipo_segurado											|| ';' ||
		substr(obter_valor_dominio(3384, a.ie_tipo_repasse), 1,255)						|| ';' ||
		substr(obter_valor_dominio(8980, a.ie_tipo_compartilhamento), 1,255)					|| ';' ||
		a.dt_inicio_compartilhamento										|| ';' ||
		a.dt_fim_compartilhamento										|| ';' ||
		a.ds_observacao ds_linha
	from	w_ctb_livro_aux_event_liq a
	where	nr_seq_reg_auxiliar = nr_seq_regra_p
	order by (nr_documento)::numeric;
		
c_titulo CURSOR FOR
	SELECT	obter_nome_pf_pj(t.cd_pessoa_fisica,t.cd_cgc) nm_prestador,
		t.cd_cgc cd_cgc,
		t.cd_pessoa_fisica cd_pessoa_fisica,
		p.ie_tipo_relacao ie_tipo_relacao,
		t.nr_titulo nr_titulo,
		t.nr_titulo nr_documento,
		t.dt_vencimento_atual dt_vencimento,
		(obter_saldo_titulo_pagar(t.nr_titulo,dt_final_p) - coalesce((SELECT sum(vl_imposto) from titulo_pagar_imposto i where i.nr_titulo = t.nr_titulo),0)) vl_evento,
		l.dt_mes_competencia dt_contabilizacao,
		l.nr_sequencia nr_sequencia_pag,
		a.nr_seq_prestador nr_seq_prestador,
		trunc(dt_vencimento_original,'month') dt_vencimento_original,
		s.ie_tipo_segurado ie_tipo_segurado,
		CASE WHEN n.ie_tipo_operacao='A' THEN 'SCA'  ELSE coalesce(n.nr_protocolo_ans, n.cd_scpa) END  nr_protocolo_ans,
		k.ie_tipo_grupo_ans,
                c.nr_seq_segurado nr_seq_segurado,
		CASE WHEN ie_data_tipo_segurado_w='P' THEN  r.dt_mes_competencia  ELSE (	select y.dt_procedimento										from    pls_conta_proc y										where   x.nr_seq_conta_proc = y.nr_sequencia										
union
										select  y.dt_atendimento										from    pls_conta_mat y										where   x.nr_seq_conta_mat = y.nr_sequencia) END  dt_ref_repasse,
		r.nr_seq_congenere
	FROM titulo_pagar t, pls_segurado s, pls_protocolo_conta r, pls_prestador p, pls_lote_pagamento l, pls_pagamento_prestador a, pls_conta c
LEFT OUTER JOIN pls_plano n ON (c.nr_seq_plano = n.nr_sequencia)
, pls_conta_medica_resumo x
LEFT OUTER JOIN ans_grupo_despesa k ON (x.nr_seq_grupo_ans = k.nr_sequencia)
WHERE a.nr_sequencia		= t.nr_seq_pls_pag_prest and l.nr_sequencia		= a.nr_seq_lote and p.nr_sequencia		= a.nr_seq_prestador and c.nr_seq_segurado	= s.nr_sequencia and x.nr_seq_prestador_pgto	= a.nr_seq_prestador and x.nr_seq_lote_pgto	= l.nr_sequencia and x.nr_seq_conta		= c.nr_sequencia and c.nr_seq_protocolo 	= r.nr_sequencia   and s.ie_tipo_segurado	in ('T','C','I','H') and t.ie_origem_titulo	= 20 and l.dt_mes_competencia < fim_dia(dt_final_p) and (coalesce(t.dt_liquidacao::text, '') = '' or t.dt_liquidacao > fim_dia(dt_final_p)) and ((coalesce(ie_tipo_segurado_w, 'X')	= coalesce(c.ie_tipo_segurado, 'X'))
	or (coalesce(ie_tipo_segurado_w, 'X')	= 'X'))
	
union all

	select	obter_nome_pf_pj(t.cd_pessoa_fisica,t.cd_cgc) nm_prestador,
		t.cd_cgc cd_cgc,
		t.cd_pessoa_fisica cd_pessoa_fisica,
		p.ie_tipo_relacao ie_tipo_relacao,
		t.nr_titulo nr_titulo,
		t.nr_titulo nr_documento,
		t.dt_vencimento_atual dt_vencimento,
		(obter_saldo_titulo_pagar(t.nr_titulo,dt_final_p) - coalesce((select sum(vl_imposto) from titulo_pagar_imposto i where i.nr_titulo = t.nr_titulo),0)) vl_evento,
		l.dt_mes_competencia dt_contabilizacao,
		l.nr_sequencia nr_sequencia_pag,
		a.nr_seq_prestador nr_seq_prestador,
		trunc(dt_vencimento_original,'month') dt_vencimento_original,
		s.ie_tipo_segurado ie_tipo_segurado,
		CASE WHEN n.ie_tipo_operacao='A' THEN 'SCA'  ELSE coalesce(n.nr_protocolo_ans, n.cd_scpa) END  nr_protocolo_ans,
		k.ie_tipo_grupo_ans nr_protocolo_ans,
                c.nr_seq_segurado nr_seq_segurado,
                CASE WHEN ie_data_tipo_segurado_w='P' THEN  r.dt_mes_competencia  ELSE (	select y.dt_atendimento										from    pls_rec_glosa_mat w,											pls_conta_mat     y										where   x.nr_seq_mat_rec = w.nr_sequencia										and     w.nr_seq_conta_mat = y.nr_sequencia										
union
										select  y.dt_procedimento										from    pls_rec_glosa_proc w,											pls_conta_proc     y										where   x.nr_seq_proc_rec = w.nr_sequencia										and     w.nr_seq_conta_proc = y.nr_sequencia) END  dt_ref_repasse,
		r.nr_seq_congenere
	FROM titulo_pagar t, pls_segurado s, pls_protocolo_conta r, pls_prestador p, pls_lote_pagamento l, pls_pagamento_prestador a, pls_conta c
LEFT OUTER JOIN pls_plano n ON (c.nr_seq_plano = n.nr_sequencia)
, pls_conta_rec_resumo_item x
LEFT OUTER JOIN ans_grupo_despesa k ON (x.nr_seq_grupo_ans = k.nr_sequencia)
WHERE a.nr_sequencia		= t.nr_seq_pls_pag_prest and l.nr_sequencia		= a.nr_seq_lote and p.nr_sequencia		= a.nr_seq_prestador and c.nr_seq_segurado	= s.nr_sequencia and x.nr_seq_prestador_pgto	= a.nr_seq_prestador and x.nr_seq_lote_pgto	= l.nr_sequencia and x.nr_seq_conta		= c.nr_sequencia and c.nr_seq_protocolo 	= r.nr_sequencia   and s.ie_tipo_segurado	in ('T','C','I','H') and t.ie_origem_titulo	= 20 and l.dt_mes_competencia < fim_dia(dt_final_p) and (coalesce(t.dt_liquidacao::text, '') = '' or t.dt_liquidacao > fim_dia(dt_final_p)) and ((coalesce(ie_tipo_segurado_w, 'X')	= coalesce(c.ie_tipo_segurado, 'X'))
	or (coalesce(ie_tipo_segurado_w, 'X')	= 'X'));

type vet_titulo is table of c_titulo%rowtype;
vet_titulo_w vet_titulo;		
		
BEGIN

CALL wheb_usuario_pck.set_ie_executar_trigger('N');

select	max(ie_tipo_segurado)
into STRICT	ie_tipo_segurado_w
from	ctb_livro_auxiliar
where	nr_sequencia = nr_seq_regra_p;

select	coalesce(max(a.ie_data_tipo_segurado),'A')
into STRICT	ie_data_tipo_segurado_w
from	pls_parametros a
where	a.cd_estabelecimento = cd_estabelecimento_p;

select	substr(obter_desc_expressao(922923),1,255)
into STRICT	ds_observacao_w
;

if (ie_gerar_arquivo_p = 'N') then

	delete
	from	w_ctb_livro_aux_event_liq a
	where	nr_seq_reg_auxiliar = nr_seq_regra_p;

	commit;

	ie_tipo_documento_w	:= 'TP';
	
	open c_titulo;
	loop
	fetch c_titulo bulk collect into vet_titulo_w limit 1000;
		begin
		
		for i in 1..vet_titulo_w.Count loop

			begin
	
			SELECT * FROM pls_obter_dados_repasse(	vet_titulo_w[i].dt_ref_repasse, vet_titulo_w[i].nr_seq_segurado, vet_titulo_w[i].nr_seq_congenere, ie_tipo_repasse_w, ie_tipo_compartilhamento_w, dt_repasse_w, dt_fim_repasse_w) INTO STRICT ie_tipo_repasse_w, ie_tipo_compartilhamento_w, dt_repasse_w, dt_fim_repasse_w;

			nr_cpf_cnpj_w:= vet_titulo_w[i].cd_cgc;
			
			if (coalesce(nr_cpf_cnpj_w, 0) = 0)then
				begin
				
				select	nr_cpf
				into STRICT	nr_cpf_cnpj_w
				from	pessoa_fisica
				where	cd_pessoa_fisica = vet_titulo_w[i].cd_pessoa_fisica  LIMIT 1;
				
				end;
			end if;
			
			nr_dif_data_w:=	(dt_final_p - vet_titulo_w[i].dt_vencimento_original);
			
			ie_classif_diops_w:= 	case	when(nr_dif_data_w < 0) then '0'
							when(nr_dif_data_w between 0 and 30) then '1'
							when(nr_dif_data_w between 31 and 60) then '2'
							when(nr_dif_data_w between 61 and 90) then '3'
							when(nr_dif_data_w between 91 and 120) then '4'
							when(nr_dif_data_w > 120) then '5'
						end;
			
			nr_contador_w		:= nr_contador_w + 1;
			
			ds_observacao_item_w	:= null;
			
			if (vet_titulo_w[i].ie_tipo_segurado in ('C','I','T')) then
				ds_observacao_item_w	:= ds_observacao_w;
			end if;
			
			insert into w_ctb_livro_aux_event_liq( nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nm_prestador,
					nr_cpf_cnpj,
					ie_tipo_relacao,
					ds_tipo_relacao,
					nr_titulo,
					dt_vencimento,
					vl_evento,
					dt_contabilizacao,							
					ds_classif_diops,
					nr_seq_reg_auxiliar,
					nr_linha,
					nr_protocolo_ans,
					nr_seq_prestador,
					ie_tipo_documento,
					ds_tipo_documento,
					nr_documento,
					ie_tipo_segurado,
					ds_tipo_segurado,
					nr_seq_segurado,
					ie_tipo_evento,
					ds_observacao,
                                        ie_tipo_compartilhamento,
                                        ie_tipo_repasse,
                                        dt_inicio_compartilhamento,
                                        dt_fim_compartilhamento)
				values (	nextval('w_ctb_livro_aux_event_liq_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					vet_titulo_w[i].nm_prestador,
					nr_cpf_cnpj_w,
					vet_titulo_w[i].ie_tipo_relacao,     
					obter_valor_dominio(1668,vet_titulo_w[i].ie_tipo_relacao),
					vet_titulo_w[i].nr_titulo,
					vet_titulo_w[i].dt_vencimento,
					vet_titulo_w[i].vl_evento,
					vet_titulo_w[i].dt_contabilizacao,							
					substr(obter_valor_dominio(8854,ie_classif_diops_w),1,255),	
					nr_seq_regra_p,
					nr_contador_w,
					vet_titulo_w[i].nr_protocolo_ans,
					vet_titulo_w[i].nr_seq_prestador,
					ie_tipo_documento_w,
					obter_valor_dominio(8372,ie_tipo_documento_w),
					vet_titulo_w[i].nr_titulo,
					vet_titulo_w[i].ie_tipo_segurado,
					substr(obter_valor_dominio(2406, vet_titulo_w[i].ie_tipo_segurado),1,255),
					vet_titulo_w[i].nr_seq_segurado,
					vet_titulo_w[i].ie_tipo_grupo_ans,
					ds_observacao_item_w,
                                        ie_tipo_compartilhamento_w,
                                        ie_tipo_repasse_w,
                                        dt_repasse_w,
                                        dt_fim_repasse_w
                                        );
				
			if (mod(nr_contador_w, 5000) = 0) then
				commit;
			end if;
			
			end;
		end loop;
		
		end;
	EXIT WHEN NOT FOUND; /* apply on c_titulo */
	end loop;
	close c_titulo;
	
	update	ctb_livro_auxiliar
	set	qt_registros	= nr_contador_w
	where	nr_sequencia	= nr_seq_regra_p;

	commit;
	
end if;

if (ie_gerar_arquivo_p = 'S') then
	begin
	nm_arquivo_w	:= 'RegAuxDebPresNaoRelacionados' || to_char(clock_timestamp(),'ddmmyyyyhh24miss') || nm_usuario_p || '.csv';
	ds_nome_livro_w	:= obter_desc_expressao(1073933);
	ds_periodo_w	:= wheb_mensagem_pck.get_texto(1108452,'DT_FINAL=' || dt_final_p || ';' || 'DT_LIBERACAO=' || dt_liberacao_p);
	ds_rotulo_w	:= obter_desc_expressao(1029319);
	
	SELECT * FROM obter_evento_utl_file(1, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
	
	arq_texto_w 	:= utl_file.fopen(ds_local_w,nm_arquivo_w,'W'); --arq_texto_w := utl_file.fopen('/srvfs03/FINANCEIRO/TASY/',nm_arquivo_w,'W');
	utl_file.put_line(arq_texto_w, ds_nome_livro_w);
	utl_file.put_line(arq_texto_w, ds_periodo_w);
	utl_file.put_line(arq_texto_w, ds_rotulo_w);
	utl_file.fflush(arq_texto_w);
	for vetl in c_linha loop
		begin
		utl_file.put_line(arq_texto_w,vetl.ds_linha);
		utl_file.fflush(arq_texto_w);
		end;
	end loop;
	end;
end if;

commit;

CALL wheb_usuario_pck.set_ie_executar_trigger('S');	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_aux_deb_prest_nrelac ( nm_usuario_p usuario.nm_usuario%type, cd_empresa_p empresa.cd_empresa%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dt_inicial_p ctb_livro_auxiliar.dt_inicial%type, dt_final_p ctb_livro_auxiliar.dt_final%type, dt_liberacao_p ctb_livro_auxiliar.dt_liberacao%type, ie_gerar_arquivo_p ctb_livro_auxiliar.ie_tipo_livro_ecd%type, nr_seq_regra_p ctb_livro_auxiliar.nr_sequencia%type) FROM PUBLIC;
