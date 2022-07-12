-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_k110_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text, cd_empresa_p bigint) AS $body$
DECLARE



ds_linha_w		varchar(8000);
sep_w			varchar(1) := '|';
tp_registro_w		varchar(15) := 'K110';

c_situacao_esp_empresa CURSOR(
	dt_ref_inicial_pc 	 ctb_sped_controle.dt_ref_inicial%type,
	dt_ref_final_pc		 ctb_sped_controle.dt_ref_final%type,
	cd_empresa_pc		 ctb_sped_controle.cd_empresa%type
	) FOR
	SELECT	CASE WHEN sit.ie_tipo_situacao=1 THEN (CASE WHEN pr_evento_empresa=100 THEN  5  ELSE 4 END ) WHEN sit.ie_tipo_situacao=2 THEN  3 WHEN sit.ie_tipo_situacao=3 THEN  6 WHEN sit.ie_tipo_situacao=4 THEN  7 WHEN sit.ie_tipo_situacao=5 THEN  8 END  ie_tipo_situacao,
		sit.dt_situacao
	from	ctb_sit_especial_empresa sit
	where	sit.dt_situacao between dt_ref_inicial_pc and dt_ref_final_pc
	and	sit.cd_empresa = cd_empresa_pc
	order by sit.dt_situacao, sit.ie_tipo_situacao;
	
type vetor_situacao_empresa is table of c_situacao_esp_empresa%rowtype index by integer;
v_situacao_emp_w    vetor_situacao_empresa;

BEGIN

open c_situacao_esp_empresa(
	dt_ref_inicial_pc	=> regra_sped_p.dt_ref_inicial,
	dt_ref_final_pc	      	=> regra_sped_p.dt_ref_final,
	cd_empresa_pc	      	=> cd_empresa_p
	);
	loop fetch c_situacao_esp_empresa bulk collect into v_situacao_emp_w limit 1000;
	EXIT WHEN NOT FOUND; /* apply on c_situacao_esp_empresa */
		for i in v_situacao_emp_w.first .. v_situacao_emp_w.last loop
		begin
			ds_linha_w := substr(sep_w || 	tp_registro_w						|| sep_w ||
							coalesce(v_situacao_emp_w[i].ie_tipo_situacao,1)		|| sep_w ||
							to_char(v_situacao_emp_w[i].dt_situacao, 'ddmmyyyy')	|| sep_w,1,8000);
			
			regra_sped_p.cd_registro_variavel := tp_registro_w;				
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
			
			if (regra_sped_p.registros.count >= 1000) then
				regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
			end if;	
			
			regra_sped_p 	=> regra_sped_p := ctb_sped_ecd_pck.gerar_interf_k115_ecd(regra_sped_p 	=> regra_sped_p, nm_usuario_p		=> nm_usuario_p, cd_empresa_p 		=> cd_empresa_p, dt_situacao_p 		=> v_situacao_emp_w[i].dt_situacao);
		end;
		end loop;
		regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
	end loop;
close c_situacao_esp_empresa;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_k110_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text, cd_empresa_p bigint) FROM PUBLIC;
