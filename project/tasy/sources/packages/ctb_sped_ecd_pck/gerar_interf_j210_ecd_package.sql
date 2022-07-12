-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_j210_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			

nr_seq_rubrica_saldo_ant_w			ctb_modelo_rubrica.nr_sequencia%type;
nr_seq_rubrica_saldo_final_w			ctb_modelo_rubrica.nr_sequencia%type;
vl_saldo_anterior_w				ctb_demo_rubrica.vl_referencia%type;
vl_saldo_final_w				ctb_demo_rubrica.vl_referencia%type;
sep_w						varchar(1) := '|';
tp_registro_w					varchar(15) := 'J210';
ie_deb_cred_inicial_w				varchar(1);
ie_deb_cred_final_w				varchar(1);
ds_linha_w					varchar(8000);
ie_demonstrativo_w				varchar(1);


c_dados_J210 CURSOR(
	nr_seq_demo_dmpl_pc 	ctb_sped_controle.nr_seq_demo_dmpl%type,
	nr_seq_demo_dlpa_pc 	ctb_sped_controle.nr_seq_demo_dlpa%type
	) FOR
	SELECT	CASE WHEN nr_seq_demo_dlpa_pc=0 THEN 1 END  ie_demonstrativo,
		b.nr_sequencia cd_aglutinacao,
		b.ds_coluna ds_aglutinacao,
		b.nr_seq_demo
	from	ctb_demo_mes b
	where	b.nr_seq_demo in (nr_seq_demo_dmpl_pc, nr_seq_demo_dlpa_pc)
	order by
		ie_demonstrativo;

type vetor_dados_J210 is table of c_dados_J210%rowtype index by integer;
v_dados_J210_w    vetor_dados_J210;

c_dados_J215 CURSOR(
	nr_seq_demo_pc		 ctb_demo_mes.nr_seq_demo%type,
	cd_aglutinacao_pc	 ctb_demo_mes.ds_coluna%type
	) FOR
	SELECT	a.nr_seq_rubrica cd_fato_contabil,
		a.vl_referencia vl_fato_contabil,
		CASE WHEN sign(a.vl_referencia)=1 THEN 'C' WHEN sign(a.vl_referencia)=-1 THEN 'D' END  ie_deb_cred_fato_ctb
	from	ctb_modelo_rubrica b,
		ctb_demo_rubrica a
	where	a.nr_seq_rubrica	= b.nr_sequencia
	and	a.nr_seq_demo		= nr_seq_demo_pc
	and	a.nr_seq_col		= cd_aglutinacao_pc
	and	a.vl_referencia		<> 0
	order by
		b.nr_Seq_apres;

type vetor_dados_J215 is table of c_dados_J215%rowtype index by integer;
v_dados_J215_w    vetor_dados_J215;

c_colunas_dmpl_J210 CURSOR(
	nr_seq_demo_dmpl_pc 	ctb_sped_controle.nr_seq_demo_dmpl%type
	) FOR
	SELECT	1 ie_demonstrativo,
		cd_aglutinacao_sped cd_aglutinacao,
		ds_coluna ds_aglutinacao,
		nr_seq_dmpl,
		nr_sequencia
	from	ctb_dmpl_coluna
	where	nr_seq_dmpl = nr_seq_demo_dmpl_pc
	order by
		ie_demonstrativo;

type vetor_colunas_dmpl_J210 is table of c_colunas_dmpl_J210%rowtype index by integer;
v_colunas_dmpl_J210_w    vetor_colunas_dmpl_J210;


c_coluna_dmpl_j215 CURSOR(
	nr_seq_demo_dmpl_pc	 ctb_demo_mes.nr_seq_demo%type,
	cd_aglutinacao_pc	 ctb_demo_mes.ds_coluna%type
	)FOR
	SELECT	b.nr_seq_mutacao_pl cd_fato_contabil,
		b.vl_movimento vl_fato_contabil,
		ds_linha ds_fato_contabil,
		CASE WHEN sign(b.vl_movimento)=1 THEN 'C' WHEN sign(b.vl_movimento)=-1 THEN 'D' END  ie_deb_cred_fato_ctb
	from	ctb_dmpl_coluna a,
		ctb_dmpl_movimento b
	where	a.nr_sequencia = b.nr_seq_col
	and	a.nr_seq_dmpl = b.nr_seq_dmpl
	and	b.ie_linha = 'MO'
	and	b.vl_movimento <> 0
	and	a.cd_aglutinacao_sped = cd_aglutinacao_pc
	and	a.nr_seq_dmpl = nr_seq_demo_dmpl_pc
	order by
		b.nr_seq_mutacao_pl;

type vetor_coluna_dmpl_J215 is table of c_coluna_dmpl_J215%rowtype index by integer;
v_coluna_dmpl_J215_w    vetor_coluna_dmpl_J215;
BEGIN

if (regra_sped_p.cd_versao in ('4.0','5.0','6.0','7.0','8.0')) then
	
	begin <<bloco_colunas_dmpl_J210>>
	open c_colunas_dmpl_J210(
		nr_seq_demo_dmpl_pc	=> regra_sped_p.nr_seq_demo_dmpl
		);
		loop fetch c_colunas_dmpl_J210 bulk collect into v_colunas_dmpl_J210_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c_colunas_dmpl_J210 */
			for i in v_colunas_dmpl_J210_w.first .. v_colunas_dmpl_J210_w.last loop
			tp_registro_w	:= 'J210';
			ie_deb_cred_inicial_w	:= 'C';
			
			begin
			select	vl_movimento
			into STRICT	vl_saldo_anterior_w
			from	ctb_dmpl_movimento
			where	nr_seq_dmpl = regra_sped_p.nr_seq_demo_dmpl
			and	nr_seq_col = v_colunas_dmpl_J210_w[i].nr_sequencia
			and	ie_linha = 'SA';

			vl_saldo_anterior_w:= coalesce(vl_saldo_anterior_w, 0);
			exception when others then
				vl_saldo_anterior_w:= 0;
			end;

			if (vl_saldo_anterior_w < 0) then
				ie_deb_cred_inicial_w	:= 'D';
			end if;

			ie_deb_cred_final_w	:= 'C';

			begin
			select coalesce(vl_movimento, 0)
			into STRICT 	vl_saldo_final_w
			from   ctb_dmpl_movimento
			where  nr_seq_dmpl = regra_sped_p.nr_seq_demo_dmpl
			and    nr_seq_col =  v_colunas_dmpl_J210_w[i].nr_sequencia
			and    ie_linha = 'SF';

			vl_saldo_final_w:= coalesce(vl_saldo_final_w,0);
			exception when others then
				vl_saldo_final_w:= 0;
			end;

			if (vl_saldo_final_w < 0) then
				ie_deb_cred_final_w	:= 'D';
			end if;
			
			if (regra_sped_p.cd_versao in ('7.0','8.0')) then
				ds_linha_w	:= substr(	sep_w || tp_registro_w 					||
								sep_w || v_colunas_dmpl_J210_w[i].ie_demonstrativo	||
								sep_w || v_colunas_dmpl_J210_w[i].cd_aglutinacao	||
								sep_w || v_colunas_dmpl_J210_w[i].ds_aglutinacao	||
								sep_w || sped_obter_campo_valor(vl_saldo_anterior_w)	||
								sep_w || ie_deb_cred_inicial_w				||
								sep_w || sped_obter_campo_valor(vl_saldo_final_w)	||
								sep_w || ie_deb_cred_final_w				||
								sep_w || ''						|| sep_w ,1,8000);
				
			elsif (regra_sped_p.cd_versao = '6.0') then
				
				ds_linha_w	:= substr(	sep_w || tp_registro_w 					||
								sep_w || v_colunas_dmpl_J210_w[i].ie_demonstrativo	||
								sep_w || v_colunas_dmpl_J210_w[i].cd_aglutinacao	||
								sep_w || v_colunas_dmpl_J210_w[i].ds_aglutinacao	||
								sep_w || sped_obter_campo_valor(vl_saldo_final_w)	||
								sep_w || ie_deb_cred_final_w				||
								sep_w || sped_obter_campo_valor(vl_saldo_anterior_w)	||
								sep_w || ie_deb_cred_inicial_w				||
								sep_w || ''						|| sep_w ,1,8000);
				
			else
				
				ds_linha_w	:= substr(	sep_w || tp_registro_w 					||
								sep_w || v_colunas_dmpl_J210_w[i].ie_demonstrativo	||
								sep_w || v_colunas_dmpl_J210_w[i].cd_aglutinacao	||
								sep_w || v_colunas_dmpl_J210_w[i].ds_aglutinacao	||
								sep_w || sped_obter_campo_valor(vl_saldo_final_w)	||
								sep_w || ie_deb_cred_final_w				||
								sep_w || sped_obter_campo_valor(vl_saldo_anterior_w)	||
								sep_w || ie_deb_cred_inicial_w				|| sep_w ,1,8000);
				
			end if;
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);

			tp_registro_w	:= 'J215';

			
			begin <<bloco_colunas_dmpl_J215>>
			open c_coluna_dmpl_J215(
				nr_seq_demo_dmpl_pc =>	regra_sped_p.nr_seq_demo_dmpl,
				cd_aglutinacao_pc   =>  v_colunas_dmpl_J210_w[i].ds_aglutinacao
				);
				loop fetch c_coluna_dmpl_J215 bulk collect into v_coluna_dmpl_J215_w limit 1000;
				EXIT WHEN NOT FOUND; /* apply on c_coluna_dmpl_J215 */
					begin
					for y in v_coluna_dmpl_J215_w.first .. v_coluna_dmpl_J215_w.last loop
					ds_linha_w	:= substr(	sep_w || tp_registro_w								||
									sep_w || v_coluna_dmpl_J215_w[y].cd_fato_contabil				||
									sep_w || coalesce(v_coluna_dmpl_J215_w[y].ds_fato_contabil, 'Nao identificado pelo usuario')				||
									sep_w || sped_obter_campo_valor(v_coluna_dmpl_J215_w[y].vl_fato_contabil)	||
									sep_w || v_coluna_dmpl_J215_w[y].ie_deb_cred_fato_ctb 				|| sep_w ,1,8000);


					regra_sped_p.cd_registro_variavel := tp_registro_w;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
					if (regra_sped_p.registros.count >= 1000) then
						regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
					end if;					
					end loop;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
					end;
				end loop;
			close c_coluna_dmpl_J215;
			END;
			
			end loop;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end loop;
	close c_colunas_dmpl_J210;
	END;


else
	
	begin <<bloco_J210>>
		nr_seq_rubrica_saldo_ant_w	:= null;
		nr_seq_rubrica_saldo_final_w	:= null;
		ie_demonstrativo_w		:= 0;
	open c_dados_J210(
		nr_seq_demo_dmpl_pc =>	regra_sped_p.nr_seq_demo_dmpl,
		nr_seq_demo_dlpa_pc =>	regra_sped_p.nr_seq_demo_dlpa
		);
		loop fetch c_dados_J210 bulk collect into v_dados_J210_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c_dados_J210 */
			for i in v_dados_J210_w.first .. v_dados_J210_w.last loop
			tp_registro_w	:= 'J210';
			
			if (ie_demonstrativo_w <> v_dados_J210_w[i].ie_demonstrativo) then
				nr_seq_rubrica_saldo_ant_w	:= null;
				nr_seq_rubrica_saldo_final_w	:= null;
			end if;
			
			if (coalesce(nr_seq_rubrica_saldo_ant_w,0) = 0) then
				
				select	max(nr_seq_rubrica)
				into STRICT	nr_seq_rubrica_saldo_ant_w
				from	ctb_demo_rubrica a
				where	a.nr_sequencia	= (	SELECT	min(y.nr_sequencia)
								from	ctb_demo_rubrica y
								where	y.nr_seq_demo	= v_dados_J210_w[i].nr_seq_demo)
				and	a.nr_seq_demo	= v_dados_J210_w[i].nr_seq_demo;
				
				
				select	max(nr_seq_rubrica)
				into STRICT	nr_seq_rubrica_saldo_final_w
				from	ctb_demo_rubrica a
				where	a.nr_sequencia	= (	SELECT	max(y.nr_sequencia)
								from	ctb_demo_rubrica y
								where	y.nr_seq_demo	= v_dados_J210_w[i].nr_seq_demo)
				and	a.nr_seq_demo	= v_dados_J210_w[i].nr_seq_demo;
				
				
			end if;
			
			ie_deb_cred_inicial_w	:= 'C';

			select	coalesce(sum(a.vl_referencia),0)
			into STRICT	vl_saldo_anterior_w
			from	ctb_demo_rubrica a
			where	a.nr_seq_demo		= v_dados_J210_w[i].nr_seq_demo
			and	a.nr_seq_col		= v_dados_J210_w[i].cd_aglutinacao
			and	a.nr_seq_rubrica	= nr_seq_rubrica_saldo_ant_w;

			if (vl_saldo_anterior_w < 0) then
				ie_deb_cred_inicial_w	:= 'D';
			end if;
			ie_deb_cred_final_w	:= 'C';
			
			
			select	coalesce(sum(a.vl_referencia),0)
			into STRICT	vl_saldo_final_w
			from	ctb_demo_rubrica a
			where	a.nr_seq_demo		= v_dados_J210_w[i].nr_seq_demo
			and	a.nr_seq_col		= v_dados_J210_w[i].cd_aglutinacao
			and	a.nr_seq_rubrica	= nr_seq_rubrica_saldo_final_w;

			if (vl_saldo_final_w < 0) then
				ie_deb_cred_inicial_w	:= 'D';
			end if;
			
			ds_linha_w	:= substr(	sep_w || tp_registro_w 					||
							sep_w || v_dados_J210_w[i].ie_demonstrativo		||
							sep_w || v_dados_J210_w[i].cd_aglutinacao		||
							sep_w || v_dados_J210_w[i].ds_aglutinacao		||
							sep_w || sped_obter_campo_valor(vl_saldo_final_w)	||
							sep_w || ie_deb_cred_final_w				||
							sep_w || sped_obter_campo_valor(vl_saldo_anterior_w)	||
							sep_w || ie_deb_cred_inicial_w				|| sep_w ,1,8000);
							
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
			
			ie_demonstrativo_w	:= v_dados_J210_w[i].ie_demonstrativo;
			tp_registro_w		:= 'J215';
			
			begin <<bloco_J215>>
			open c_dados_J215(
				nr_seq_demo_pc		=> v_dados_J210_w[i].nr_seq_demo,
				cd_aglutinacao_pc	=> v_dados_J210_w[i].cd_aglutinacao
				);
				loop fetch c_dados_J215 bulk collect into v_dados_J215_w limit 1000;
				EXIT WHEN NOT FOUND; /* apply on c_dados_J215 */
					begin
					for j in v_dados_J215_w.first .. v_dados_J215_w.last loop
					ds_linha_w	:= substr(	sep_w || tp_registro_w 							||
									sep_w || v_dados_J215_w[j].cd_fato_contabil				||
									sep_w || sped_obter_campo_valor(v_dados_J215_w[j].vl_fato_contabil)	||
									sep_w || v_dados_J215_w[j].ie_deb_cred_fato_ctb				|| sep_w ,1,8000);
									
					regra_sped_p.cd_registro_variavel := tp_registro_w;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
					if (regra_sped_p.registros.count > 1000) then
						regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
					end if;	
					
					end loop;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
					end;
				end loop;
			close c_dados_J215;
			END;
			end loop;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end loop;
	close c_dados_J210;
	END;	

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_j210_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;