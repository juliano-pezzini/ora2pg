-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dirf_registro_val_mensais_pj ( cd_cgc_p text, cd_dirf_p text, dt_lote_p timestamp, nm_usuario_p text, nr_seq_posicao_p bigint, nr_seq_apres_p INOUT bigint, ie_tipo_data_p bigint, cd_estabelecimento_p text) AS $body$
DECLARE

 
/* ie_tipo_data 
1 - data contabil 
2 - data liquidacao 
3 - data emissao 
 
*/
 
					 
					 
ds_arquivo_ret_w varchar(2000);
ds_arquivo_ir_w varchar(2000);
nr_seq_apres_w	bigint;
dt_lote_w	timestamp;
ie_mes_w	varchar(2);
ie_entou_w	boolean;
vl_rendimento_w	double precision;
vl_irrf_w	double precision;
separador_w	varchar(1) := '|';
nr_titulo_w	varchar(20);

C01 CURSOR FOR 
	SELECT 	sum(vl_rendimento), 
		sum(vl_imposto) 
	from 
	(SELECT distinct 
		p.nr_titulo, 
		coalesce(obter_rendimento_cofins_ir_pj(p.nr_titulo,'RET','IR'),0) vl_rendimento, 
		coalesce(obter_rendimento_cofins_ir_pj(p.nr_titulo,'IMP','IR'),0) vl_imposto 
	FROM titulo_pagar p
LEFT OUTER JOIN titulo_pagar_imposto i ON (p.nr_titulo = i.nr_titulo)
LEFT OUTER JOIN tributo t ON (i.cd_tributo = t.cd_tributo)
WHERE coalesce(obter_se_nota_servico(p.nr_titulo),'S') = 'S' and coalesce(p.nr_titulo_original::text, '') = '' and trunc(CASE WHEN ie_tipo_data_p=1 THEN p.dt_contabil WHEN ie_tipo_data_p=2 THEN p.dt_liquidacao  ELSE p.dt_emissao END ,'YYYY') = trunc(dt_lote_p,'YYYY') and p.cd_cgc = cd_cgc_p and ( (p.cd_estabelecimento = coalesce(cd_estabelecimento_p,p.cd_estabelecimento)) 
	or    ((coalesce(p.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = ''))) and coalesce(coalesce(i.cd_darf, 
	    substr(obter_codigo_darf(i.cd_tributo, 
		             (obter_descricao_padrao('TITULO_PAGAR','CD_ESTABELECIMENTO',i.nr_titulo))::numeric , 
				     obter_descricao_padrao('TITULO_PAGAR','CD_CGC',i.nr_titulo), 
				   null),1,10) 
     	    ),'1708') = CASE WHEN cd_dirf_p='5952' THEN '9999'  ELSE cd_dirf_p END and p.ie_situacao <> 'C' and p.ie_origem_titulo in (select y.ie_origem_titulo from dirf_regra_origem_tit y) and coalesce(to_char(CASE WHEN ie_tipo_data_p=1 THEN p.dt_contabil WHEN ie_tipo_data_p=2 THEN p.dt_liquidacao  ELSE p.dt_emissao END ,'mm'),'00') = lpad(ie_mes_w,2,'0') and exists (select 	1 
		from 	titulo_pagar x, 
			titulo_pagar_imposto z, 
			tributo t 
		where	x.nr_titulo = z.nr_titulo 
		and	t.cd_tributo = z.cd_tributo 
		and	x.cd_cgc = P.cd_cgc 
		and	z.vl_imposto >= 0 
		and 	t.ie_tipo_tributo = 'IR') 
	 
union all
 
	select 	distinct 
		p.nr_titulo, 
		coalesce(obter_rendimento_cofins_ir_pj(p.nr_titulo,'RET','COFINS'),0) vl_rendimento, 
		coalesce(obter_rendimento_cofins_ir_pj(p.nr_titulo,'IMP','COFINS'),0) vl_imposto 
	from	titulo_pagar p 
	where	coalesce(obter_se_nota_servico(p.nr_titulo),'S') = 'S' 
	and	trunc(CASE WHEN ie_tipo_data_p=1 THEN p.dt_contabil WHEN ie_tipo_data_p=2 THEN p.dt_liquidacao  ELSE p.dt_emissao END ,'YYYY') = trunc(dt_lote_p,'YYYY') 
	and	p.cd_cgc = cd_cgc_p 
	and	p.ie_situacao <> 'C' 
	and	coalesce(p.nr_titulo_original::text, '') = '' 
	and	p.ie_origem_titulo in (select y.ie_origem_titulo from dirf_regra_origem_tit y) 
	and	( (p.cd_estabelecimento = coalesce(cd_estabelecimento_p,p.cd_estabelecimento)) 
	or    ((coalesce(p.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = ''))) 
	and	((cd_dirf_p = '5952') or (cd_dirf_p = '5960')) 
	and	coalesce(to_char(CASE WHEN ie_tipo_data_p=1 THEN p.dt_contabil WHEN ie_tipo_data_p=2 THEN p.dt_liquidacao  ELSE p.dt_emissao END ,'mm'),'00') = lpad(ie_mes_w,2,'0') 
	and	exists (select 	1 
		from 	titulo_pagar x, 
			titulo_pagar_imposto z, 
			tributo t 
		where	x.nr_titulo = z.nr_titulo 
		and	t.cd_tributo = z.cd_tributo 
		and	x.cd_cgc = P.cd_cgc 
		and	z.vl_imposto >= 0 
		and 	t.ie_tipo_tributo = 'COFINS') 
	
union all
 
	select 	distinct 
		p.nr_titulo, 
		coalesce(obter_rendimento_cofins_ir_pj(p.nr_titulo,'RET','CSLL'),0) vl_rendimento, 
		coalesce(obter_rendimento_cofins_ir_pj(p.nr_titulo,'IMP','CSLL'),0) vl_imposto 
	from	titulo_pagar p 
	where	coalesce(obter_se_nota_servico(p.nr_titulo),'S') = 'S' 
	and	trunc(CASE WHEN ie_tipo_data_p=1 THEN p.dt_contabil WHEN ie_tipo_data_p=2 THEN p.dt_liquidacao  ELSE p.dt_emissao END ,'YYYY') = trunc(dt_lote_p,'YYYY') 
	and	p.cd_cgc = cd_cgc_p 
	and	p.ie_situacao <> 'C' 
	and	coalesce(p.nr_titulo_original::text, '') = '' 
	and	p.ie_origem_titulo in (select y.ie_origem_titulo from dirf_regra_origem_tit y) 
	and	( (p.cd_estabelecimento = coalesce(cd_estabelecimento_p,p.cd_estabelecimento)) 
	or    ((coalesce(p.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = ''))) 
	and	cd_dirf_p = '5987' 
	and	coalesce(to_char(CASE WHEN ie_tipo_data_p=1 THEN p.dt_contabil WHEN ie_tipo_data_p=2 THEN p.dt_liquidacao  ELSE p.dt_emissao END ,'mm'),'00') = lpad(ie_mes_w,2,'0') 
	and	exists (select 	1 
		from 	titulo_pagar x, 
			titulo_pagar_imposto z, 
			tributo t 
		where	x.nr_titulo = z.nr_titulo 
		and	t.cd_tributo = z.cd_tributo 
		and	x.cd_cgc = P.cd_cgc 
		and	z.vl_imposto >= 0 
		and 	t.ie_tipo_tributo = 'CSLL')) alias78;


BEGIN 
nr_seq_apres_w := nr_seq_posicao_p;
ie_mes_w := '01';
ie_entou_w := false;
ds_arquivo_ret_w := 'RTRT' || separador_w;
ds_arquivo_ir_w := 'RTIRF' || separador_w;
 
while (ie_mes_w)::numeric  <= 13 loop 
	OPEN c01;
	LOOP 
	FETCH c01 INTO 
		vl_rendimento_w, 
		vl_irrf_w;	
	EXIT WHEN NOT FOUND; /* apply on c01 */
		if ((ie_mes_w)::numeric  = 13) and (coalesce(vl_rendimento_w,0) = 0) then 
		ds_arquivo_ret_w := ds_arquivo_ret_w || separador_w;		
		elsif (coalesce(vl_rendimento_w,0) = 0) then 
			ds_arquivo_ret_w := ds_arquivo_ret_w || lpad(replace(campo_mascara(coalesce('0','0'),2),'.',''),15,'0') || separador_w;
		else 
			ds_arquivo_ret_w := ds_arquivo_ret_w || lpad(replace(campo_mascara(coalesce(vl_rendimento_w,'0'),2),'.',''),15,'0') || separador_w;
		end if;
	 
		if ((ie_mes_w)::numeric  = 13) and (coalesce(vl_irrf_w,0) = 0) then 
			ds_arquivo_ir_w := ds_arquivo_ir_w  || separador_w;
		elsif (coalesce(vl_irrf_w,0) = 0) then 
			ds_arquivo_ir_w := ds_arquivo_ir_w || lpad(replace(campo_mascara(coalesce('0','0'),2),'.',''),15,'0') || separador_w;
		else 
			ds_arquivo_ir_w := ds_arquivo_ir_w || lpad(replace(campo_mascara(coalesce(vl_irrf_w,'0'),2),'.',''),15,'0') || separador_w;
		end if;
	 
	 
		/*if (nvl(vl_rendimento_w,0) = 0) then 
			ds_arquivo_ret_w := ds_arquivo_ret_w || separador_w;	 
		else 
			ds_arquivo_ret_w := ds_arquivo_ret_w || lpad(replace(campo_mascara(nvl(vl_rendimento_w,'0'),2),'.',''),15,'0') || separador_w; 
		end if; 
		 
		if (nvl(vl_irrf_w,0) = 0) then 
			ds_arquivo_ir_w := ds_arquivo_ir_w  || separador_w;			 
		else 
			ds_arquivo_ir_w	 := ds_arquivo_ir_w || lpad(replace(campo_mascara(nvl(vl_irrf_w,'0'),2),'.',''),15,'0') || separador_w; 
		end if; */
 
		ie_entou_w := true;
	END LOOP;
	CLOSE c01;	
	 
	/*if (not ie_entou_w) then 
		ds_arquivo_ret_w := ds_arquivo_ret_w || separador_w; 
		ds_arquivo_ir_w := ds_arquivo_ir_w  || separador_w;			 
	end if;*/
 
		 
	ie_entou_w := false;	
	ie_mes_w := to_char((ie_mes_w + 1)::numeric );		
end loop;
 
--registro de rentdimentos 
insert 	into w_dirf_arquivo(	   nr_sequencia, 
				   nm_usuario, 
				   nm_usuario_nrec, 
				   dt_atualizacao, 
				   dt_atualizacao_nrec, 
				   ds_arquivo, 
				   nr_seq_apresentacao, 
				   nr_seq_registro, 
				   cd_pessoa_fisica) 
		values (nextval('w_dirf_arquivo_seq'), 
				   nm_usuario_p, 
				   nm_usuario_p, 
				   clock_timestamp(), 
				   clock_timestamp(), 
				   DS_ARQUIVO_RET_W, 
				   nr_seq_apres_w, 
				   0, 
				   null);
 
nr_seq_apres_w := nr_seq_apres_w + 1; 				
 
--registro de IR 
insert 	into w_dirf_arquivo(nr_sequencia, 
				   nm_usuario, 
				   nm_usuario_nrec, 
				   dt_atualizacao, 
				   dt_atualizacao_nrec, 
				   ds_arquivo, 
				   nr_seq_apresentacao, 
				   nr_seq_registro, 
				   cd_pessoa_fisica) 
		values (nextval('w_dirf_arquivo_seq'), 
				   nm_usuario_p, 
				   nm_usuario_p, 
				   clock_timestamp(), 
				   clock_timestamp(), 
				   DS_ARQUIVO_IR_W, 
				   nr_seq_apres_w, 
				   0, 
				   null);				
commit;
nr_seq_apres_p := nr_seq_apres_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dirf_registro_val_mensais_pj ( cd_cgc_p text, cd_dirf_p text, dt_lote_p timestamp, nm_usuario_p text, nr_seq_posicao_p bigint, nr_seq_apres_p INOUT bigint, ie_tipo_data_p bigint, cd_estabelecimento_p text) FROM PUBLIC;

