-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tiss_gerar_w_guia_opme ( nr_sequencia_autor_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Gerar relatorio de OPME do TISS
----------------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:  Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/cd_tipo_tabela_imp_w		w_tiss_proc_solic.cd_edicao_amb%type;
cd_material_w			w_tiss_proc_solic.cd_procedimento%type;
ds_material_w			w_tiss_proc_solic.ds_procedimento%type;
ie_opcao_fabricante_w		w_tiss_proc_solic.ie_opcao_fabricante%type;
qt_solicitado_w			w_tiss_proc_solic.qt_solicitada%type;
vl_unit_material_solic_w	w_tiss_proc_solic.vl_unit_material_solic%type;
qt_autorizado_w			w_tiss_proc_solic.qt_autorizada%type;
vl_unit_material_aut_w		w_tiss_proc_solic.vl_unit_material_aut%type;
nr_registro_anvisa_w		w_tiss_proc_solic.nr_registro_anvisa%type;
cd_ref_fabricante_imp_w		w_tiss_proc_solic.cd_ref_fabricante_imp%type;
cd_aut_funcionamento_w		w_tiss_proc_solic.cd_aut_funcionamento%type;
cd_guia_w			pls_guia_plano.cd_guia%type;
nr_seq_guia_w			w_tiss_proc_solic.nr_seq_guia%type;

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type; --OS - 1289502
cd_ans_w			varchar(20); --OS - 1289502
qt_itens_guia_w			bigint;
nr_seq_apresentacao_w		w_tiss_proc_solic.nr_seq_apresentacao%type;
	
c01 CURSOR FOR  --Materiais
SELECT	'19',
	substr(pls_obter_dados_mat_guia_req(a.nr_seq_plano_mat,a.nr_seq_req_mat,'CD'),1,10),
	substr(pls_obter_dados_mat_guia_req(a.nr_seq_plano_mat,a.nr_seq_req_mat,'DS'),1,255),
	substr(a.ie_opcao_fabricante,1,1),
	substr(c.qt_solicitada,1,3),
	substr(c.vl_material,1,20),
	substr(c.qt_autorizada,1,3),
	substr(c.vl_material * (CASE WHEN coalesce(c.qt_autorizada,0)=0 THEN  0  ELSE 1 END ),1,20),
	substr(a.nr_registro_anvisa,1,15),
	substr(a.cd_ref_fabricante_imp,1,60),
	substr(a.cd_aut_funcionamento,1,15)
from	pls_lote_anexo_mat_aut		a,
	pls_lote_anexo_guias_aut	b,
	pls_guia_plano_mat			c
where	a.nr_seq_lote_anexo_guia		= b.nr_sequencia
and	c.nr_sequencia				= a.nr_seq_plano_mat
and	b.nr_seq_guia				= nr_sequencia_autor_p
and	b.ie_tipo_anexo				= 'OP'
and	coalesce(a.nr_seq_motivo_exc::text, '') = '';


BEGIN

	delete	from w_tiss_guia
	where	nm_usuario		= nm_usuario_p;

	delete	from w_tiss_proc_solic
	where	nm_usuario		= nm_usuario_p;

commit;
	
if (coalesce( nr_sequencia_autor_p,0) > 0) then

	begin
		select	substr(coalesce(cd_guia_prestador, coalesce(cd_guia_manual,cd_guia)),1,20),
			cd_estabelecimento --OS - 12895002
		into STRICT	cd_guia_w,
			cd_estabelecimento_w --OS - 12895002
		from	pls_guia_plano
		where	nr_sequencia	=	nr_sequencia_autor_p;
	exception
		when no_data_found then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(183208,'DS_ERRO_P='|| obter_expressao_idioma(668767));
	end;
	
	qt_itens_guia_w 		:= 0;
	nr_seq_apresentacao_w	:= 0;
	
	--OS - 1289502
	cd_ans_w	:= pls_obter_dados_outorgante(cd_estabelecimento_w,'ANS');
	
	if (coalesce(cd_ans_w::text, '') = '') then		
		select	max(cd_ans)
		into STRICT	cd_ans_w
		from	pls_outorgante
		where	(cd_ans IS NOT NULL AND cd_ans::text <> '');
	end if;

	--fim--OS - 1289502--
	open c01;
	loop
	fetch c01 into	cd_tipo_tabela_imp_w,
			cd_material_w,
			ds_material_w,
			ie_opcao_fabricante_w,
			qt_solicitado_w,
			vl_unit_material_solic_w,
			qt_autorizado_w,
			vl_unit_material_aut_w,
			nr_registro_anvisa_w,
			cd_ref_fabricante_imp_w,
			cd_aut_funcionamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		qt_itens_guia_w		:= qt_itens_guia_w + 1;
		
		if (qt_itens_guia_w = 1) then

			select	nextval('w_tiss_guia_seq')
			into STRICT	nr_seq_guia_w
			;
			
				
			insert	into w_tiss_guia(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				cd_ans, 			--OS - 1289502
				cd_autorizacao,
				nr_sequencia_autor)
			values (nr_seq_guia_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_ans_w, 			--OS - 1289502
				cd_guia_w,
				nr_sequencia_autor_p);

		end if;		
		
		nr_seq_apresentacao_w    := nr_seq_apresentacao_w + 1;
			
	insert into w_tiss_proc_solic(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_guia,
		cd_procedimento,
		ds_procedimento,
		cd_edicao_amb,
		qt_solicitada,
		qt_autorizada,
		ie_opcao_fabricante,
		vl_unit_material_solic,
		vl_unit_material_aut,
		nr_registro_anvisa,
		cd_ref_fabricante_imp,
		cd_aut_funcionamento,
		nr_seq_apresentacao)
	values (nextval('w_tiss_proc_solic_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_guia_w,
		cd_material_w,
		ds_material_w,
		cd_tipo_tabela_imp_w,
		qt_solicitado_w,
		qt_autorizado_w,
		ie_opcao_fabricante_w,
		vl_unit_material_solic_w,
		vl_unit_material_aut_w,
		nr_registro_anvisa_w,
		cd_ref_fabricante_imp_w,
		cd_aut_funcionamento_w,
		nr_seq_apresentacao_w);		

		if (qt_itens_guia_w = 6) then
				qt_itens_guia_w	:= 0;
		end if;			

	end loop;
	close c01;
	end if;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tiss_gerar_w_guia_opme ( nr_sequencia_autor_p bigint, nm_usuario_p text) FROM PUBLIC;
