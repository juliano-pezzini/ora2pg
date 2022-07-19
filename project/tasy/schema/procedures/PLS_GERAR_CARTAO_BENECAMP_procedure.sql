-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_cartao_benecamp ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_segurado_w		bigint;
ds_header_w			varchar(4000);
ds_sub_header_w			varchar(4000);
cd_usuario_plano_w		varchar(30);
nm_beneficiario_w		varchar(250);
dt_nascimento_w			varchar(20);
ds_abrangencia_w		varchar(50);
ds_registro_ans_w		varchar(50);
ds_acomodacao_w			varchar(50);
nm_empresa_w			varchar(60);
ds_carencia_ww			varchar(4000);	
ds_carencia_w			varchar(4000);
ds_observacao_1_w		varchar(100) := ' ';
ds_trilha_2_w			varchar(40);
ds_trilha_1_w			varchar(100);
ds_segmentacao_w		varchar(100);
nr_seq_plano_w			bigint;

C01 CURSOR FOR 
	SELECT	b.nr_sequencia 
	from	pls_segurado_carteira	a, 
		pls_segurado		b, 
		pls_carteira_emissao	c, 
		pls_lote_carteira	d 
	where	a.nr_seq_segurado	= b.nr_sequencia 
	and	c.nr_seq_seg_carteira	= a.nr_sequencia 
	and	c.nr_seq_lote		= d.nr_sequencia 
	and	d.nr_sequencia		= nr_seq_lote_p;

BEGIN 
 
ds_header_w	:= 	'CÓDIGO_BENEFICIÁRIO;BENEFICIÁRIO;PRODUTO;ABRAMGÊNCIA;ACOMODAÇÃO;DT_NASC;OBSTETRICIA;PAGADOR;CARÊNCIA_1;' || 
			'CARÊNCIA_2;CARÊNCIA_3;CARÊNCIA_4;CARÊNCIA_5;CARÊNCIA_6;CARÊNCIA_7;CARÊNCIA_8;CARÊNCIA_9;CARÊNCIA_10;'|| 
			'CARÊNCIA_11;CARÊNCIA_12;MENSAGEM;TARJA_MAGNÉTICA_TRILHA1;TARJA_MAGNÉTICA_TRILHA2';
 
 
delete	FROM w_pls_interface_carteira 
where	nr_seq_lote	= nr_seq_lote_p;
 
insert into w_pls_interface_carteira(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec, 
		nr_seq_lote,ds_header,ie_tipo_reg) 
values (	nextval('w_pls_interface_carteira_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p, 
		nr_seq_lote_p,ds_header_w,1);
 
open C01;
loop 
fetch C01 into 
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_observacao_1_w	:= ' ';
	 
	select	c.cd_usuario_plano, 
		a.nm_pessoa_fisica, 
		to_char(a.dt_nascimento,'dd/mm/yyyy'), 
		CASE WHEN d.ie_acomodacao='I' THEN 'Individual' WHEN d.ie_acomodacao='C' THEN 'Coletivo' WHEN d.ie_acomodacao='N' THEN 'Nenhum' END , 
		CASE WHEN d.ie_regulamentacao='R' THEN 'Não Regulamentado'  ELSE 'Regulamentado' END , 
		upper(Obter_Valor_Dominio(1667,d.ie_abrangencia)), 
		replace(ds_trilha2,';',''), 
		ds_trilha1, 
		CASE WHEN a.ie_sexo='M' THEN 'Nao'  ELSE CASE WHEN d.ie_segmentacao='1' THEN 'Nao' WHEN d.ie_segmentacao='2' THEN 'Sim' WHEN d.ie_segmentacao='3' THEN 'Nao' WHEN d.ie_segmentacao='4' THEN 'Nao' WHEN d.ie_segmentacao='5' THEN 'Sim' WHEN d.ie_segmentacao='6' THEN 'Sim' WHEN d.ie_segmentacao='7' THEN 'Nao' WHEN d.ie_segmentacao='8' THEN 'Nao' WHEN d.ie_segmentacao='9' THEN 'Sim' WHEN d.ie_segmentacao='10' THEN 'Nao' WHEN d.ie_segmentacao='11' THEN 'Sim' WHEN d.ie_segmentacao='12' THEN 'Nao' END  END , 
		CASE WHEN coalesce(f.cd_cgc::text, '') = '' THEN  obter_nome_pf(f.cd_pessoa_fisica)  ELSE obter_nome_fantasia_pj(f.cd_cgc) END  nm_pagador, 
		d.nr_sequencia 
	into STRICT	cd_usuario_plano_w, 
		nm_beneficiario_w, 
		dt_nascimento_w, 
		ds_acomodacao_w, 
		ds_registro_ans_w, 
		ds_abrangencia_w, 
		ds_trilha_2_w, 
		ds_trilha_1_w, 
		ds_segmentacao_w, 
		nm_empresa_w, 
		nr_seq_plano_w 
	from	pls_contrato_pagador	f, 
		pls_plano		d, 
		pls_segurado_carteira	c, 
		pls_segurado		b, 
		pessoa_fisica		a 
	where	c.nr_seq_segurado	= b.nr_sequencia 
	and	b.nr_seq_plano		= d.nr_sequencia 
	and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	b.nr_seq_pagador	= f.nr_sequencia 
	and	b.nr_sequencia		= nr_seq_segurado_w;
	 
	ds_carencia_w	:= '';
	 
	for i in 1..12 loop 
		begin 
		 
		ds_carencia_ww	:= coalesce(substr(pls_obter_dados_cart_unimed(nr_seq_segurado_w, nr_seq_plano_w,'CA',i),1,255),'-');
		 
		ds_carencia_ww	:= replace(ds_carencia_ww,';',' ');
		 
		if (i < 12) then 
			ds_carencia_w	:= ds_carencia_w ||ds_carencia_ww||';';
		else 
			ds_carencia_w	:= ds_carencia_w ||ds_carencia_ww;
		end if;
		 
		end;
	end loop;
	 
	if (nr_seq_plano_w not in (172,176)) then 
		select	max(a.ds_mensagem) 
		into STRICT 	ds_observacao_1_w 
		from 	pls_plano_mensagem_cart a 
		where 	a.nr_seq_plano 		= nr_seq_plano_w 
		and 	clock_timestamp() between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, clock_timestamp());
	end if;
	 
	insert into w_pls_interface_carteira(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec, 
			nr_seq_lote,ie_tipo_reg,cd_usuario_plano,dt_nascimento,nm_beneficiario, 
			ds_registro_ans,ds_abrangencia,ds_acomodacao,ds_segmentacao,ds_estipulante, 
			ds_carencia,ds_observacao,ds_trilha_2,ds_trilha_1,nr_seq_segurado) 
	values (	nextval('w_pls_interface_carteira_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p, 
			nr_seq_lote_p,2,cd_usuario_plano_w,dt_nascimento_w,nm_beneficiario_w, 
			ds_registro_ans_w,ds_abrangencia_w,ds_acomodacao_w,ds_segmentacao_w,nm_empresa_w, 
			ds_carencia_w,ds_observacao_1_w,ds_trilha_2_w,ds_trilha_1_w,nr_seq_segurado_w);
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_cartao_benecamp ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

