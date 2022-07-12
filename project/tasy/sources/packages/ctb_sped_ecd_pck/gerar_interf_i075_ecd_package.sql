-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_i075_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			

ds_linha_w			varchar(8000);
sep_w				varchar(1) := '|';
tp_registro_w			varchar(15) := 'I075';


c_historico_padrao CURSOR(
	cd_empresa_pc		 ctb_regra_sped.cd_empresa%type,
	ie_consolida_empresa_pc	 ctb_regra_sped.ie_consolida_empresa%type,
	cd_estabelecimento_pc	 ctb_sped_controle.cd_estabelecimento%type,
	dt_ref_inicial_pc	 ctb_sped_controle.dt_ref_inicial%type,
	dt_ref_final_pc		 ctb_sped_controle.dt_ref_final%type
	
	) FOR
	SELECT	h.cd_historico,
		replace(replace(h.ds_historico,chr(13),''),chr(10),'') ds_historico
	from	historico_padrao h
	where	h.cd_empresa = cd_empresa_pc
	and 	(trim(both h.ds_historico) IS NOT NULL AND (trim(both h.ds_historico))::text <> '')
	and	exists (	
			SELECT	1
			from	ctb_movimento a,
				lote_contabil b
			where	a.nr_lote_contabil	= b.nr_lote_contabil
			and	a.cd_historico		= h.cd_historico
			and	obter_empresa_estab(b.cd_estabelecimento) = h.cd_empresa
			and (ie_consolida_empresa_pc = 'S' or b.cd_estabelecimento = cd_estabelecimento_pc)
			and	a.dt_movimento between dt_ref_inicial_pc and dt_ref_final_pc)
	order by 1;
	
type vetor_historico_padrao is table of c_historico_padrao%rowtype index by integer;
v_historico_padrao_w    vetor_historico_padrao;

type vetor_ctb_sped_registro is table of ctb_sped_registro%rowtype index by integer;
v_ctb_sped_registro_w  vetor_ctb_sped_registro;
	
BEGIN

open c_historico_padrao(
	cd_empresa_pc 		=>  regra_sped_p.cd_empresa,
	ie_consolida_empresa_pc =>  regra_sped_p.ie_consolida_empresa,
	cd_estabelecimento_pc 	=>  regra_sped_p.cd_estabelecimento,
	dt_ref_inicial_pc	=>  regra_sped_p.dt_ref_inicial,
	dt_ref_final_pc		=>  regra_sped_p.dt_ref_final
	);
	loop fetch c_historico_padrao bulk collect into v_historico_padrao_w limit 1000;
	EXIT WHEN NOT FOUND; /* apply on c_historico_padrao */
		for i in v_historico_padrao_w.first .. v_historico_padrao_w.last loop
		begin
		ds_linha_w	:= substr(	sep_w || tp_registro_w 				|| 
						sep_w || v_historico_padrao_w[i].cd_historico 	|| 
						sep_w || v_historico_padrao_w[i].ds_historico 	|| sep_w,1,8000);
						
		regra_sped_p.cd_registro_variavel := tp_registro_w;
		regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
		end;
		end loop;
		regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
	end loop;
close c_historico_padrao;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_i075_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;