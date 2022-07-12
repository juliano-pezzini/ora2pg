-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--fis_obter_nf_baixa_titulo
CREATE OR REPLACE PROCEDURE fis_refatoracao_nf_pck.fis_obter_nf_bai_titulo ( nr_seq_nf_origem_p nota_fiscal.nr_sequencia%type, nr_seq_refat_nf_p fis_refatoracao_nf.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


qt_cursor_nf_baixa_w	bigint := 0;
nr_seq_ref_nf_baixa_w	fis_refatoracao_nf_bai_tit.nr_sequencia%type;
nr_seq_nota_fiscal_w	nota_fiscal.nr_sequencia%type;
					
c_nf_tit_baixa CURSOR FOR
	SELECT	b.nr_sequencia,
		a.nr_titulo
	from	titulo_receber a,
		titulo_receber_liq b
	where	a.nr_titulo		= b.nr_titulo
	and 	a.nr_seq_nf_saida 	= nr_seq_nf_origem_p;

c_nf_tit_baixa_w          c_nf_tit_baixa%rowtype;


BEGIN

open c_nf_tit_baixa;
loop
fetch c_nf_tit_baixa into	
	c_nf_tit_baixa_w;
EXIT WHEN NOT FOUND; /* apply on c_nf_tit_baixa */
	begin
	
	/*Incrementa a variavel para o array*/

	qt_cursor_nf_baixa_w:=	qt_cursor_nf_baixa_w + 1;

	/*Pega a sequencia da taleba fis_sef_edoc_0175 para o insert*/

	select	nextval('fis_refatoracao_nf_bai_tit_seq')
	into STRICT	nr_seq_ref_nf_baixa_w
	;
	
	begin
	
	select 	max(a.nr_sequencia)
	into STRICT	nr_seq_nota_fiscal_w
	from	nota_fiscal 		a
	where	a.nr_sequencia_ref	= nr_seq_nf_origem_p;
	
	exception
	when others then
		nr_seq_nota_fiscal_w:= null;
	end;

	/*Inserindo valores no array para realizacao do forall posteriormente*/
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_sequencia 		:= nr_seq_ref_nf_baixa_w;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_seq_refat_nf		:= nr_seq_refat_nf_p;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_titulo_receb		:= c_nf_tit_baixa_w.nr_titulo;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_seq_baixa_old		:= c_nf_tit_baixa_w.nr_sequencia;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_seq_baixa_new		:= null;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_seq_nf_baixa_tit_old	:= nr_seq_nota_fiscal_w;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nr_seq_nf_baixa_tit_new	:= null;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].dt_atualizacao		:= clock_timestamp();
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].dt_atualizacao_nrec		:= clock_timestamp();
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nm_usuario			:= nm_usuario_p;
	current_setting('fis_refatoracao_nf_pck.fis_refatoracao_nf_bai_tit_w')::reg_refatoracao_nf_bai_tit[qt_cursor_nf_baixa_w].nm_usuario_nrec		:= nm_usuario_p;
	
	
	end;
end loop;
close c_nf_tit_baixa;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_refatoracao_nf_pck.fis_obter_nf_bai_titulo ( nr_seq_nf_origem_p nota_fiscal.nr_sequencia%type, nr_seq_refat_nf_p fis_refatoracao_nf.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
