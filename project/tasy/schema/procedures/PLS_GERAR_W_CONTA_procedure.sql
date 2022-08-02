-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_conta ( nr_seq_protocolo_p bigint, nr_seq_prestador_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_protocolo_w	bigint;
nr_seq_pls_conta_w	bigint;
nr_seq_item_w		bigint;
nr_seq_conta_w		bigint;
cd_guia_w		varchar(20);
cd_senha_w		varchar(20);
nm_segurado_w		varchar(255);
cd_usuario_plano_w	varchar(20);	
vl_cobrado_w		double precision;
vl_total_w		double precision;
vl_glosa_conta_w	double precision;
cd_motivo_glosa_conta_w	varchar(20);
cd_grau_partic_w	varchar(2);
dt_item_w		timestamp;
ds_item_w		varchar(255);
cd_tabela_item_w	varchar(2);
cd_item_w		bigint;
qt_item_w		double precision;
vl_item_w		double precision;
vl_liberado_item_w	double precision;
vl_glosa_item_w		double precision;
cd_motivo_glosa_item_w	varchar(20);
count_w			bigint := 0;

cd_ans_w		varchar(50);
ds_operadora_w		varchar(255);
cd_cgc_operadora_w	varchar(20);
nr_demonstrativo_w	varchar(50);
cd_prestador_w		varchar(50);
cd_cgc_prestador_w	varchar(20);	
nr_cpf_prestador_w	varchar(50);
ds_prestador_w		varchar(255);
cd_cnes_prestador_w	varchar(50);
nr_fatura_w		varchar(50);
nr_lote_w		varchar(50);
dt_envio_lote_w		timestamp;
nr_protocolo_w		varchar(50);
vl_fatura_w		double precision;
vl_lib_fatura_w		double precision;
vl_glosa_fatura_w	double precision;
dt_pagamento_w		timestamp;
ie_forma_pagto_w	varchar(5);
cd_banco_w		varchar(20);		
cd_agencia_w		varchar(20);
nr_conta_w		varchar(50);
nr_seq_lote_pgto_w	bigint;
dt_mes_competencia_w	timestamp;
nr_seq_evento_w		bigint;
ds_evento_w		varchar(255);
qt_registros_w		bigint := 0;
nr_seq_pagamento_w	bigint;

cd_ans_ww		varchar(50);
nm_fantasia_w		varchar(255);
cd_cgc_outorgante_w	varchar(255);
nr_seq_prestador_w	bigint;
cd_cgc_w		varchar(14);
nr_cpf_w		varchar(11);
nm_pessoa_w		varchar(255);
cd_cnes_w		varchar(255);
nr_protocolo_prestador_w	varchar(255);
dt_protocolo_w		timestamp;
vl_cobrado_ww		double precision;
vl_glosado_ww		double precision;
vl_total_ww		double precision;
cd_estabelecimento_w	bigint;

c01 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.cd_guia, 
	a.cd_senha, 
	substr(pls_obter_dados_segurado(a.nr_seq_segurado,'N'),1,255), 
	substr(pls_obter_dados_segurado(a.nr_seq_segurado,'C'),1,30), 
	a.vl_cobrado, 
	a.vl_total, 
	a.vl_glosa 
from	pls_conta a 
Where	a.nr_seq_protocolo	= nr_seq_protocolo_p;

c02 CURSOR FOR 
SELECT	a.dt_procedimento, 
	substr(obter_descricao_procedimento(a.cd_procedimento,a.ie_origem_proced),1,255), 
	b.cd_tabela_xml, 
	a.cd_procedimento, 
	a.qt_procedimento, 
	a.vl_procedimento, 
	a.vl_liberado, 
	a.vl_glosa 
FROM pls_conta_proc a
LEFT OUTER JOIN tiss_tipo_tabela b ON (a.nr_seq_tiss_tabela = b.nr_sequencia)
WHERE a.nr_seq_conta		= nr_seq_conta_w 
 
union
 
SELECT	a.dt_atendimento, 
	substr(obter_descricao_padrao('PLS_MATERIAL','DS_MATERIAL',a.nr_seq_material),1,255), 
	b.cd_tabela_xml, 
	c.cd_material, 
	a.qt_material, 
	a.vl_material, 
	a.vl_liberado, 
	a.vl_glosa 
FROM pls_material c, pls_conta_mat a
LEFT OUTER JOIN tiss_tipo_tabela b ON (a.nr_seq_tiss_tabela = b.nr_sequencia)
WHERE a.nr_seq_material	= c.nr_sequencia and a.nr_seq_conta		= nr_seq_conta_w;

C03 CURSOR FOR 
	SELECT	nr_seq_evento, 
		substr(pls_obter_desc_evento(nr_seq_evento),1,255), 
		vl_item, 
		dt_atualizacao 
	from	pls_pagamento_item 
	where	nr_seq_pagamento	= nr_seq_pagamento_w;


BEGIN 
 
delete	from 	w_pls_protocolo 
where	nm_usuario	= nm_usuario_p;
 
delete	from 	w_pls_conta 
where	nm_usuario	= nm_usuario_p;
 
delete	from 	w_pls_item 
where	nm_usuario	= nm_usuario_p;
 
select	nextval('w_pls_protocolo_seq') 
into STRICT	nr_seq_protocolo_w
;
 
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then 
	select	b.cd_ans, 
		b.nm_fantasia, 
		b.cd_cgc_outorgante, 
		c.nr_sequencia, 
		c.cd_cgc, 
		obter_cpf_pessoa_fisica(c.cd_pessoa_fisica), 
		substr(obter_nome_pf_pj(c.cd_pessoa_fisica, c.cd_cgc),1,254), 
		CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN  substr(obter_dados_pf_pj(null,c.cd_cgc, 'CNES'),1,20)  ELSE substr(obter_dados_pf(c.cd_pessoa_fisica,'CNES'),1,20) END , 
		Somente_Numero(a.nr_protocolo_prestador), 
		a.dt_protocolo, 
		coalesce(pls_obter_valor_protocolo(a.nr_sequencia,'C'),0), 
		coalesce(pls_obter_valor_protocolo(a.nr_sequencia,'G'),0), 
		coalesce(pls_obter_valor_protocolo(a.nr_sequencia,'T'),0), 
		a.cd_estabelecimento 
	into STRICT	cd_ans_ww, 
		nm_fantasia_w, 
		cd_cgc_outorgante_w, 
		nr_seq_prestador_w, 
		cd_cgc_w, 
		nr_cpf_w, 
		nm_pessoa_w, 
		cd_cnes_w, 
		nr_protocolo_prestador_w, 
		dt_protocolo_w, 
		vl_cobrado_ww, 
		vl_glosado_ww, 
		vl_total_ww, 
		cd_estabelecimento_w 
	FROM pls_protocolo_conta a
LEFT OUTER JOIN pls_outorgante b ON (a.nr_seq_outorgante = b.nr_sequencia)
LEFT OUTER JOIN pls_prestador c ON (a.nr_seq_prestador = c.nr_sequencia)
WHERE a.nr_sequencia		= nr_seq_protocolo_p;
	 
	if (coalesce(cd_cgc_outorgante_w,'0') = '0') then 
		begin 
		select	a.cd_ans, 
			a.nm_fantasia, 
			a.cd_cgc_outorgante 
		into STRICT	cd_ans_ww, 
			nm_fantasia_w, 
			cd_cgc_outorgante_w 
		from	pls_outorgante a 
		where	a.cd_estabelecimento = cd_estabelecimento_w;
		exception 
		when others then 
			cd_ans_ww		:= null;
			nm_fantasia_w		:= null;
			cd_cgc_outorgante_w	:= null;
		end;
	end if;
	 
	insert	into w_pls_protocolo(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					cd_ans, ds_operadora, cd_cgc_operadora, nr_demonstrativo, dt_emissao, 
					cd_prestador, cd_cgc_prestador, nr_cpf_prestador, ds_prestador, cd_cnes_prestador, 
					nr_fatura, nr_lote, dt_envio_lote, nr_protocolo, vl_protocolo, 
					vl_glosa_protocolo, cd_glosa_protocolo, vl_fatura, vl_lib_fatura, vl_glosa_fatura, 
					vl_geral, vl_lib_geral, vl_glosa_geral, nr_seq_protocolo) 
			values (	nr_seq_protocolo_w, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					cd_ans_ww, nm_fantasia_w, cd_cgc_outorgante_w, nr_seq_protocolo_p, clock_timestamp(), 
					nr_seq_prestador_w, cd_cgc_w, nr_cpf_w, nm_pessoa_w, cd_cnes_w, 
					nr_seq_protocolo_p, nr_protocolo_prestador_w, dt_protocolo_w, nr_seq_protocolo_p, vl_cobrado_ww, 
					vl_glosado_ww, null, vl_cobrado_ww, vl_total_ww, vl_glosado_ww, 
					vl_cobrado_ww, vl_total_ww, vl_glosado_ww, nr_seq_protocolo_p);
 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_conta_w, 
		cd_guia_w, 
		cd_senha_w, 
		nm_segurado_w, 
		cd_usuario_plano_w, 
		vl_cobrado_w, 
		vl_total_w, 
		vl_glosa_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		select	max(substr(tiss_obter_motivo_glosa(b.nr_seq_motivo_glosa,'C'),1,255)) 
		into STRICT	cd_motivo_glosa_conta_w 
		from	pls_conta_glosa b 
		Where	b.nr_seq_conta	= nr_seq_conta_w;
 
		select	nextval('w_pls_conta_seq') 
		into STRICT	nr_seq_pls_conta_w 
		;
 
		begin 
		insert	into w_pls_conta( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_protocolo, 
			nr_seq_conta, 
			cd_guia, 
			cd_senha, 
			nm_segurado, 
			cd_segurado, 
			vl_conta, 
			vl_lib_conta, 
			vl_glosa_conta, 
			cd_glosa_conta) 
		values (nr_seq_pls_conta_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_protocolo_w, 
			nr_seq_conta_w, 
			cd_guia_w, 
			cd_senha_w, 
			nm_segurado_w, 
			cd_usuario_plano_w, 
			vl_cobrado_w, 
			vl_total_w, 
			vl_glosa_conta_w, 
			cd_motivo_glosa_conta_w);
		exception 
		when others then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267433,'NR_SEQ_PROTOCOLO_W=' || nr_seq_protocolo_w);
		end;
 
		open c02;
		loop 
		fetch c02 into 
			dt_item_w, 
			ds_item_w, 
			cd_tabela_item_w, 
			cd_item_w, 
			qt_item_w, 
			vl_item_w, 
			vl_liberado_item_w, 
			vl_glosa_item_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
 
			select	count(*) 
			into STRICT	count_w 
			from	w_pls_item 
			where	nr_seq_conta	= nr_seq_pls_conta_w;
 
			if (count_w >= 3)	then 
				select	nextval('w_pls_conta_seq') 
				into STRICT	nr_seq_pls_conta_w 
				;
 
				insert	into w_pls_conta( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_protocolo, 
					nr_seq_conta,	 
					cd_guia, 
					cd_senha, 
					nm_segurado, 
					cd_segurado, 
					vl_conta, 
					vl_lib_conta, 
					vl_glosa_conta, 
					cd_glosa_conta) 
				values (nr_seq_pls_conta_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_protocolo_w, 
					nr_seq_conta_w, 
					cd_guia_w, 
					cd_senha_w, 
					nm_segurado_w, 
					cd_usuario_plano_w, 
					vl_cobrado_w, 
					vl_total_w, 
					vl_glosa_conta_w, 
					cd_motivo_glosa_conta_w);	
 
				count_w := 0;
 
			end if;
 
			select	max(substr(tiss_obter_motivo_glosa(b.nr_seq_motivo_glosa,'C'),1,255)) 
			into STRICT	cd_motivo_glosa_item_w 
			from	pls_conta_glosa b 
			where 	b.nr_seq_conta_proc	= nr_seq_conta_w 
			or	b.nr_seq_conta_mat	= nr_seq_conta_w;
 
			select	max(a.cd_tiss) 
			into STRICT	cd_grau_partic_w 
			from	pls_grau_participacao a, 
				pls_proc_participante b, 
				pls_conta_proc c, 
				pls_conta d 
			where	a.nr_sequencia		= b.nr_seq_grau_partic 
			and	b.nr_seq_conta_proc	= c.nr_sequencia 
			and	c.nr_seq_conta		= d.nr_sequencia 
			and	d.ie_tipo_guia		= '6';
 
			select	nextval('w_pls_item_seq') 
			into STRICT	nr_seq_item_w 
			;
 
			insert	into w_pls_item( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					dt_item, 
					ds_item, 
					cd_tabela, 
					cd_item, 
					cd_grau_partic, 
					qt_item, 
					vl_item, 
					vl_lib_item, 
					vl_glosa_item, 
					cd_glosa_item, 
					nr_seq_conta) 
				values (nr_seq_item_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					dt_item_w, 
					ds_item_w, 
					cd_tabela_item_w, 
					cd_item_w, 
					cd_grau_partic_w, 
					qt_item_w, 
					vl_item_w, 
					vl_liberado_item_w, 
					vl_glosa_item_w, 
					cd_motivo_glosa_item_w, 
					nr_seq_pls_conta_w);		
 
		end loop;
		close c02;
 
		select	count(*) 
		into STRICT	count_w 
		from	w_pls_item 
		where	nr_seq_conta = nr_seq_pls_conta_w;
 
		while(count_w < 3) loop 
 
			select	nextval('w_pls_item_seq') 
			into STRICT	nr_seq_item_w 
			;
 
			insert	into w_pls_item( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_conta) 
				values (nr_seq_item_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_pls_conta_w);
 
			count_w := count_w + 1;
 
		end loop;
 
	end loop;
	close c01;
elsif (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') and (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then 
	begin 
	select	a.nr_sequencia, 
		trunc(a.dt_geracao_titulos), 
		a.dt_mes_competencia, 
		b.vl_pagamento, 
		b.nr_seq_prestador, 
		c.cd_cgc, 
		obter_cpf_pessoa_fisica(c.cd_pessoa_fisica), 
		substr(obter_nome_pf_pj(c.cd_pessoa_fisica, c.cd_cgc),1,254), 
		CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN  substr(obter_dados_pf_pj(null,c.cd_cgc, 'CNES'),1,20)  ELSE substr(obter_dados_pf(c.cd_pessoa_fisica,'CNES'),1,20) END , 
		d.cd_ans, 
		d.nm_fantasia, 
		d.cd_cgc_outorgante, 
		e.cd_agencia_bancaria, 
		e.cd_banco, 
		e.cd_conta, 
		b.nr_sequencia 
	into STRICT	nr_lote_w, 
		dt_mes_competencia_w, 
		dt_pagamento_w, 
		vl_fatura_w, 
		cd_prestador_w, 
		cd_cgc_prestador_w, 
		nr_cpf_prestador_w, 
		ds_prestador_w, 
		cd_cnes_prestador_w, 
		cd_ans_w, 
		ds_operadora_w, 
		cd_cgc_operadora_w, 
		cd_agencia_w, 
		cd_banco_w, 
		nr_conta_w, 
		nr_seq_pagamento_w 
	FROM pls_outorgante d, pls_prestador c, pls_lote_pagamento a, pls_pagamento_prestador b
LEFT OUTER JOIN banco_estabelecimento e ON (b.nr_seq_conta_banco = e.nr_sequencia)
WHERE b.nr_seq_prestador	= nr_seq_prestador_p and b.nr_seq_lote		= nr_seq_lote_p and b.nr_seq_prestador	= c.nr_sequencia and b.nr_seq_lote		= a.nr_sequencia and c.cd_estabelecimento	= d.cd_estabelecimento;
	exception 
	when others then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267432);
	end;
	 
	insert	into w_pls_protocolo(	 
			nr_sequencia,      
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_ans, 
			ds_operadora, 
			cd_cgc_operadora, 
			nr_demonstrativo,    
			dt_emissao, 
			cd_prestador, 
			cd_cgc_prestador, 
			nr_cpf_prestador, 
			ds_prestador, 
			cd_cnes_prestador, 
			nr_fatura, 
			nr_lote, 
			dt_envio_lote, 
			nr_protocolo, 
			vl_fatura, 
			vl_lib_fatura, 
			vl_glosa_fatura, 
			nr_seq_protocolo, 
			dt_pagamento, 
			ie_forma_pagto, 
			cd_banco, 
			cd_agencia, 
			nr_conta, 
			nr_seq_lote_pgto, 
			vl_geral, 
			vl_lib_geral, 
			vl_glosa_geral) 
		values (nr_seq_protocolo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_ans_w, 
			ds_operadora_w, 
			cd_cgc_operadora_w, 
			nr_seq_protocolo_w, 
			clock_timestamp(), 
			cd_prestador_w, 
			cd_cgc_prestador_w, 
			nr_cpf_prestador_w, 
			ds_prestador_w, 
			cd_cnes_prestador_w, 
			nr_lote_w, 
			nr_lote_w, 
			dt_mes_competencia_w, 
			nr_protocolo_w, 
			vl_fatura_w, 
			vl_fatura_w, 
			null, 
			null, 
			dt_pagamento_w, 
			ie_forma_pagto_w, 
			cd_banco_w, 
			cd_agencia_w, 
			nr_conta_w, 
			nr_lote_w, 
			vl_fatura_w, 
			vl_fatura_w, 
			null);
		 
	select	nextval('w_pls_conta_seq') 
	into STRICT	nr_seq_pls_conta_w 
	;
 
	insert	into	w_pls_conta( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_protocolo, 
			nr_seq_conta) 
		values (nr_seq_pls_conta_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_protocolo_w, 
			nr_seq_protocolo_w);
	 
	open C03;
	loop 
	fetch C03 into	 
		nr_seq_evento_w, 
		ds_evento_w, 
		vl_item_w, 
		dt_item_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		 
		select	nextval('w_pls_item_seq') 
		into STRICT	nr_seq_item_w 
		;
 
		insert	into w_pls_item( 
				nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_item, 
				ds_item, 
				cd_tabela, 
				cd_item, 
				cd_grau_partic, 
				qt_item, 
				vl_item, 
				vl_lib_item, 
				vl_glosa_item, 
				cd_glosa_item, 
				nr_seq_conta) 
			values (nr_seq_item_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				dt_item_w, 
				ds_evento_w, 
				null, 
				nr_seq_evento_w, 
				null, 
				1, 
				vl_item_w, 
				null, 
				null, 
				null, 
				nr_seq_pls_conta_w);
		 
		select	count(*) 
		into STRICT	count_w 
		from	w_pls_item 
		where	nr_seq_conta = nr_seq_pls_conta_w;
 
		while(count_w < 3) loop 
 
			select	nextval('w_pls_item_seq') 
			into STRICT	nr_seq_item_w 
			;
 
			insert	into w_pls_item( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_conta) 
				values (nr_seq_item_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_pls_conta_w);
 
			count_w := count_w + 1;
 
		end loop;
		 
		end;
	end loop;
	close C03;
	 
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_conta ( nr_seq_protocolo_p bigint, nr_seq_prestador_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

