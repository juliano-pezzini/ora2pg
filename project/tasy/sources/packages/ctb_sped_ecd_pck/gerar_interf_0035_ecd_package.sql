-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_0035_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			

ds_linha_w				varchar(8000);
sep_w					varchar(1)	:= '|';
tp_registro_w				varchar(15)	:= '0035';
				
c_establecimento CURSOR(
		cd_empresa_pc  estabelecimento.cd_empresa%type
	) FOR
	SELECT	a.cd_cgc cd_cnpj,
		b.ds_razao_social ds_razao_social
	from	estabelecimento a,
		pessoa_juridica b
	where 	a.cd_cgc = b.cd_cgc
	and	a.cd_empresa = cd_empresa_pc
	and   	a.ie_situacao = 'A'
	and	a.ie_scp = 'S';

type vetor_estabelecimento is table of c_establecimento%rowtype index by integer;
v_estabelecimento_w    vetor_estabelecimento;

type vetor_ctb_sped_registro is table of ctb_sped_registro%rowtype index by integer;
v_ctb_sped_registro_w  vetor_ctb_sped_registro;

BEGIN


if (regra_sped_p.cd_versao in ('7.0', '8.0')) and (regra_sped_p.ie_tipo_ecd = '1') then
	open c_establecimento(
		cd_empresa_pc  	=> regra_sped_p.cd_empresa
	);
		loop fetch c_establecimento bulk collect into v_estabelecimento_w limit 1000;
			EXIT WHEN NOT FOUND; /* apply on c_establecimento */
			for i in v_estabelecimento_w.first .. v_estabelecimento_w.last loop
			begin
			ds_linha_w	:= substr(	sep_w || tp_registro_w				|| 
							sep_w || v_estabelecimento_w[i].cd_cnpj 	||
							sep_w || v_estabelecimento_w[i].ds_razao_social	|| 
							sep_w ,1,8000);
			
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w); 			
		
			end;
			end loop;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end loop;
	close c_establecimento;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_0035_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;