-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_livro_aux_glosa ( cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
arq_texto_w			utl_file.file_type;
ds_erro_w			varchar(255);
ds_local_w			varchar(255);
nm_arquivo_w			varchar(255);
ds_mensagem_w			varchar(255);
nr_vetor_w			bigint	:= 0;
count_w				bigint	:= 0;

c_linha CURSOR FOR 
	SELECT	cd_guia || ';' || 
		cd_item || ';' || 
		ds_item || ';' || 
		dt_realizacao || ';' || 
		dt_aviso || ';' || 
		cd_carteira || ';' || 
		nm_beneficiario || ';' || 
		nm_prestador || ';' || 
		ds_operacao || ';' || 
		ds_tipo_proc || ';' || 
		ds_tipo_relacao || ';' || 
		ds_ato_cooperado || ';' || 
		ds_preco || ';' || 
		ds_regulamentacao || ';' || 
		ds_tipo_contratacao || ';' || 
		ds_segmentacao || ';' || 
		vl_evento || ';' || 
		vl_recuperacao || ';' || 
		dt_movimento || ';' || 
		cd_conta_deb || ';' || 
		cd_conta_cred ds_linha 
	from	w_ctb_livro_aux_glosa 
	where	nm_usuario	= nm_usuario_p;

c_valores CURSOR FOR 
	SELECT	a.cd_guia, 
		c.cd_procedimento cd_item, 
		c.ds_procedimento ds_item, 
		a.dt_atendimento dt_realizacao, 
		coalesce(a.dt_emissao,a.dt_atendimento_referencia) dt_aviso, 
		substr(pls_obter_dados_segurado(d.nr_sequencia, 'C'),1,30) cd_carteira, 
		substr(e.nm_pessoa_fisica,1,80) nm_beneficiario, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'N'),1,255) nm_prestador, 
		(SELECT	substr(x.ds_evento,1,100) 
		from	pls_evento		x 
		where	x.nr_sequencia	= b.nr_seq_evento) ds_operacao, 
		(select	substr(x.ds_grupo,1,255) 
		from	ans_grupo_despesa	x 
		where	x.nr_sequencia	= b.nr_seq_grupo_ans) ds_tipo_proc, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'TR'),1,255) ds_tipo_relacao, 
		substr(obter_valor_dominio(3418, b.ie_ato_cooperado),1,255) ds_ato_cooperado, 
		substr(obter_valor_dominio(1669, g.ie_preco),1,18) ds_preco, 
		substr(obter_valor_dominio(2157, g.ie_regulamentacao),1,255) ds_regulamentacao, 
		substr(obter_valor_dominio(1666, g.ie_tipo_contratacao),1,255) ds_tipo_contratacao, 
		substr(obter_valor_dominio(1665, g.ie_segmentacao),1,255) ds_segmentacao, 
		b.vl_liberado vl_evento, 
		/*(select	sum(r.vl_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
			(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) vl_evento,*/
 
		b.vl_glosa vl_recuperacao, 
		/*(select	sum(r.vl_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
			(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) vl_recuperacao,*/
 
		h.dt_mes_competencia dt_movimento, 
		/*(select	max(s.dt_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
			(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) dt_movimento,*/
 
		b.cd_classif_glosa_deb cd_conta_deb, 
		/*(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '2.1.1.1.1' 
		and	s.ie_debito_credito		= 'D' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_deb,*/
 
		b.cd_classif_glosa_cred cd_conta_cred 
		/*(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '4.1.1.1.1' 
		and	s.ie_debito_credito		= 'C' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_cred*/
 
	FROM pls_protocolo_conta h, pls_plano g, pessoa_fisica e, pls_segurado d, procedimento c, pls_conta_proc b, pls_conta a
LEFT OUTER JOIN pls_prestador f ON (a.nr_seq_prestador_exec = f.nr_sequencia)
WHERE h.nr_sequencia		= a.nr_seq_protocolo and a.nr_sequencia		= b.nr_seq_conta and c.cd_procedimento	= b.cd_procedimento and c.ie_origem_proced	= b.ie_origem_proced and d.nr_sequencia		= a.nr_seq_segurado and e.cd_pessoa_fisica	= d.cd_pessoa_fisica  and g.nr_sequencia		= a.nr_seq_plano and ((substr(b.cd_classif_glosa_deb,1,9) = '4.1.1.1.1') or (substr(b.cd_classif_glosa_cred,1,9) = '2.1.1.1.1')) and exists (select	1 
			from	movimento_contabil_doc		r, 
				lote_contabil			t 
			where	r.nr_lote_contabil		= t.nr_lote_contabil 
			and	b.nr_sequencia			= r.nr_documento 
			and	r.nm_tabela			= 'PLS_CONTA_PROC' 
			and	r.nm_atributo			= 'VL_GLOSA' 
			and	t.cd_estabelecimento		= cd_estabelecimento_p 
			and	t.dt_referencia between dt_inicial_p and dt_final_p) /*and	exists	(select	1 
			from	movimento_contabil_doc		r, 
				movimento_contabil		s, 
				lote_contabil			t 
			where	s.nr_sequencia			= r.nr_seq_movimento 
			and	s.nr_lote_contabil		= t.nr_lote_contabil 
			and	r.nr_lote_contabil		= t.nr_lote_contabil 
			and	b.nr_sequencia			= r.nr_documento 
			and	r.nm_tabela			= 'PLS_CONTA_PROC' 
			and	r.nm_atributo			= 'VL_GLOSA' 
			and	t.cd_estabelecimento		= cd_estabelecimento_p 
			and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
				(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
			and	t.dt_referencia between dt_inicial_p and dt_final_p)*/
 
union all
 
	select	a.cd_guia, 
		c.cd_material, 
		c.ds_material, 
		a.dt_atendimento dt_realizacao, 
		coalesce(a.dt_emissao,a.dt_atendimento_referencia) dt_aviso, 
		substr(pls_obter_dados_segurado(d.nr_sequencia, 'C'),1,30) cd_carteira, 
		substr(e.nm_pessoa_fisica,1,80) nm_beneficiario, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'N'),1,255) nm_prestador, 
		(select	substr(x.ds_evento,1,100) 
		from	pls_evento		x 
		where	x.nr_sequencia	= b.nr_seq_evento) ds_operacao, 
		(select	substr(x.ds_grupo,1,255) 
		from	ans_grupo_despesa	x 
		where	x.nr_sequencia	= b.nr_seq_grupo_ans) ds_tipo_proc, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'TR'),1,255) ds_tipo_relacao, 
		substr(obter_valor_dominio(3418, b.ie_ato_cooperado),1,255) ds_ato_cooperado, 
		substr(obter_valor_dominio(1669, g.ie_preco),1,18) ds_preco, 
		substr(obter_valor_dominio(2157, g.ie_regulamentacao),1,255) ds_regulamentacao, 
		substr(obter_valor_dominio(1666, g.ie_tipo_contratacao),1,255) ds_tipo_contratacao, 
		substr(obter_valor_dominio(1665, g.ie_segmentacao),1,255) ds_segmentacao, 
		b.vl_liberado vl_evento, 
		/*(select	sum(r.vl_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
			(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) vl_evento,*/
 
		b.vl_glosa vl_recuperacao, 
		/*(select	sum(r.vl_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
			(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) vl_recuperacao,*/
 
		h.dt_mes_competencia dt_movimento, 
		/*(select	max(s.dt_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
			(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) dt_movimento,*/
 
		b.cd_classif_glosa_deb cd_conta_deb, 
		/*(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '2.1.1.1.1' 
		and	s.ie_debito_credito		= 'D' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_deb,*/
 
		b.cd_classif_glosa_cred cd_conta_cred 
		/*(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '4.1.1.1.1' 
		and	s.ie_debito_credito		= 'C' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_cred*/
 
	FROM pls_protocolo_conta h, pls_plano g, pessoa_fisica e, pls_segurado d, pls_material c, pls_conta_mat b, pls_conta a
LEFT OUTER JOIN pls_prestador f ON (a.nr_seq_prestador_exec = f.nr_sequencia)
WHERE h.nr_sequencia		= a.nr_seq_protocolo and a.nr_sequencia		= b.nr_seq_conta and c.nr_sequencia		= b.nr_seq_material and d.nr_sequencia		= a.nr_seq_segurado and e.cd_pessoa_fisica	= d.cd_pessoa_fisica  and g.nr_sequencia		= a.nr_seq_plano and ((substr(b.cd_classif_glosa_deb,1,9) = '4.1.1.1.1') or (substr(b.cd_classif_glosa_cred,1,9) = '2.1.1.1.1')) and exists (select	1 
			from	movimento_contabil_doc		r, 
				lote_contabil			t 
			where	r.nr_lote_contabil		= t.nr_lote_contabil 
			and	b.nr_sequencia			= r.nr_documento 
			and	r.nm_tabela			= 'PLS_CONTA_MAT' 
			and	r.nm_atributo			= 'VL_GLOSA' 
			and	t.cd_estabelecimento		= cd_estabelecimento_p 
			and	t.dt_referencia between dt_inicial_p and dt_final_p);
	/*and	exists	(select	1 
			from	movimento_contabil_doc		r, 
				movimento_contabil		s, 
				lote_contabil			t 
			where	s.nr_sequencia			= r.nr_seq_movimento 
			and	s.nr_lote_contabil		= t.nr_lote_contabil 
			and	r.nr_lote_contabil		= t.nr_lote_contabil 
			and	b.nr_sequencia			= r.nr_documento 
			and	r.nm_tabela			= 'PLS_CONTA_MAT' 
			and	r.nm_atributo			= 'VL_GLOSA' 
			and	t.cd_estabelecimento		= cd_estabelecimento_p 
			and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'C') or 
				(substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'D')) 
			and	t.dt_referencia between dt_inicial_p and dt_final_p);*/
 
type 		fetch_array is table of c_valores%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_valores_w	vetor;

BEGIN 
open c_valores;
loop 
fetch c_valores bulk collect into s_array limit 1000;
	vetor_valores_w(i)	:= s_array;
	i			:= i + 1;
EXIT WHEN NOT FOUND; /* apply on c_valores */
end loop;
close c_valores;
 
delete	from w_ctb_livro_aux_glosa 
where	nm_usuario	= nm_usuario_p;
 
for i in 1..vetor_valores_w.count loop 
	begin 
	s_array	:= vetor_valores_w(i);
	 
	for z in 1..s_array.count loop 
		begin 
		insert into w_ctb_livro_aux_glosa(nm_usuario, 
			cd_estabelecimento, 
			dt_atualizacao, 
			cd_guia, 
			cd_item, 
			ds_item, 
			dt_realizacao, 
			dt_aviso, 
			cd_carteira, 
			nm_beneficiario, 
			nm_prestador, 
			ds_operacao, 
			ds_tipo_proc, 
			ds_tipo_relacao, 
			ds_ato_cooperado, 
			ds_preco, 
			ds_regulamentacao, 
			ds_tipo_contratacao, 
			ds_segmentacao, 
			vl_evento, 
			vl_recuperacao, 
			dt_movimento, 
			cd_conta_deb, 
			cd_conta_cred) 
		values (nm_usuario_p, 
			cd_estabelecimento_p, 
			clock_timestamp(), 
			s_array[z].cd_guia, 
			s_array[z].cd_item, 
			s_array[z].ds_item, 
			s_array[z].dt_realizacao, 
			s_array[z].dt_aviso, 
			s_array[z].cd_carteira, 
			s_array[z].nm_beneficiario, 
			s_array[z].nm_prestador, 
			s_array[z].ds_operacao, 
			s_array[z].ds_tipo_proc, 
			s_array[z].ds_tipo_relacao, 
			s_array[z].ds_ato_cooperado, 
			s_array[z].ds_preco, 
			s_array[z].ds_regulamentacao, 
			s_array[z].ds_tipo_contratacao, 
			s_array[z].ds_segmentacao, 
			s_array[z].vl_evento, 
			s_array[z].vl_recuperacao, 
			s_array[z].dt_movimento, 
			s_array[z].cd_conta_deb, 
			s_array[z].cd_conta_cred);
		 
		count_w	:= count_w + 1;
		 
		if (count_w = 1000) then 
			count_w	:= 0;
			 
			commit;
		end if;
		end;
	end loop;
	end;
end loop;
 
commit;
 
nm_arquivo_w	:= to_char(clock_timestamp(),'ddmmyyyy') || to_char(clock_timestamp(),'hh24') || to_char(clock_timestamp(),'mi') || to_char(clock_timestamp(),'ss') || nm_usuario_p || '.xls';
 
SELECT * FROM obter_evento_utl_file(1, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
 
begin 
arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W'); --arq_texto_w := utl_file.fopen('/srvfs03/FINANCEIRO/TASY/',nm_arquivo_w,'W'); 
exception
when others then 
	if (SQLSTATE = -29289) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299140);
	elsif (SQLSTATE = -29298) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299142);
	elsif (SQLSTATE = -29291) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299144);
	elsif (SQLSTATE = -29286) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299147);
	elsif (SQLSTATE = -29282) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299148);
	elsif (SQLSTATE = -29288) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299149);
	elsif (SQLSTATE = -29287) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299150);
	elsif (SQLSTATE = -29281) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299151);
	elsif (SQLSTATE = -29290) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299152);
	elsif (SQLSTATE = -29283) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299154);
	elsif (SQLSTATE = -29280) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299155);
	elsif (SQLSTATE = -29284) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299156);
	elsif (SQLSTATE = -29292) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299157);
	elsif (SQLSTATE = -29285) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(299158);
	else 
		ds_erro_w := wheb_mensagem_pck.get_texto(299159);
	end if;
	 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(186768,'DS_ERRO_W=' || ds_erro_w);
end;
 
for vetl in c_linha loop 
	begin 
	utl_file.put_line(arq_texto_w,vetl.ds_linha);
	utl_file.fflush(arq_texto_w);
	end;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_livro_aux_glosa ( cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
