-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dirf_registro_bpjdec ( nr_seq_lote_dirf_p bigint, nr_seq_arquivo_p bigint, cd_dirf_p text, nm_usuario_p text, nr_posicao_p INOUT bigint) AS $body$
DECLARE

				 
separador_w		varchar(1) := '|';		
dt_lote_w		timestamp;
cd_cgc_w		varchar(20);

ie_tipo_envio_w		smallint;
ie_data_w		smallint;

vl_rendimento_w		double precision;
vl_irrf_w		double precision;
ie_mes_w		varchar(2);
ds_arquivo_w		varchar(2000);
nr_seq_arquivo_w	bigint;

cd_pessoa_fisica_w	varchar(25);
vl_total_w		double precision;
nr_mes_w		smallint;
qt_dif_mes_w		bigint;
ie_contador_w		bigint;
ie_entou_w		boolean;
cd_estabelecimento_w	varchar(10);

nr_titulo_w		varchar(20);
				
C01 CURSOR FOR  -- busca todas as pessoas juridicas que possuem tituloas a pagar com retenção de imposto. 
SELECT	distinct 
	'BPJDEC' || separador_w || 
	p.cd_cgc || separador_w || 
	OBTER_NOME_PF_PJ(null,p.cd_cgc) || separador_w, 
	p.cd_cgc 
from	titulo_pagar p, 
	titulo_pagar_imposto i, 
	tributo t 
where	p.nr_titulo = i.nr_titulo 
and	i.cd_tributo = t.cd_tributo 
and	trunc(p.dt_contabil,'YYYY') = trunc(dt_lote_w,'YYYY') 
and	(p.cd_cgc IS NOT NULL AND p.cd_cgc::text <> '') 
and	( (p.cd_estabelecimento = coalesce(cd_estabelecimento_w,p.cd_estabelecimento)) 
or    ((coalesce(p.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_w::text, '') = ''))) 
and	coalesce(i.cd_darf, 
	  substr(obter_codigo_darf(i.cd_tributo, 
				   (obter_descricao_padrao('TITULO_PAGAR','CD_ESTABELECIMENTO',i.nr_titulo))::numeric , 
				   obter_descricao_padrao('TITULO_PAGAR','CD_CGC',i.nr_titulo), 
				   null),1,10) 
	  ) = cd_dirf_p 
--and	i.cd_darf	= cd_dirf_p 
and	p.ie_situacao <> 'C' 
and	p.ie_origem_titulo in (select y.ie_origem_titulo from dirf_regra_origem_tit y) 
and	((coalesce(t.ie_tipo_tributo,'IR') = 'IR') 
or (coalesce(t.ie_tipo_tributo,'PIS') = 'PIS') 
or (coalesce(t.ie_tipo_tributo,'COFINS') = 'COFINS') 
or (coalesce(t.ie_tipo_tributo,'CSLL') = 'CSLL')) 
order by p.cd_cgc;

C02 CURSOR FOR 
SELECT	distinct 
	'BPJDEC' || separador_w || 
	p.cd_cgc || separador_w || 
	OBTER_NOME_PF_PJ(null,p.cd_cgc) || separador_w, 
	p.cd_cgc 
from	titulo_pagar p, 
	titulo_pagar_imposto i, 
	tributo t 
where	p.nr_titulo = i.nr_titulo 
and	i.cd_tributo = t.cd_tributo 
and	trunc(p.dt_liquidacao,'YYYY') = trunc(dt_lote_w,'YYYY') 
and	(p.cd_cgc IS NOT NULL AND p.cd_cgc::text <> '') 
and	( (p.cd_estabelecimento = coalesce(cd_estabelecimento_w,p.cd_estabelecimento)) 
or    ((coalesce(p.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_w::text, '') = ''))) 
and	coalesce(i.cd_darf, 
	  substr(obter_codigo_darf(i.cd_tributo, 
				   (obter_descricao_padrao('TITULO_PAGAR','CD_ESTABELECIMENTO',i.nr_titulo))::numeric , 
				   obter_descricao_padrao('TITULO_PAGAR','CD_CGC',i.nr_titulo), 
				   null),1,10) 
	  ) = cd_dirf_p 
--and	i.cd_darf	= cd_dirf_p 
and	p.ie_situacao <> 'C' 
and	p.ie_origem_titulo in (SELECT y.ie_origem_titulo from dirf_regra_origem_tit y) 
and	((coalesce(t.ie_tipo_tributo,'IR') = 'IR') 
or (coalesce(t.ie_tipo_tributo,'PIS') = 'PIS') 
or (coalesce(t.ie_tipo_tributo,'COFINS') = 'COFINS') 
or (coalesce(t.ie_tipo_tributo,'CSLL') = 'CSLL')) 
order by p.cd_cgc;

 
C03 CURSOR FOR  -- busca todas as pessoas juridicas que possuem tituloas a pagar com retenção de imposto. 
SELECT	distinct 
	'BPJDEC' || separador_w || 
	coalesce(p.cd_cgc,'') || separador_w || 
	OBTER_NOME_PF_PJ(null,p.cd_cgc) || separador_w , 
	p.cd_cgc 
from	titulo_pagar p, 
	titulo_pagar_imposto i, 
	tributo t 
where	p.nr_titulo = i.nr_titulo 
and	i.cd_tributo = t.cd_tributo 
and	( (p.cd_estabelecimento = coalesce(cd_estabelecimento_w,p.cd_estabelecimento)) 
or    ((coalesce(p.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_w::text, '') = ''))) 
and	trunc(p.dt_emissao,'YYYY') = trunc(dt_lote_w,'YYYY') 
and	(p.cd_cgc IS NOT NULL AND p.cd_cgc::text <> '') 
and	coalesce(i.cd_darf, 
	  substr(obter_codigo_darf(i.cd_tributo, 
				   (obter_descricao_padrao('TITULO_PAGAR','CD_ESTABELECIMENTO',i.nr_titulo))::numeric , 
				   obter_descricao_padrao('TITULO_PAGAR','CD_CGC',i.nr_titulo), 
				   null),1,10) 
	  ) = cd_dirf_p 
--and	i.cd_darf	= cd_dirf_p 
and	p.ie_situacao <> 'C' 
--and	p.ie_origem_titulo in (1,3,5) 
and	p.ie_origem_titulo in (select y.ie_origem_titulo from dirf_regra_origem_tit y) 
and	((coalesce(t.ie_tipo_tributo,'IR') = 'IR') 
or (coalesce(t.ie_tipo_tributo,'PIS') = 'PIS') 
or (coalesce(t.ie_tipo_tributo,'COFINS') = 'COFINS') 
or (coalesce(t.ie_tipo_tributo,'CSLL') = 'CSLL')) 
order by p.cd_cgc;

 
 

BEGIN 
 
nr_seq_arquivo_w := nr_seq_arquivo_p;
 
select 	coalesce(dt_lote,clock_timestamp()), 
	coalesce(ie_tipo_envio, 1), 
	cd_estabelecimento 
into STRICT	dt_lote_w, 
	ie_tipo_envio_w, 
	cd_estabelecimento_w 
from	dirf_lote 
where	nr_sequencia = nr_seq_lote_dirf_p;
 
if ((cd_dirf_p)::numeric  in (1708,8045,3280) and (ie_tipo_envio_w = 2)) then 
	begin 
	 
 
	open C01;
	loop 
	fetch C01 into	 
		ds_arquivo_w, 
		cd_cgc_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		nr_seq_arquivo_w := nr_seq_arquivo_w + 1;
		insert 	into w_dirf_arquivo(nr_sequencia, 
					   nm_usuario, 
					   nm_usuario_nrec, 
					   dt_atualizacao, 
					   dt_atualizacao_nrec, 
					   ds_arquivo, 
					   nr_seq_apresentacao, 
					   nr_seq_registro, 
					   cd_cgc, 
					   cd_darf) 
		values (nextval('w_dirf_arquivo_seq'), 
					   nm_usuario_p, 
					   nm_usuario_p, 
					   clock_timestamp(), 
					   clock_timestamp(), 
					   ds_arquivo_w, 
					   nr_seq_arquivo_w, 
					   0, 
					   cd_cgc_w, 
					   cd_dirf_p);	
					   
		nr_seq_arquivo_w := DIRF_REGISTRO_VAL_MENSAIS_PJ(cd_cgc_w, cd_dirf_p, dt_lote_w, nm_usuario_p, nr_seq_arquivo_w, nr_seq_arquivo_w, 1, cd_estabelecimento_w);
		end;
		 
	end loop;
	close C01;
	end;
 
 
elsif ((cd_dirf_p)::numeric  in (5952,5960,5979,5987) and (ie_tipo_envio_w = 2)) then 
	begin 
	open C02;
	loop 
	fetch C02 into	 
		ds_arquivo_w, 
		cd_cgc_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		nr_seq_arquivo_w := nr_seq_arquivo_w + 1;
		insert 	into w_dirf_arquivo(nr_sequencia, 
					   nm_usuario, 
					   nm_usuario_nrec, 
					   dt_atualizacao, 
					   dt_atualizacao_nrec, 
					   ds_arquivo, 
					   nr_seq_apresentacao, 
					   nr_seq_registro, 
					   cd_cgc, 
					   cd_darf) 
		values (nextval('w_dirf_arquivo_seq'), 
					   nm_usuario_p, 
					   nm_usuario_p, 
					   clock_timestamp(), 
					   clock_timestamp(), 
					   ds_arquivo_w, 
					   nr_seq_arquivo_w, 
					   0, 
					   cd_cgc_w, 
					   cd_dirf_p);
		nr_seq_arquivo_w := DIRF_REGISTRO_VAL_MENSAIS_PJ(cd_cgc_w, cd_dirf_p, dt_lote_w, nm_usuario_p, nr_seq_arquivo_w, nr_seq_arquivo_w, 2, cd_estabelecimento_w);					
					   
		end;
		 
	end loop;
	close C02;
	end;
 
 
 
elsif (ie_tipo_envio_w = 1) then 
	begin 
	open C03;
	loop 
	fetch C03 into	 
		ds_arquivo_w, 
		cd_cgc_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		nr_seq_arquivo_w := nr_seq_arquivo_w + 1;
		insert 	into w_dirf_arquivo(nr_sequencia, 
					   nm_usuario, 
					   nm_usuario_nrec, 
					   dt_atualizacao, 
					   dt_atualizacao_nrec, 
					   ds_arquivo, 
					   nr_seq_apresentacao, 
					   nr_seq_registro, 
					   cd_cgc, 
					   cd_darf) 
		values (nextval('w_dirf_arquivo_seq'), 
					   nm_usuario_p, 
					   nm_usuario_p, 
					   clock_timestamp(), 
					   clock_timestamp(), 
					   ds_arquivo_w, 
					   nr_seq_arquivo_w, 
					   0, 
					   cd_cgc_w, 
					   cd_dirf_p);
		nr_seq_arquivo_w := DIRF_REGISTRO_VAL_MENSAIS_PJ(cd_cgc_w, cd_dirf_p, dt_lote_w, nm_usuario_p, nr_seq_arquivo_w, nr_seq_arquivo_w, 3, cd_estabelecimento_w);					
					   
		end;
		 
	end loop;
	close C03;
	end;
end if;
 
 
commit;
nr_posicao_p := nr_seq_arquivo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dirf_registro_bpjdec ( nr_seq_lote_dirf_p bigint, nr_seq_arquivo_p bigint, cd_dirf_p text, nm_usuario_p text, nr_posicao_p INOUT bigint) FROM PUBLIC;

