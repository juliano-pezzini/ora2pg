-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_j930_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			

nr_crc_w			empresa.nr_crc%type;
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= '|';
tp_registro_w			varchar(15)	:= 'J930';
cd_contabilista_w		estabelecimento.cd_contabilista%type;
cd_titular_w			estabelecimento.cd_titular%type;
cd_ind_crc_w			pessoa_fisica.nr_seq_conselho%type;

c_pessoa CURSOR(
	cd_titular_pc 		 estabelecimento.cd_titular%type,
	cd_contabilista_pc 	  estabelecimento.cd_contabilista%type
	) FOR
	SELECT	x.nm_signatario,
		x.cd_cpf,
		x.ds_identificacao,
		x.cd_assinante_dnrc,
		x.ds_email,
		x.nr_telefone,
		x.uf_conselho,
		x.dt_validade_conselho,
		x.ds_codigo_prof,
		x.nr_crc
	from (	SELECT	nm_pessoa_fisica nm_signatario,
			nr_cpf cd_cpf,
			'DIRETOR' ds_identificacao,
			'203' cd_assinante_dnrc,
			substr(obter_compl_pf(cd_pessoa_fisica, 2, 'M'), 1, 60) ds_email,
			substr(obter_compl_pf(cd_pessoa_fisica, 2, 'T'), 1, 14) nr_telefone,
			null uf_conselho,
			null dt_validade_conselho ,
			'' ds_codigo_prof,
			null nr_crc
		from	pessoa_fisica
		where	cd_pessoa_fisica	= cd_titular_pc
		
union

		select	nm_pessoa_fisica nm_signatario,
			nr_cpf cd_cpf,
			'CONTADOR' ds_identificacao,
			'900' cd_assinante_dnrc,
			substr(obter_compl_pf(cd_pessoa_fisica, 2, 'M'), 1, 60) ds_email,
			substr(obter_compl_pf(cd_pessoa_fisica, 2, 'T'), 1, 14) nr_telefone,
			uf_conselho uf_conselho,
			dt_validade_conselho dt_validade_conselho,
			ds_codigo_prof ds_codigo_prof,
			nr_crc_w nr_crc
		from	pessoa_fisica
		where	cd_pessoa_fisica	= cd_contabilista_pc
		order by 4)
	x;

type vetor_pessoa is table of c_pessoa%rowtype index by integer;
v_pessoa_w    vetor_pessoa;


c_empresa_resp CURSOR(
	cd_empresa_pc		 estabelecimento.cd_empresa%type,
	tp_registro_pc		 text,
	cd_estabelecimento_pc	 estabelecimento.cd_estabelecimento%type
	) FOR
	SELECT	x.nr_seq_conselho,
		x.uf_conselho,
		x.ie_resp_legal_gov,
		x.cd_qualificacao,
		x.ds_qualificacao,
		x.ds_email,
		x.nr_telefone,
		x.dt_validade_conselho,
		x.ds_codigo_prof,
		x.nm_signatario,
		x.nr_cpf
	from (	SELECT	b.nr_seq_conselho nr_seq_conselho,
			b.uf_conselho uf_conselho,
			coalesce(a.ie_resp_legal_gov, 'N') ie_resp_legal_gov,
			to_char(c.cd_qualificacao) cd_qualificacao,
			c.ds_qualificacao ds_qualificacao,
			substr(obter_compl_pf(b.cd_pessoa_fisica, 2, 'M'), 1, 60) ds_email,
			substr(obter_compl_pf(b.cd_pessoa_fisica, 2, 'T'), 1, 14) nr_telefone,
			b.dt_validade_conselho dt_validade_conselho,
			b.ds_codigo_prof ds_codigo_prof,
			b.nm_pessoa_fisica nm_signatario,
			b.nr_cpf
		from	empresa_estab_resp a,
			pessoa_fisica b,
			dnrc_qualif_assinante  c
		where	c.nr_sequencia = a.nr_seq_qualif_dnrc
		and 	a.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	a.ie_signatario = 'S'
		and	a.cd_empresa = cd_empresa_pc
		and	tp_registro_pc = 'J930'
		and 	c.cd_qualificacao not in (910, 920)
		
union all

		select	b.nr_seq_conselho nr_seq_conselho,
			b.uf_conselho uf_conselho,
			coalesce(a.ie_resp_legal_gov, 'N') ie_resp_legal_gov,
			to_char(c.cd_qualificacao) cd_qualificacao,
			c.ds_qualificacao ds_qualificacao,
			substr(obter_compl_pf(b.cd_pessoa_fisica, 2, 'M'), 1, 60) ds_email,
			substr(obter_compl_pf(b.cd_pessoa_fisica, 2, 'T'), 1, 14) nr_telefone,
			b.dt_validade_conselho dt_validade_conselho,
			b.ds_codigo_prof ds_codigo_prof,
			b.nm_pessoa_fisica nm_signatario,
			b.nr_cpf nr_cpf
		from	empresa_estab_resp a,
			pessoa_fisica b,
			dnrc_qualif_assinante  c
		where	c.nr_sequencia = a.nr_seq_qualif_dnrc
		and 	a.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	a.ie_signatario = 'S'
		and	a.cd_empresa = cd_empresa_pc
		and	tp_registro_pc = 'J932'
		and 	c.cd_qualificacao in (910,920)
		
union all

		select	null,
			null,
			'N',
			'001',
			'Signatario da ECD com e-CNPJ ou e-PJ',
			'' ds_email,
			'' nr_telefone,
			null,
			'',
			substr(obter_razao_social(a.cd_cgc),1,80) nm_signatario,
			a.cd_cgc
		from	estabelecimento a
		where   cd_estabelecimento = cd_estabelecimento_pc
		order by 1)
	x;

type vetor_empresa_resp is table of c_empresa_resp%rowtype index by integer;
v_empresa_resp_w    vetor_empresa_resp;

type vetor_ctb_sped_registro is table of ctb_sped_registro%rowtype index by integer;
v_ctb_sped_registro_w  vetor_ctb_sped_registro;
BEGIN

select	max(cd_contabilista),
	max(cd_titular),
	max(nr_crc)
into STRICT	cd_contabilista_w,
	cd_titular_w,
	nr_crc_w
from	estabelecimento
where	cd_estabelecimento = regra_sped_p.cd_estabelecimento;

select	coalesce(cd_contabilista_w, cd_contabilista),
	coalesce(cd_titular_w, cd_titular),
	coalesce(nr_crc_w, nr_crc)
into STRICT	cd_contabilista_w,
	cd_titular_w,
	nr_crc_w
from	empresa
where	cd_empresa = regra_sped_p.cd_empresa;


tp_registro_w := 'J930';
if (regra_sped_p.cd_versao in ('1.0','2.0','3.0','4.0')) then
	<<tp_registro_J930_pessoa>>
	begin
	open c_pessoa(
		cd_titular_pc 		=> cd_titular_w,
		cd_contabilista_pc 	=> cd_contabilista_w
		);
		loop fetch c_pessoa bulk collect into v_pessoa_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c_pessoa */
			for i in v_pessoa_w.first .. v_pessoa_w.last loop
			begin
			if (regra_sped_p.cd_versao = '1.0') then
				ds_linha_w	:= substr(	sep_w || tp_registro_w 						||
								sep_w || v_pessoa_w[i].nm_signatario 				||
								sep_w || v_pessoa_w[i].cd_cpf 					||
								sep_w || v_pessoa_w[i].ds_identificacao 			||
								sep_w || v_pessoa_w[i].cd_assinante_dnrc 			||
								sep_w || v_pessoa_w[i].nr_crc					||
					sep_w ,1,8000);
			elsif (regra_sped_p.cd_versao in ('2.0','3.0','4.0')) then
				ds_linha_w	:= substr(	sep_w || tp_registro_w 						||
								sep_w || v_pessoa_w[i].nm_signatario 				||
								sep_w || v_pessoa_w[i].cd_cpf 					||
								sep_w || v_pessoa_w[i].ds_identificacao 			||
								sep_w || v_pessoa_w[i].cd_assinante_dnrc 			||
								sep_w || v_pessoa_w[i].nr_crc					||
								sep_w || v_pessoa_w[i].ds_email					||
								sep_w || v_pessoa_w[i].nr_telefone				||
								sep_w || v_pessoa_w[i].uf_conselho				||
								sep_w || v_pessoa_w[i].ds_codigo_prof				||
								sep_w || to_char(v_pessoa_w[i].dt_validade_conselho,'ddmmyyyy')	||
								sep_w ,1,8000);

			end if;
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
			
			end;
			end loop;

			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
			
		end loop;
	close c_pessoa;
	END;
else
	begin
	<<tp_registro_J930_empresa_respo>>
	begin
	open c_empresa_resp(
		cd_empresa_pc		=> regra_sped_p.cd_empresa,
		tp_registro_pc		=> tp_registro_w,
		cd_estabelecimento_pc	=> regra_sped_p.cd_estabelecimento
		);
		loop fetch c_empresa_resp bulk collect into v_empresa_resp_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c_empresa_resp */
			for i in v_empresa_resp_w.first .. v_empresa_resp_w.last loop
			begin
			if (v_empresa_resp_w[i].cd_qualificacao not in (900,910,920))  then
				begin
				v_empresa_resp_w[i].ds_codigo_prof	:= '';
				end;
			end if;

			ds_linha_w	:= substr(	sep_w || tp_registro_w 						 		||
							sep_w || v_empresa_resp_w[i].nm_signatario 				 	||
							sep_w || v_empresa_resp_w[i].nr_cpf					 	||
							sep_w || v_empresa_resp_w[i].ds_qualificacao 			 		||
							sep_w || v_empresa_resp_w[i].cd_qualificacao		 		 	||
							sep_w || v_empresa_resp_w[i].ds_codigo_prof			 	 	||
							sep_w || v_empresa_resp_w[i].ds_email					 	||
							sep_w || v_empresa_resp_w[i].nr_telefone				 	||
							sep_w || v_empresa_resp_w[i].uf_conselho				 	||
							sep_w || ''			 				 		||
							sep_w || to_char(v_empresa_resp_w[i].dt_validade_conselho,'ddmmyyyy') 		||
							sep_w || v_empresa_resp_w[i].ie_resp_legal_gov			 		||
								sep_w ,1,8000);
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
			end;
			end loop;
			
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end loop;
	close c_empresa_resp;
	END;
	
	if	((regra_sped_p.cd_versao in ('7.0','8.0')) and (regra_sped_p.ie_finalidade_escrit = 1)) then
		<<tp_registro_J932_empresa_respo>>
		begin
		tp_registro_w := 'J932';
		open c_empresa_resp(
			cd_empresa_pc		=> regra_sped_p.cd_empresa,
			tp_registro_pc		=> tp_registro_w,
			cd_estabelecimento_pc	=> regra_sped_p.cd_estabelecimento
			);
			loop fetch c_empresa_resp bulk collect into v_empresa_resp_w limit 1000;
			EXIT WHEN NOT FOUND; /* apply on c_empresa_resp */
				for i in v_empresa_resp_w.first .. v_empresa_resp_w.last loop
				begin
				if (v_empresa_resp_w[i].cd_qualificacao not in (900,910,920))  then
					begin
					v_empresa_resp_w[i].ds_codigo_prof	:= '';
					end;
				end if;
				
				ds_linha_w	:= substr(	sep_w || tp_registro_w 							 ||
								sep_w || v_empresa_resp_w[i].nm_signatario 				 ||
								sep_w || v_empresa_resp_w[i].nr_cpf					 ||
								sep_w || v_empresa_resp_w[i].ds_qualificacao 				 ||
								sep_w || v_empresa_resp_w[i].cd_qualificacao		 		 ||
								sep_w || v_empresa_resp_w[i].ds_codigo_prof			 	 ||
								sep_w || v_empresa_resp_w[i].ds_email					 ||
								sep_w || v_empresa_resp_w[i].nr_telefone				 ||
								sep_w || v_empresa_resp_w[i].uf_conselho				 ||
								sep_w || ''			 					 ||
								sep_w || to_char(v_empresa_resp_w[i].dt_validade_conselho,'ddmmyyyy') 	 ||
								sep_w ,1,8000);
				regra_sped_p.cd_registro_variavel := tp_registro_w;
				regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
				end;
				end loop;
				regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
			end loop;
		close c_empresa_resp;
		END;
	end if;
	end;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_j930_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;
