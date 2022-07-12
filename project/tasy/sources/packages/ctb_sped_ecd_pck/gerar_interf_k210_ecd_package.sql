-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_k210_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text, cd_conta_contabil_p text) AS $body$
DECLARE

			

ds_linha_w		varchar(8000);
sep_w			varchar(1) 	:= '|';
tp_registro_w		varchar(15) 	:= 'K210';
cd_empresa_w		grupo_emp_estrutura.cd_empresa%type;
nr_seq_grupo_w		grupo_emp_estrutura.nr_seq_grupo%type;
cd_codigo_conta_ecd_w	varchar(40);

c01 CURSOR(
	nr_seq_grupo_pc	 grupo_emp_estrutura.nr_seq_grupo%type,
	cd_empresa_pc	 ctb_sped_controle.cd_empresa%type
	)FOR
	SELECT	a.cd_empresa
	from	grupo_emp_estrutura a
	where	a.nr_seq_grupo	= nr_seq_grupo_pc
	and     a.cd_empresa <> cd_empresa_pc
	order by cd_empresa;

c02 CURSOR(
	dt_ref_final_pc 	 ctb_sped_controle.dt_ref_final%type,
	cd_empresa_pc 		 ctb_sped_controle.cd_empresa%type,
	cd_conta_contabil_pc 	 conta_contabil.cd_conta_contabil%type
	) FOR
	SELECT	cc1.cd_empresa,
		cc1.cd_conta_contabil,
		substr(ctb_obter_classif_conta(cc1.cd_conta_contabil, cc1.cd_classificacao, dt_ref_final_pc ),1,40) cd_classificacao
	from	conta_contabil cc1
	where	cc1.cd_empresa = cd_empresa_pc
	and	cc1.cd_conta_referencia = cd_conta_contabil_pc
	and	cc1.ie_tipo = 'A'
	and 	cc1.ie_situacao = 'A';

type vetor_c02 is table of c02%rowtype index by integer;
vetor_c02_w    vetor_c02;
BEGIN

nr_seq_grupo_w:= holding_pck.get_grupo_emp_estrut_vigente(cd_empresa_p =>  regra_sped_p.cd_empresa);

open C01(
	nr_seq_grupo_pc => nr_seq_grupo_w,
	cd_empresa_pc	=> regra_sped_p.cd_empresa
);
loop
fetch C01 into
	cd_empresa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open c02(
		dt_ref_final_pc 	=> regra_sped_p.dt_ref_final,
		cd_empresa_pc 		=> regra_sped_p.cd_empresa,
		cd_conta_contabil_pc 	=> cd_conta_contabil_p
		);
		loop fetch c02 bulk collect into vetor_c02_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			for i in vetor_c02_w.first .. vetor_c02_w.last loop
			cd_codigo_conta_ecd_w	:= ctb_sped_ecd_pck.obter_cod_conta_ecd(ie_tipo_conta_p	=> 'C', 
								ie_apres_conta_ctb_p	=> regra_sped_p.ie_apres_conta_ctb, 
								cd_empresa_p		=> null, 
								cd_conta_contabil_p	=> vetor_c02_w[i].cd_conta_contabil, 
								cd_classificacao_p	=> vetor_c02_w[i].cd_classificacao,
								dt_vigencia_p		=> null);

			ds_linha_w	:= substr(sep_w || tp_registro_w 		|| sep_w ||
						vetor_c02_w[i].cd_empresa		|| sep_w ||
						cd_codigo_conta_ecd_w 	|| sep_w,1,8000);
			
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
			
			if (regra_sped_p.registros.count >= 1000) then
				regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
			end if;
			
			end loop;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end loop;
	close c02;
	end;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_k210_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text, cd_conta_contabil_p text) FROM PUBLIC;
