-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_credito_retorno (nr_seq_retorno_p bigint, nm_usuario_p text, nr_nota_credito_p INOUT bigint) AS $body$
DECLARE

									 
 
cd_cgc_w			varchar(14);
cd_estabelecimento_w		smallint;
cd_moeda_w			smallint;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
nr_seq_trans_fin_contab_w	bigint;
cd_convenio_w			integer;
vl_adicional_w			double precision;
nr_seq_nota_credito_w		bigint;
cd_centro_custo_w		bigint;
vl_classif_w			double precision;
nr_seq_motivo_w			bigint;
cd_cgc_solic_nc_w		varchar(14);
cd_pf_solic_nc_w		varchar(10);
cd_estabelecimento_nc_w		smallint;
cd_centro_custo_nc_w		integer;

c01 CURSOR FOR 
SELECT	w.cd_centro_custo, 
	sum(w.vl_classif) 
from ( 
	SELECT	b.cd_centro_custo, 
		a.vl_amaior vl_classif 
	from	setor_atendimento b, 
		procedimento_paciente c, 
		convenio_retorno_glosa a, 
		convenio_retorno_item d 
	where	d.nr_sequencia		= a.nr_seq_ret_item 
	and	a.nr_seq_propaci	= c.nr_sequencia 
	and	c.cd_setor_atendimento	= b.cd_setor_atendimento 
	and	cd_estabelecimento_nc_w	= cd_estabelecimento_w 
	and	d.nr_seq_retorno	= nr_seq_retorno_p 
	and	a.vl_amaior		> 0	 
	
union all
 
	select	b.cd_centro_custo, 
		a.vl_amaior vl_classif 
	from	setor_atendimento b, 
		material_atend_paciente c, 
		convenio_retorno_glosa a, 
		convenio_retorno_item d 
	where	d.nr_sequencia		= a.nr_seq_ret_item	 
	and	a.nr_seq_matpaci	= c.nr_sequencia 
	and	c.cd_setor_atendimento	= b.cd_setor_atendimento 
	and	cd_estabelecimento_nc_w	= cd_estabelecimento_w 
	and	d.nr_seq_retorno	= nr_seq_retorno_p 
	and	a.vl_amaior		> 0	 
	
union all
 
	select	cd_centro_custo_nc_w, 
		a.vl_adicional vl_classif 
	from	convenio_retorno_item a 
	where	a.nr_seq_retorno	= nr_seq_retorno_p 
	and	a.vl_adicional		> 0 
	and	cd_estabelecimento_nc_w	<> cd_estabelecimento_w) w 
group by	w.cd_centro_custo;


BEGIN 
 
select	c.cd_cgc, 
	a.cd_estabelecimento, 
	a.cd_convenio, 
	coalesce(sum(b.vl_adicional),0) 
into STRICT	cd_cgc_w, 
	cd_estabelecimento_w, 
	cd_convenio_w, 
	vl_adicional_w 
from	convenio c, 
	convenio_retorno_item b, 
	convenio_retorno a	 
where	a.nr_sequencia		= b.nr_seq_retorno 
and	a.cd_convenio		= c.cd_convenio 
and	a.nr_sequencia		= nr_seq_retorno_p 
group by c.cd_cgc, 
	a.cd_estabelecimento, 
	a.cd_convenio;
 
if (vl_adicional_w > 0) then 
 
	nr_seq_motivo_w := obter_param_usuario(9051, 4, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, nr_seq_motivo_w);
 
	select	max(a.cd_moeda_padrao), 
		max(a.cd_tipo_taxa_juro), 
		max(a.cd_tipo_taxa_multa) 
	into STRICT	cd_moeda_w, 
		cd_tipo_taxa_juro_w, 
		cd_tipo_taxa_multa_w 
	from	parametros_contas_pagar a 
	where	a.cd_estabelecimento	= cd_estabelecimento_w;
 
	select	coalesce(max(a.nr_seq_tf_cp_grc),max(b.nr_seq_tf_nota_credito)) 
	into STRICT	nr_seq_trans_fin_contab_w 
	from	parametro_contas_receber b, 
		convenio_estabelecimento a 
	where	a.cd_convenio		= cd_convenio_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	b.cd_estabelecimento	= a.cd_estabelecimento;
 
	cd_estabelecimento_nc_w	:= coalesce((obter_estab_cr(cd_estabelecimento_w,'S'))::numeric ,cd_estabelecimento_w);
 
	select	nextval('nota_credito_seq') 
	into STRICT	nr_seq_nota_credito_w 
	;
 
	insert	into nota_credito(cd_cgc, 
		cd_estabelecimento, 
		cd_moeda, 
		cd_tipo_taxa_juro, 
		cd_tipo_taxa_multa, 
		ds_observacao, 
		dt_atualizacao, 
		dt_nota_credito, 
		dt_vencimento, 
		ie_origem, 
		nm_usuario, 
		nr_seq_lote_hist_guia, 
		nr_seq_trans_fin_contab, 
		nr_sequencia, 
		vl_nota_credito, 
		vl_saldo, 
		nr_seq_motivo, 
		ie_situacao, 
		nr_seq_retorno) 
	values (cd_cgc_w, 
		cd_estabelecimento_nc_w, 
		cd_moeda_w, 
		cd_tipo_taxa_juro_w, 
		cd_tipo_taxa_multa_w, 
		Wheb_mensagem_pck.get_Texto(307165, 'NR_SEQ_RETORNO_P='|| NR_SEQ_RETORNO_P), /*'Nota de crédito gerada para o valor adicional do retorno: '||nr_seq_retorno_p,*/ 
		clock_timestamp(), 
		clock_timestamp(), 
		trunc(clock_timestamp(),'dd') + 30, 
		'R', 
		nm_usuario_p, 
		null, 
		nr_seq_trans_fin_contab_w, 
		nr_seq_nota_credito_w, 
		vl_adicional_w, 
		vl_adicional_w, 
		nr_seq_motivo_w, 
		'A', 
		nr_seq_retorno_p);
 
 
	select	max(a.cd_cgc_solic_nc), 
		max(a.cd_pf_solic_nc) 
	into STRICT	cd_cgc_solic_nc_w, 
		cd_pf_solic_nc_w 
	from	parametros_contas_pagar a 
	where	a.cd_estabelecimento	= cd_estabelecimento_nc_w;
 
	if (cd_cgc_solic_nc_w IS NOT NULL AND cd_cgc_solic_nc_w::text <> '') or (cd_pf_solic_nc_w IS NOT NULL AND cd_pf_solic_nc_w::text <> '') then 
		insert	into nota_credito_solic(cd_cgc, 
			cd_pessoa_fisica, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_nota_credito, 
			nr_sequencia) 
		values (cd_cgc_solic_nc_w, 
			cd_pf_solic_nc_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_nota_credito_w, 
			nextval('nota_credito_solic_seq'));
	end if;
 
	if (cd_estabelecimento_nc_w <> cd_estabelecimento_w) then 
 
		cd_centro_custo_nc_w	:= (obter_centro_custo_estab_cr(cd_estabelecimento_w,'S'))::numeric;
 
		if (coalesce(cd_centro_custo_nc_w::text, '') = '') then 
 
			select	max(a.cd_centro_custo_nc) 
			into STRICT	cd_centro_custo_nc_w 
			from	parametros_contas_pagar a 
			where	a.cd_estabelecimento	= cd_estabelecimento_nc_w;
 
		end if;
 
	end if;
 
	open c01;
	loop 
	fetch c01 into 
		cd_centro_custo_w, 
		vl_classif_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		insert	into nota_credito_classif(cd_centro_custo, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_nota_credito, 
			nr_Sequencia, 
			vl_classificacao) 
		values (cd_centro_custo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_nota_credito_w, 
			nextval('nota_credito_classif_seq'), 
			vl_classif_w);
 
	end loop;
	close c01;
	 
	nr_nota_credito_p	:= nr_seq_nota_credito_w;
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_credito_retorno (nr_seq_retorno_p bigint, nm_usuario_p text, nr_nota_credito_p INOUT bigint) FROM PUBLIC;

