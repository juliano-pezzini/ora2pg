-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_gerar_consulta_orc ( nr_seq_orcamento_p bigint, nr_seq_orc_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


--c01
nr_seq_projeto_w				bigint;
nr_seq_orcamento_w			bigint;
nr_seq_etapa_w				bigint;
nr_seq_plano_w				bigint;
cd_centro_custo_w				bigint;
cd_material_w				bigint;
--c02
nr_seq_nota_fiscal_w			bigint;
nr_seq_orc_item_gpi_w			bigint;
nr_sequencia_nf_w				bigint;
vl_liquido_w				w_gpi_consulta_orc.vl_realizado%type;
nr_seq_conta_gpi_w			bigint;
--c03
nr_requisicao_w 				bigint;
--c04 
nr_titulo_w				bigint;
nr_documento_w				bigint;
-- c05 
nr_seq_ordem_servico_w			bigint;
nr_documento_ww				varchar(20);

ds_tipo_nf_w				w_gpi_consulta_orc.ds_tipo%type;
ds_tipo_req_w				w_gpi_consulta_orc.ds_tipo%type;
ds_tipo_tip_w				w_gpi_consulta_orc.ds_tipo%type;
ds_tipo_os_w				w_gpi_consulta_orc.ds_tipo%type;

c01 CURSOR FOR
SELECT	distinct
	nr_sequencia,
	nr_seq_orcamento,						
	nr_seq_etapa,							
	nr_seq_plano, 		
	cd_centro_custo,    					
	cd_material	
from	gpi_orc_item
where	nr_seq_orcamento	= nr_seq_orcamento_p
and (nr_sequencia 	= nr_seq_orc_item_p or nr_seq_orc_item_p = 0);


-- nota fiscal item
c02 CURSOR FOR	

SELECT	a.nr_sequencia,
	coalesce(c.nr_seq_orc_item_gpi,a.nr_seq_orc_item_gpi) nr_seq_orc_item_gpi,
	a.nr_sequencia_nf,
	a.nr_seq_conta_gpi,
	coalesce(c.vl_rateio,a.vl_liquido) vl_liquido
FROM nota_fiscal b, nota_fiscal_item a
LEFT OUTER JOIN nota_fiscal_item_rateio c ON (a.nr_sequencia = c.nr_seq_nota AND a.nr_item_nf = c.nr_item_nf)
WHERE a.nr_sequencia = b.nr_sequencia and coalesce(b.ie_situacao,0) = 1   and a.nr_seq_proj_gpi	= nr_seq_projeto_w and (coalesce(c.nr_seq_orc_item_gpi,a.nr_seq_orc_item_gpi)	= nr_seq_orc_item_gpi_w)

union all

SELECT	a.nr_sequencia,
	a.nr_seq_orc_item_gpi,
	a.nr_sequencia_nf,
	a.nr_seq_conta_gpi,
	(a.vl_liquido) vl_liquido
from	nota_fiscal b,	
	nota_fiscal_item a
where	a.nr_sequencia = b.nr_sequencia
and	coalesce(b.ie_situacao,0) = 1	
and	a.nr_seq_proj_gpi	= nr_seq_projeto_w
and	a.nr_seq_etapa_gpi	= nr_seq_etapa_w 
and	a.cd_centro_custo	= coalesce(cd_centro_custo_w, a.cd_centro_custo)
and	a.cd_material		= coalesce(cd_material_w, a.cd_material)
and	coalesce(a.nr_seq_orc_item_gpi::text, '') = '';

--requisicao
c03 CURSOR FOR
SELECT	a.nr_requisicao,
	(coalesce(b.qt_material_atendida,0) * coalesce(obter_custo_medio_material(1,trunc(b.dt_atendimento,'mm'),b.cd_material),0)) vl_liquido					
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao  	= b.nr_requisicao
and	a.nr_seq_proj_gpi 	= nr_seq_projeto_w
and	b.nr_seq_etapa_gpi 	=  nr_seq_etapa_w
and	coalesce(b.nr_seq_orc_item_gpi::text, '') = ''

union

SELECT	a.nr_requisicao,
	(coalesce(b.qt_material_atendida,0) * coalesce(obter_custo_medio_material(1,trunc(b.dt_atendimento,'mm'),b.cd_material),0)) vl_liquido
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao  	= b.nr_requisicao
and	a.nr_seq_proj_gpi 	= nr_seq_projeto_w
and	b.nr_seq_orc_item_gpi 	= nr_seq_orc_item_gpi_w
order by 1 desc;

--titulos a pagar
c04 CURSOR FOR
SELECT	a.nr_titulo,					
	a.nr_documento						
from	titulo_pagar a
where	(a.nr_seq_etapa_gpi IS NOT NULL AND a.nr_seq_etapa_gpi::text <> '')
and	a.nr_seq_proj_gpi		= nr_seq_projeto_w
and	a.nr_seq_etapa_gpi  	= nr_seq_etapa_w
order by a.dt_emissao;	

c05 CURSOR FOR
SELECT	a.nr_sequencia						
from	man_ordem_servico_v a
where	a.nr_seq_proj_gpi		= nr_seq_projeto_w
and	a.nr_seq_etapa_gpi = nr_seq_etapa_w
order by 1;


BEGIN

select	max(nr_seq_projeto)
into STRICT	nr_seq_projeto_w
from	gpi_orcamento
where	nr_sequencia = nr_seq_orcamento_p;

delete FROM w_gpi_consulta_orc
where nm_usuario = nm_usuario_p;

ds_tipo_nf_w	:= wheb_mensagem_pck.get_texto(299412);
ds_tipo_req_w	:= wheb_mensagem_pck.get_texto(299414);
ds_tipo_tip_w	:= wheb_mensagem_pck.get_texto(299416);
ds_tipo_os_w	:= wheb_mensagem_pck.get_texto(299417);

open c01;
loop
fetch c01 into	
	nr_seq_orc_item_gpi_w,		
	nr_seq_orcamento_w,			
	nr_seq_etapa_w,			
	nr_seq_plano_w,				
	cd_centro_custo_w,			
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	open c02;
	loop
	fetch c02 into
		nr_seq_nota_fiscal_w,			
		nr_seq_orc_item_gpi_w,	  	
		nr_sequencia_nf_w,
		nr_seq_conta_gpi_w,
		vl_liquido_w;				
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		nr_documento_ww	:= substr(nr_seq_nota_fiscal_w,1,20);
		
		insert into w_gpi_consulta_orc(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_nota_fiscal,     
			nr_requisicao,          
			nr_seq_orcamento,       
			nr_seq_orc_item,       
			ie_tipo,                
			ds_tipo,                
			nr_documento,           
			nr_ordem_servico,       
			nr_titulo,              
			cd_centro_custo,        
			cd_conta_contabil,      
			nr_seq_conta_gpi,       
			nr_seq_etapa_gpi,       
			vl_realizado)  
		values ( nextval('gpi_orc_item_seq'),
			  clock_timestamp(),		
			  nm_usuario_p,
			  clock_timestamp(),
			  nm_usuario_p,
			  nr_seq_nota_fiscal_w,
			  null,
			  nr_seq_orcamento_w,			
			  nr_seq_orc_item_gpi_w,   
			  'NF',     			    
			  ds_tipo_nf_w,
			  nr_documento_ww,			
			  null,
			  null,				
			  cd_centro_custo_w,		
			  null,						
			  nr_seq_plano_w,						
			  nr_seq_etapa_w,			
			  vl_liquido_w);
		end;
		end loop;
	close c02;
	
	vl_liquido_w	:= 0;
	open c03;
	loop
	fetch c03 into
		nr_requisicao_w,
		vl_liquido_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		
		insert into w_gpi_consulta_orc(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_nota_fiscal,     
			nr_requisicao,          
			nr_seq_orcamento,       
			nr_seq_orc_item,       
			ie_tipo,                
			ds_tipo,                
			nr_documento,           
			nr_ordem_servico,       
			nr_titulo,              
			cd_centro_custo,        
			cd_conta_contabil,      
			nr_seq_conta_gpi,       
			nr_seq_etapa_gpi,       
			vl_realizado)  
		values ( nextval('gpi_orc_item_seq'),
			  clock_timestamp(),		
			  nm_usuario_p,
			  clock_timestamp(),
			  nm_usuario_p,
			  nr_sequencia_nf_w,
			  nr_requisicao_w,
			 nr_seq_orcamento_w,			
			  nr_seq_orc_item_gpi_w,   
			  'RQ',   			    
			  ds_tipo_req_w,     				
			  null,			
			  null,
			  null,				
			  cd_centro_custo_w,		
			  null,						
			  nr_seq_plano_w,						
			  nr_seq_etapa_w,			
			  vl_liquido_w);
		end;
	end loop;
	close c03;
			
		

	open c04;
	loop
	fetch c04 into	
		nr_titulo_w,				
		nr_documento_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin

		insert 	into w_gpi_consulta_orc(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_nota_fiscal,     
			nr_requisicao,          
			nr_seq_orcamento,       
			nr_seq_orc_item,       
			ie_tipo,                
			ds_tipo,                
			nr_documento,           
			nr_ordem_servico,       
			nr_titulo,              
			cd_centro_custo,        
			cd_conta_contabil,      
			nr_seq_conta_gpi,       
			nr_seq_etapa_gpi,       
			vl_realizado)  
		values ( nextval('gpi_orc_item_seq'),
			  clock_timestamp(),		
			  nm_usuario_p,
			  clock_timestamp(),
			  nm_usuario_p,
			  nr_sequencia_nf_w,
			  nr_requisicao_w,
			  nr_seq_orcamento_w,			
			  nr_seq_orc_item_gpi_w,   
			  'TP',   			    
			  ds_tipo_tip_w,
			  nr_documento_w,			
			  null,
			  nr_titulo_w,				
			  cd_centro_custo_w,		
			  null,						
			  nr_seq_plano_w,						
			  nr_seq_etapa_w,			
			  vl_liquido_w);

		end;
		end loop;
		close c04;



	open c05;
		loop
		fetch c05 into	
			nr_seq_ordem_servico_w;
		EXIT WHEN NOT FOUND; /* apply on c05 */
		
		 begin

		insert 	into w_gpi_consulta_orc(
			nr_sequencia,          
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_nota_fiscal,     
			nr_requisicao,          
			nr_seq_orcamento,       
			nr_seq_orc_item,
			ie_tipo,
			ds_tipo,
			nr_documento,
			nr_ordem_servico,
			nr_titulo,
			cd_centro_custo,
			cd_conta_contabil,
			nr_seq_conta_gpi,
			nr_seq_etapa_gpi,
			vl_realizado)
		values (	nextval('gpi_orc_item_seq'),
			clock_timestamp(),		
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_nf_w,
			nr_requisicao_w,
			nr_seq_orcamento_w,			
			nr_seq_orc_item_gpi_w,   
			'OS',     			    
			ds_tipo_os_w,
			nr_documento_w,			
			nr_seq_ordem_servico_w,
			nr_titulo_w,				
			cd_centro_custo_w,		
			null,						
			nr_seq_plano_w,						
			nr_seq_etapa_w,			
			vl_liquido_w);


	end;			
	 end loop;
	close c05;
	end;
	end loop;
close c01;
				
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_gerar_consulta_orc ( nr_seq_orcamento_p bigint, nr_seq_orc_item_p bigint, nm_usuario_p text) FROM PUBLIC;

