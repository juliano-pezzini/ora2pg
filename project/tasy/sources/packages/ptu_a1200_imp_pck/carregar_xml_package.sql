-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- Carregar o arquivo a1200 de XML
CREATE TYPE reg_cabecalho AS (	nrVerTra_PTU    	varchar(2),
					cd_Uni_Origem    	varchar(4),
					dt_geracao    		varchar(20),
					hash      		varchar(32),
					dt_postagem    		varchar(20),
					nr_protocolo    	varchar(10));
CREATE TYPE reg_pacote AS (	  cd_pacote      	integer,
					  nm_Pacote      	varchar(60),
					  dt_Negociacao      	varchar(20),
					  dt_Publicacao      	varchar(20),
					  tp_Acomodacao      	varchar(1),
					  tp_Pacote      	varchar(1),
					  cd_espec      	varchar(2),
					  dt_Ini_Vigencia      	varchar(20),
					  dt_Fim_Vigencia      	varchar(20),
					  tp_Internacao      	varchar(1),					  
					  id_Honor      	varchar(1),
					  tipo_rede_min      	varchar(1),
					  id_OPME        	varchar(1),
					  id_Anestesista	varchar(1),
					  id_Auxiliar      	varchar(1),
					  obs_pacote      	varchar(999),
					  vl_Tot_Taxas      	double precision,
					  vl_Tot_Diarias     	double precision,
					  vl_Tot_Gases      	double precision,
					  vl_Tot_Mat      	double precision,
					  vl_Tot_Med      	double precision,
					  vl_Tot_Proc      	double precision,
					  vl_Tot_OPME      	double precision,
					  vl_Tot_Pacote		double precision);
CREATE TYPE reg_servico_pacote AS (	tp_item        		varchar(1),
						tp_Tabela      		varchar(2),
						cd_Servico      	varchar(10),
						id_serv        		smallint,
						qt_serv        		varchar(255),
						vl_Serv        		varchar(255),
						ds_Servico      	varchar(80),
						vl_Serv_Tot      	double precision,
						Unidade_Medida      varchar(255),
						nr_sequencia		bigint);
CREATE TYPE reg_prestador AS (    cd_Uni_Prest      	varchar(4),
					  cd_Prest      	varchar(8),
					  nm_Prestador      	varchar(60),
					  cd_CNES        	varchar(255),
					  cd_cgc_cpf		varchar(255));
CREATE TYPE reg_prestador_cd_cnpj_cpf AS (	cd_cpf      	varchar(255),
							cd_cnpj      	varchar(255));


CREATE OR REPLACE PROCEDURE ptu_a1200_imp_pck.carregar_xml ( nr_seq_arq_xml_p ptu_aviso_arq_xml.nr_sequencia%type, ie_tipo_arquivo_p ptu_aviso_arq_xml.ie_tipo_arquivo%type, nm_usuario_p usuario.nm_usuario%type, nm_arquivo_p ptu_pacote.ds_arquivo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_pacote_p INOUT bigint) AS $body$
DECLARE


	-- CABECALHO
						
	type tab_cabecalho is table of reg_cabecalho index by integer;


	-- PACOTE
		
	type tab_pacote is table of reg_pacote index by integer;

	
	--  SERVICOS PACOTE
						
	type tab_servico_pacote is table of reg_servico_pacote index by integer;

	
	--  PRESTADOR
					
	type tab_prestador is table of reg_prestador index by integer;

	
	--  PRESTADOR cd_cnpj_cpf
							
	type tab_prestador_cd_cnpj_cpf is table of reg_prestador_cd_cnpj_cpf index by integer;
	

	-- VARIAVEIS	
	t_inconsistencia 		ptu_a1200_imp_pck.t_inconsistencia_type;	
		
	vet_tab_cabecalho_w    		tab_cabecalho;
	vet_tab_pacote_w    		tab_pacote;	
	vet_servico_pacote_w    	tab_servico_pacote;
	vet_prestador_w      		tab_prestador;
	vet_prestador_cd_cnpj_cpf_w  	tab_prestador_cd_cnpj_cpf;
	
	nr_seq_pacote_reg_w    		ptu_pacote_reg.nr_sequencia%type;
	nr_seq_pacote_servico_w		ptu_pacote_servico.nr_sequencia%type;
	nr_seq_pacote_prest_w		ptu_pacote_prest.nr_sequencia%type;

	-- INDICES
	iPct      			integer; -- Indice pacotes
	iSrv      			integer; -- Indice serviCos
	iPrt      			integer; -- Indice prestadores
	
	vl_Tot_Taxas_w 		ptu_pacote_reg.vl_tot_taxas%type   :=0;
	vl_Tot_Diarias_w	ptu_pacote_reg.vl_tot_diarias%type :=0;
	vl_Tot_Gases_w		ptu_pacote_reg.vl_tot_gases%type   :=0;
	vl_Tot_Mat_w		ptu_pacote_reg.vl_tot_mat%type     :=0;
	vl_Tot_Med_w		ptu_pacote_reg.vl_tot_med%type     :=0;
	vl_Tot_Proc_w		ptu_pacote_reg.vl_tot_proc%type    :=0;
	vl_Tot_OPME_w		ptu_pacote_reg.vl_tot_opme%type    :=0;
	vl_Tot_Pacote_w		ptu_pacote_reg.vl_tot_pacote%type  :=0;	
	ie_honorario_w 		ptu_pacote_reg.ie_honorario%type;
	
	id_serv_w		ptu_pacote_servico.ie_principal%type;
	tp_item_w		ptu_pacote_servico.ie_tipo_item%type;
	vl_serv_w		ptu_pacote_servico.vl_servico%type;
	qt_serv_w		ptu_pacote_servico.qt_servico%type;	
	vl_Serv_Tot_w	ptu_pacote_servico.vl_serv_tot%type;
	vl_serv_count   smallint := 0;
	
	-- CURSORES
	-- ARQUIVO XML
	C01 CURSOR( nr_seq_arq_xml_pc  ptu_aviso_arq_xml.nr_sequencia%type ) FOR
		  SELECT  	xml.createxml(replace(ds_arquivo, CHR(191),'')) ds_arq_xml
		  from  	ptu_aviso_arq_xml
		  where  	nr_sequencia = nr_seq_arq_xml_pc;

		
	-- CABECALHO
	c_cabecalho CURSOR( ds_arq_xml_pc    xml ) FOR
		  SELECT  *
		  from  xmltable('/ptuA1200/cabecalho' passing ds_arq_xml_pc columns
			nrVerTra_PTU      		varchar(2)    	 path  'nrVerTra_PTU',
			cd_Uni_Origem      		varchar(255)    path  'cd_Uni_Origem',
			dt_geracao      		varchar(255)    path  'dt_geracao');
	
	    
	-- PACOTE
	c_pacote CURSOR( ds_arq_xml_pc    xml ) FOR
		  SELECT  *
		  from  xmltable('/ptuA1200/A1200/pacote' passing ds_arq_xml_pc columns
		        cd_pacote      			varchar(8)    	 path  'cd_pacote',
		        nm_Pacote      			varchar(255)    path  'nm_Pacote',
		        dt_Negociacao    	 	varchar(255)    path  'dt_Negociacao',
		        dt_Publicacao     	 	varchar(255)    path  'dt_Publicacao',
		        tp_Acomodacao      		varchar(255)    path  'tp_Acomodacao',
		        tp_Pacote     	 		varchar(255)    path  'tp_Pacote',
		        cd_espec      			varchar(255)    path  'cd_espec',
			dt_Ini_Vigencia    		varchar(255)    path  'dt_Ini_Vigencia',
			dt_Fim_Vigencia     		varchar(255)    path  'dt_Fim_Vigencia',
			tp_Internacao      		varchar(255)    path  'tp_Internacao',			
			vl_Tot_Pacote      		varchar(255)    path  'vl_Tot_Pacote',
			id_Honor      			varchar(255)    path  'id_Honor',
			tipo_rede_min      		varchar(255)    path  'tipo_rede_min',
			id_OPME        			varchar(255)    path  'id_OPME',
			id_Anestesista      		varchar(255)    path  'id_Anestesista',
			id_Auxiliar      		varchar(255)    path  'id_Auxiliar',
			obs_pacote      		varchar(999)    path  'obs_pacote',
			vl_pacotes      		xml      	 path  'vl_pacotes',
			servico_pacote      		xml      	 path  'servico_pacote',
			prestador      			xml      	 path  'prestador');
	
	  -- VALORES
	  c_vl_pacote CURSOR( vl_pacotes    xml ) FOR
		    SELECT  *
		    from  xmltable('/vl_pacotes' passing vl_pacotes columns
		          vl_Tot_Taxas        		varchar(255)    path  'vl_Tot_Taxas',
		          vl_Tot_Diarias        	varchar(255)    path  'vl_Tot_Diarias',
		          vl_Tot_Gases        		varchar(255)    path  'vl_Tot_Gases',
		          vl_Tot_Mat        		varchar(255)    path  'vl_Tot_Mat',
		          vl_Tot_Med        		varchar(255)    path  'vl_Tot_Med',
		          vl_Tot_Proc        		varchar(255)    path  'vl_Tot_Proc',
		          vl_Tot_OPME        		varchar(255)    path  'vl_Tot_OPME');
	
	  -- SERVICOS
	  c_servico_pacote CURSOR( servico_pacote    xml ) FOR
		    SELECT  *
		    from  xmltable('/servico_pacote' passing servico_pacote columns
		          tp_item          		varchar(255)    path  'tp_item',
			  tp_Tabela        		varchar(255)    path  'tp_Tabela',
		          cd_Servico        		varchar(255)    path  'cd_Servico',
		          id_serv          		varchar(255)    path  'id_serv',
		          qt_serv          		varchar(255)    path  'qt_serv',
		          vl_Serv          		varchar(255)    path  'vl_Serv',
		          ds_Servico        		varchar(255)    path  'ds_Servico',
		          vl_Serv_Tot        		varchar(255)    path  'vl_Serv_Tot',
		          Unidade_Medida        	varchar(255)    path  'Unidade_Medida');
		
	  -- PRESTADORES
	  c_prestador CURSOR( prestador    xml ) FOR
		    SELECT  *
		    from  xmltable('/prestador' passing prestador columns
			  cd_Uni_Prest        		varchar(255)    path  'cd_Uni_Prest',
			  cd_Prest        		varchar(255)    path  'cd_Prest',
			  nm_Prestador        		varchar(255)    path  'nm_Prestador',
			  cd_cnpj_cpf        		xml      	 path  'cd_cnpj_cpf',
			  cd_CNES          		varchar(255)    path  'cd_CNES');

		    c_prestador_cpf_cnpj CURSOR( cd_cnpj_cpf    xml ) FOR
			      SELECT  *
			      from  xmltable('/cd_cnpj_cpf' passing cd_cnpj_cpf columns
				    cd_cpf        	varchar(255)  	 path  'cd_cpf',
				    cd_cnpj        	varchar(255)  	 path  'cd_cnpj');
			
	-- HASH
	c_hash CURSOR( ds_arq_xml_pc    xml ) FOR
		  SELECT  *
		  from  xmltable('/ptuA1200/hash' passing ds_arq_xml_pc columns
			hash          		varchar(255)  	 path  'hash');
			
	-- CARIMBO
	c_carimbo_cmb CURSOR( ds_arq_xml_pc    xml ) FOR
		  SELECT  *
		  from  xmltable('/ptuA1200/carimboCMB' passing ds_arq_xml_pc columns
			dt_postagem        	varchar(21)  	 path  'dt_postagem',
			nr_protocolo        	varchar(10)  	 path  'nr_protocolo');


	
BEGIN

	-- ARQUIVO XML
	for r_c01_w in c01( nr_seq_arq_xml_p ) loop

		-- /PTUA1200/CABECALHO
		for r_cabecalho_w in c_cabecalho( r_c01_w.ds_arq_xml ) loop
			vet_tab_cabecalho_w[1].nrVerTra_PTU  		:= lpad(r_cabecalho_w.nrVerTra_PTU,'2','0');
			vet_tab_cabecalho_w[1].cd_Uni_Origem  		:= r_cabecalho_w.cd_Uni_Origem;
			vet_tab_cabecalho_w[1].dt_geracao  		:= r_cabecalho_w.dt_geracao;
		end loop;

		-- /PTUA1200/HASH
		for r_hash_w in c_hash( r_c01_w.ds_arq_xml ) loop
			vet_tab_cabecalho_w[1].hash    			:= r_hash_w.hash;
		end loop;

		--- /PTUA1200/CARIMBO CMB
		for r_carimbo_cmb in c_carimbo_cmb( r_c01_w.ds_arq_xml ) loop
			vet_tab_cabecalho_w[1].dt_postagem  		:= to_char(to_date(r_carimbo_cmb.dt_postagem, 'yyyy/mm/ddhh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
			vet_tab_cabecalho_w[1].nr_protocolo  		:= r_carimbo_cmb.nr_protocolo;
		end loop;

		-- /PTUA1200/A1200/PACOTE
		for r_pacote_a1200_w in c_pacote( r_c01_w.ds_arq_xml ) loop

			iPct := vet_tab_pacote_w.count + 1;
			
			r_pacote_a1200_w.dt_Negociacao		:= ptu_a1200_imp_pck.converte_data(r_pacote_a1200_w.dt_Negociacao);
			r_pacote_a1200_w.dt_Publicacao		:= ptu_a1200_imp_pck.converte_data(r_pacote_a1200_w.dt_Publicacao);
			r_pacote_a1200_w.dt_Ini_Vigencia 	:= ptu_a1200_imp_pck.converte_data(r_pacote_a1200_w.dt_Ini_Vigencia);
			r_pacote_a1200_w.dt_Fim_Vigencia 	:= ptu_a1200_imp_pck.converte_data(r_pacote_a1200_w.dt_Fim_Vigencia);
			ie_honorario_w				:= coalesce(r_pacote_a1200_w.id_Honor, 'N');	
			
			vl_Tot_Taxas_w   := 0;
			vl_Tot_Diarias_w := 0;
			vl_Tot_Mat_w     := 0;
			vl_Tot_Gases_w   := 0;
			vl_Tot_Med_w     := 0;
			vl_Tot_Proc_w    := 0;
			vl_Tot_OPME_w    := 0;
			
			
			vet_tab_pacote_w[iPct].cd_pacote  		:= (r_pacote_a1200_w.cd_pacote)::numeric;
			vet_tab_pacote_w[iPct].nm_Pacote  		:= r_pacote_a1200_w.nm_Pacote;
			vet_tab_pacote_w[iPct].dt_Negociacao  		:= r_pacote_a1200_w.dt_Negociacao;
			vet_tab_pacote_w[iPct].dt_Publicacao  		:= r_pacote_a1200_w.dt_Publicacao;
			vet_tab_pacote_w[iPct].tp_Acomodacao  		:= r_pacote_a1200_w.tp_Acomodacao;
			vet_tab_pacote_w[iPct].tp_Pacote  		:= r_pacote_a1200_w.tp_Pacote;
			vet_tab_pacote_w[iPct].cd_espec    		:= r_pacote_a1200_w.cd_espec;
			vet_tab_pacote_w[iPct].dt_Ini_Vigencia  	:= r_pacote_a1200_w.dt_Ini_Vigencia;
			vet_tab_pacote_w[iPct].dt_Fim_Vigencia  	:= r_pacote_a1200_w.dt_Fim_Vigencia;
			vet_tab_pacote_w[iPct].tp_Internacao  		:= r_pacote_a1200_w.tp_Internacao;			
			vet_tab_pacote_w[iPct].id_Honor    		:= ie_honorario_w;
			vet_tab_pacote_w[iPct].tipo_rede_min  		:= r_pacote_a1200_w.tipo_rede_min;
			vet_tab_pacote_w[iPct].id_OPME    		:= r_pacote_a1200_w.id_OPME;
			vet_tab_pacote_w[iPct].id_Anestesista  		:= r_pacote_a1200_w.id_Anestesista;
			vet_tab_pacote_w[iPct].id_Auxiliar  		:= r_pacote_a1200_w.id_Auxiliar;
			vet_tab_pacote_w[iPct].obs_pacote  		:= r_pacote_a1200_w.obs_pacote;
			

			-- /PTUA1200/A1200/SERVICO_PACOTE
			for r_servico_pacote_w in c_servico_pacote( r_pacote_a1200_w.servico_pacote ) loop

				id_serv_w  	:=  coalesce((r_servico_pacote_w.id_serv)::numeric , 0);
				tp_item_w  	:=  (r_servico_pacote_w.tp_item)::numeric;
				vl_serv_w  	:=  (coalesce(r_servico_pacote_w.vl_Serv, 0))::numeric;
				qt_serv_w	:=  coalesce((r_servico_pacote_w.qt_serv)::numeric , 1);
				vl_Serv_Tot_w 	:=  (vl_serv_w * qt_serv_w);

				
				-- Regra para totalizar pelo tipo de item
				if (tp_item_w = 1 and vl_serv_w <> 0) then
					vl_Tot_Taxas_w := vl_Tot_Taxas_w + vl_Serv_Tot_w;
				elsif (tp_item_w = 2 and vl_serv_w <> 0) then
					vl_Tot_Diarias_w := vl_Tot_Diarias_w + vl_Serv_Tot_w;									
				elsif (tp_item_w = 3 and vl_serv_w <> 0) then
					vl_Tot_Gases_w := vl_Tot_Gases_w + vl_Serv_Tot_w;					
				elsif (tp_item_w = 4 and vl_serv_w <> 0) then
					vl_Tot_Mat_w  := vl_Tot_Mat_w + vl_Serv_Tot_w;					
				elsif (tp_item_w = 5 and vl_serv_w <> 0) then
					vl_Tot_Med_w  := vl_Tot_Med_w + vl_Serv_Tot_w;					
				elsif (tp_item_w = 6 and vl_serv_w <> 0) then
					vl_Tot_Proc_w := vl_Tot_Proc_w + vl_Serv_Tot_w;					
				elsif (tp_item_w = 7 and vl_serv_w <> 0) then
					vl_Tot_OPME_w := vl_Tot_OPME_w + vl_Serv_Tot_w;					
				end if;
				
				
				iSrv := vet_servico_pacote_w.count + 1;
				
				vet_servico_pacote_w[iSrv].tp_item      	:= tp_item_w;
				vet_servico_pacote_w[iSrv].tp_Tabela    	:= r_servico_pacote_w.tp_Tabela;
				vet_servico_pacote_w[iSrv].cd_Servico    	:= r_servico_pacote_w.cd_Servico;
				vet_servico_pacote_w[iSrv].id_serv    		:= id_serv_w;
				vet_servico_pacote_w[iSrv].qt_serv    		:= qt_serv_w;
				vet_servico_pacote_w[iSrv].vl_Serv    		:= vl_serv_w;				
				vet_servico_pacote_w[iSrv].ds_Servico    	:= r_servico_pacote_w.ds_Servico;
				vet_servico_pacote_w[iSrv].vl_Serv_Tot    	:= vl_Serv_Tot_w;
				vet_servico_pacote_w[iSrv].Unidade_Medida  	:= r_servico_pacote_w.Unidade_Medida;
				vet_servico_pacote_w[iSrv].nr_sequencia  	:= null;
				
				vl_Serv_Tot_w	:= 0;
				
				if (vl_serv_w > 0) then
					vl_serv_count := 1;
				end if;
				
			end loop;
			
			-- REGRA vl_Tot_Pacote
			vet_tab_pacote_w[iPct].vl_Tot_Pacote := (vl_Tot_Taxas_w   +
								 vl_Tot_Diarias_w +
								 vl_Tot_Gases_w   +
								 vl_Tot_Mat_w     +
								 vl_Tot_Med_w     +
								 vl_Tot_Proc_w    +
								 vl_Tot_OPME_w);
			
			vet_tab_pacote_w[iPct].vl_Tot_Taxas 	:= vl_Tot_Taxas_w;
			vet_tab_pacote_w[iPct].vl_Tot_Diarias 	:= vl_Tot_Diarias_w;			
			vet_tab_pacote_w[iPct].vl_Tot_Gases 	:= vl_Tot_Gases_w;
			vet_tab_pacote_w[iPct].vl_Tot_Mat   	:= vl_Tot_Mat_w;
			vet_tab_pacote_w[iPct].vl_Tot_Med   	:= vl_Tot_Med_w;
			vet_tab_pacote_w[iPct].vl_Tot_Proc  	:= vl_Tot_Proc_w;
			vet_tab_pacote_w[iPct].vl_Tot_OPME 	:= vl_Tot_OPME_w;
			
			
			-- /PTUA1200/A1200/PRESTADOR
			for r_prestador_w in c_prestador( r_pacote_a1200_w.prestador ) loop

				iPrt := vet_prestador_w.count + 1;

				vet_prestador_w[iPrt].cd_Uni_Prest    		:= r_prestador_w.cd_Uni_Prest;
				vet_prestador_w[iPrt].cd_Prest        		:= (r_prestador_w.cd_Prest)::numeric;
				vet_prestador_w[iPrt].nm_Prestador    		:= r_prestador_w.nm_Prestador;
				vet_prestador_w[iPrt].cd_CNES      		:= coalesce(r_prestador_w.cd_CNES, 9999999); -- REGRA Caso o prestador ainda nao possua o codigo do CNES, preencher com 9999999
				-- /PTUA1200/A1200/PRESTADOR/CD_CNPJ_CPF
				for r_prestador_cd_cnpj_cpf_w in c_prestador_cpf_cnpj( r_prestador_w.cd_cnpj_cpf ) loop
										
					vet_prestador_cd_cnpj_cpf_w[iPrt].cd_cpf  := r_prestador_cd_cnpj_cpf_w.cd_cpf;
					vet_prestador_cd_cnpj_cpf_w[iPrt].cd_cnpj := r_prestador_cd_cnpj_cpf_w.cd_cnpj;
				end loop;

			end loop;

		end loop;

	end loop;
		
	-- Pacote
	for i in 1..vet_tab_cabecalho_w.count loop

		vet_tab_cabecalho_w[i].dt_geracao  	:= ptu_a1200_imp_pck.converte_data(vet_tab_cabecalho_w[i].dt_geracao);
		vet_tab_cabecalho_w[i].dt_postagem  	:= ptu_a1200_imp_pck.converte_data(vet_tab_cabecalho_w[i].dt_postagem);
				
		insert into ptu_pacote(nr_sequencia,
			cd_unimed_origem, 
			dt_geracao,
			ie_tipo_carga, 
			ie_tipo_informacao , 
			nr_versao_transacao,
			cd_estabelecimento, 
			dt_atualizacao, 
			nm_usuario,
			dt_importacao, 
			nm_usuario_arq, 
			ds_arquivo, 
			ds_hash,
			dt_postagem,
			nr_protocolo)
		values (nextval('ptu_pacote_seq'),
			vet_tab_cabecalho_w[i].cd_Uni_Origem, 
			clock_timestamp(),
			1,
			1,
			vet_tab_cabecalho_w[i].nrVerTra_PTU,
			cd_estabelecimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nm_arquivo_p,
			vet_tab_cabecalho_w[i].hash,
			vet_tab_cabecalho_w[i].dt_postagem,
			vet_tab_cabecalho_w[i].nr_protocolo) returning nr_sequencia into nr_seq_pacote_p;

		--- Itens do pacote
		for j in 1..vet_tab_pacote_w.count loop
			
				ie_honorario_w 	:= coalesce(vet_tab_pacote_w[j].id_Honor, 'N');
				
				insert into 	ptu_pacote_reg(nr_sequencia,
						cd_pacote, 
						nm_pacote,
						cd_unimed_prestador, 
						cd_prestador, 
						nm_prestador,
						dt_negociacao, 
						dt_publicacao, 
						ie_tipo_acomodacao,
						ie_tipo_pacote, 
						cd_especialidade, 
						ds_observacao,
						dt_atualizacao, 
						nm_usuario, 
						nr_seq_pacote,
						ie_tipo_informacao, 
						dt_inicio_vigencia, 
						dt_fim_vigencia,
						ie_tipo_internacao, 
						vl_tot_taxas, 
						vl_tot_diarias,
						vl_tot_gases, 
						vl_tot_mat, 
						vl_tot_med,
						vl_tot_proc, 
						vl_tot_opme, 
						vl_tot_pacote,
						ie_honorario, 
						tipo_rede_min,
						ie_opme,	
						ie_anestesista,
						ie_auxiliar)
				values (nextval('ptu_pacote_reg_seq'),
						vet_tab_pacote_w[j].cd_pacote,
						vet_tab_pacote_w[j].nm_Pacote,
						null,
						null,
						null,
						vet_tab_pacote_w[j].dt_Negociacao,
						vet_tab_pacote_w[j].dt_Publicacao,
						vet_tab_pacote_w[j].tp_Acomodacao,
						vet_tab_pacote_w[j].tp_Pacote,
						vet_tab_pacote_w[j].cd_espec,
						vet_tab_pacote_w[j].obs_pacote,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_pacote_p,
						1,
						vet_tab_pacote_w[j].dt_Ini_Vigencia,
						vet_tab_pacote_w[j].dt_Fim_Vigencia,
						vet_tab_pacote_w[j].tp_Internacao,						
						vet_tab_pacote_w[j].vl_Tot_Taxas,
						vet_tab_pacote_w[j].vl_Tot_Diarias,
						vet_tab_pacote_w[j].vl_Tot_Gases,
						vet_tab_pacote_w[j].vl_Tot_Mat,
						vet_tab_pacote_w[j].vl_Tot_Med,
						vet_tab_pacote_w[j].vl_Tot_Proc,
						vet_tab_pacote_w[j].vl_Tot_OPME,
						vet_tab_pacote_w[j].vl_Tot_Pacote,	
						ie_honorario_w,
						vet_tab_pacote_w[j].tipo_rede_min,						
						vet_tab_pacote_w[j].id_OPME,
						vet_tab_pacote_w[j].id_Anestesista,
						vet_tab_pacote_w[j].id_Auxiliar) returning nr_sequencia into nr_seq_pacote_reg_w;


				--  A data de negociacao informada nao podera ser superior a data de inicio de vigencia
				if ( vet_tab_pacote_w[j].dt_Negociacao > vet_tab_pacote_w[j].dt_Ini_Vigencia ) then
					t_inconsistencia('dt_Ini_Vigencia') := 956892;
				end if;				
				
				--  Regra:  id_OPME Deve ser preenchido obrigatoriamente
				if (vet_tab_pacote_w[j]coalesce(.id_OPME::text, '') = '' ) then				
					t_inconsistencia('id_OPME') := 959580;
				end if;
				
				--  Regra:  id_Anestesista Deve ser preenchido apenas se houver honorarios medicos
				if ( ie_honorario_w = 'S' and vet_tab_pacote_w[j]coalesce(.id_Anestesista::text, '') = '' ) then				
					t_inconsistencia('id_Anestesista') := 956890;
				end if;
				
				--  Regra:  id_Auxiliar Deve ser preenchido apenas se houver honorarios medicos
				if ( ie_honorario_w = 'S' and vet_tab_pacote_w[j]coalesce(.id_Auxiliar::text, '') = '' ) then				
					t_inconsistencia('id_Auxiliar') := 956888;				
				end if;			
				
				-- REGRA  vl_Tot_Taxas
				if ( tp_item_w = 1 and id_serv_w = 2 and vl_serv_w = 0 ) then				
					t_inconsistencia('vl_Tot_Taxas') := 956886;					
				end if;
				
				-- REGRA  vl_Tot_Diarias
				if ( tp_item_w = 2 and id_serv_w = 2 and vl_serv_w = 0 ) then				
					t_inconsistencia('vl_Tot_Diarias') := 956884;					
				end if;
								
				-- REGRA  vl_Tot_Gases
				if ( tp_item_w = 3 and id_serv_w = 2 and vl_serv_w = 0 ) then
					t_inconsistencia('vl_Tot_Gases') := 956882;					
				end if;
				
				-- REGRA  vl_Tot_Mat
				if ( tp_item_w = 4 and id_serv_w = 2 and vl_serv_w = 0 ) then	
					t_inconsistencia('vl_Tot_Mat') := 956880;					
				end if;
				
				-- REGRA  vl_Tot_Med
				if ( tp_item_w = 5 and id_serv_w = 2 and vl_serv_w = 0 ) then				
					t_inconsistencia('vl_Tot_Med') := 956878;					
				end if;
				
				-- REGRA  vl_Tot_Proc								
				if ( tp_item_w = 6 and vl_serv_w = 0 ) then
					t_inconsistencia('vl_Tot_Proc') := 956876;
				end if;
				
				-- REGRA  vl_Tot_OPME
				if ( tp_item_w = 7 and vl_serv_w = 0) then					
					t_inconsistencia('vl_Tot_OPME') := 956874;
				end if;
				
				-- REGRA 2 vl_Tot_Proc	
				if ( vet_tab_pacote_w[j].vl_Tot_Proc > 0 ) then
					if ( id_serv_w = 3 ) then					
						t_inconsistencia('vl_Tot_Proc') := 956874; -- vl_Tot_Proc nao pode ter valor informado.
					elsif ( id_serv_w = 1 and ie_honorario_w = 'N' ) then					
						t_inconsistencia('vl_Tot_Proc') := 956874; --vl_Tot_Proc nao pode ter valor informado.						
					end if;				
				end if;
					
				
				-- verifica se existe inconsistencia para os itens
				if (t_inconsistencia.count > 0) then
					
					CALL ptu_a1200_imp_pck.insere_inconsistencias(t_inconsistencia, nr_seq_pacote_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_pacote_reg_w, 'ptu_pacote_reg');
					
					t_inconsistencia.delete;
					
				end if;

				
				-- ServiCos do pacote
				for k in 1..vet_servico_pacote_w.count loop
										
					id_serv_w	:=	vet_servico_pacote_w[k].id_serv;
					tp_item_w	:=	vet_servico_pacote_w[k].tp_item;
					qt_serv_w	:=	vet_servico_pacote_w[k].qt_serv;
					vl_serv_w	:=	vet_servico_pacote_w[k].vl_Serv;
					vl_serv_tot_w	:=	vet_servico_pacote_w[k].vl_Serv_Tot;
															
					insert   into 	ptu_pacote_servico(nr_sequencia,
							nr_seq_pacote_reg,																
							ie_tipo_item,
							ie_tipo_tabela,																
							cd_servico,																
							ie_principal,
							qt_servico,
							vl_servico,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,								
							nm_usuario_nrec,
							ie_tipo_participacao,
							ie_honorario,							
							ds_servico,
							vl_serv_tot,
							cd_unidade_medida)
					values (nextval('ptu_pacote_servico_seq'),
							nr_seq_pacote_reg_w,
							vet_servico_pacote_w[k].tp_item,
							vet_servico_pacote_w[k].tp_Tabela,
							vet_servico_pacote_w[k].cd_Servico,
							id_serv_w,
							qt_serv_w,
							vl_serv_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							null,
							ie_honorario_w,							
							vet_servico_pacote_w[k].ds_Servico,
							vl_serv_tot_w,
							(vet_servico_pacote_w[k].Unidade_Medida)::numeric ) returning nr_sequencia into nr_seq_pacote_servico_w;
					
					vet_servico_pacote_w[k].nr_sequencia := nr_seq_pacote_servico_w;
											
					-- REGRA tp_item Se id_serv = 1 ou 3, obrigatorio preenchimento desse campo com 6 - Procedimentos
					if ( id_serv_w in (1 ,3) and tp_item_w <> 6 ) then
						t_inconsistencia('tp_item_w') := 956872;					
					end if;
					
					-- REGRA vl_Serv
					if ( vl_serv_w = 0 and ( ( id_serv_w = 1 and ie_honorario_w = 'S' ) or tp_item_w = 7 ) ) then
						t_inconsistencia('vl_Serv') := 956868;					
					end if;

					-- REGRA ds_Servico
					if ( ( vet_servico_pacote_w[k].tp_Tabela in (2, 5, 19) or vet_servico_pacote_w[k].cd_Servico in (99999935, 99999927, 99999943, 99999919, 99999999) )
						and vet_servico_pacote_w[k]coalesce(.ds_Servico::text, '') = '' ) then
						t_inconsistencia('ds_Servico') := 956866;					
					end if;

					-- REGRA cd_Servico
					if (vet_servico_pacote_w[k].tp_item = 7 and vet_servico_pacote_w[k]coalesce(.cd_Servico::text, '') = '' ) then						
						t_inconsistencia('cd_Servico') := 956864;
					end if;
					
					-- Valida codigo generico para o servico
					if ( not(id_serv_w = 2 and vet_servico_pacote_w[k].tp_item in (1, 4, 5, 7)) and vet_servico_pacote_w[k].cd_Servico in (99999935, 99999927, 99999943, 99999919, 99999999) ) then						
						t_inconsistencia('cd_Servico') := 956862;					
					end if;
																	
					-- REGRA Unidade_Medida
					if ( vet_servico_pacote_w[k].tp_item = 5 and  vet_servico_pacote_w[k]coalesce(.Unidade_Medida::text, '') = '' ) then
						t_inconsistencia('Unidade_Medida') := 956860;					
					end if;	

					--- verifica se existe inconsistencia para os itens
					
					if (t_inconsistencia.count > 0) then
						CALL ptu_a1200_imp_pck.insere_inconsistencias(t_inconsistencia, nr_seq_pacote_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_pacote_servico_w, 'ptu_pacote_servico');
						
						t_inconsistencia.delete;
						
					end if;	
										
					-- REGRA quando um vl_Serv tiver valor, todos os vl_Serv dos demais itens devem ser preenchidos
					if ( k  = vet_servico_pacote_w.count ) then
						for i in 1..vet_servico_pacote_w.count loop
							begin						
								if ( i <= vet_servico_pacote_w.count ) then
									if ( (vet_servico_pacote_w[i].vl_serv)::numeric  = 0 and vl_serv_count > 0) then										
										t_inconsistencia('vl_Serv-itens') := 956868;
										CALL ptu_a1200_imp_pck.insere_inconsistencias(t_inconsistencia, nr_seq_pacote_p, nm_usuario_p, cd_estabelecimento_p, vet_servico_pacote_w[i].nr_sequencia, 'ptu_pacote_servico');
									end if;
								end if;
							end;
						end loop;
						
						if (t_inconsistencia.count > 0) then
							CALL ptu_a1200_imp_pck.insere_inconsistencias(t_inconsistencia, nr_seq_pacote_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_pacote_reg_w, 'ptu_pacote_reg');						
							t_inconsistencia.delete;
						end if;
					end if;
				end loop;
				
				-- Prestadores
				for k in 1..vet_prestador_w.count loop

					vet_prestador_w[k].cd_cgc_cpf  := coalesce(vet_prestador_cd_cnpj_cpf_w[k].cd_cpf, vet_prestador_cd_cnpj_cpf_w[k].cd_cnpj);
					
					insert into 	ptu_pacote_prest(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_pacote_reg,
							cd_unimed_prestador,
							cd_prestador,
							nm_prestador,
							cd_cgc_cpf,
							nr_seq_prestador,
							cd_cnes_prest)
					values (nextval('ptu_pacote_prest_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_pacote_reg_w,
							vet_prestador_w[k].cd_Uni_Prest,
							vet_prestador_w[k].cd_Prest,
							vet_prestador_w[k].nm_Prestador,
							vet_prestador_w[K].cd_cgc_cpf,
							null,
							vet_prestador_w[k].cd_CNES) returning nr_sequencia into nr_seq_pacote_prest_w;

					-- REGRA cd_cgc_cpf  Obrigatorio o preenchimento de um dos campos quando nao informado o codigo do prestador
					if ( vet_prestador_w[k]coalesce(.cd_Prest::text, '') = '' and ( vet_prestador_cd_cnpj_cpf_w[k]coalesce(.cd_cpf::text, '') = '' and
										       vet_prestador_cd_cnpj_cpf_w[k]coalesce(.cd_cnpj::text, '') = '') ) then
						t_inconsistencia('cd_cnpj_cpf') := 956858;						
					end if;
					
					--- verifica se existe inconsistencia para os itens
					if (t_inconsistencia.count > 0) then
						
						CALL ptu_a1200_imp_pck.insere_inconsistencias(t_inconsistencia, nr_seq_pacote_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_pacote_prest_w, 'ptu_pacote_prest');
						
						t_inconsistencia.delete;
						
					end if;
							
				end loop;
				
		end loop;
		
	end loop;
		
	commit;
	
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_a1200_imp_pck.carregar_xml ( nr_seq_arq_xml_p ptu_aviso_arq_xml.nr_sequencia%type, ie_tipo_arquivo_p ptu_aviso_arq_xml.ie_tipo_arquivo%type, nm_usuario_p usuario.nm_usuario%type, nm_arquivo_p ptu_pacote.ds_arquivo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_pacote_p INOUT bigint) FROM PUBLIC;
